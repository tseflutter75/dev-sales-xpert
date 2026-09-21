import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/visit/data/models/visit_and_spot_visit_usermodel.dart';

class VisitDetailsTapholdCard extends StatefulWidget {
  final VisitSpotModel visitItem;
  final Function(Function refresh)? onCreated;
  const VisitDetailsTapholdCard({
    super.key,
    required this.visitItem,
    this.onCreated,
  });

  @override
  State<VisitDetailsTapholdCard> createState() =>
      _VisitDetailsTapholdCardState();
}

class _VisitDetailsTapholdCardState extends State<VisitDetailsTapholdCard> {
  // bool _isExpanded = false;
  bool inprogressactualvisit = false;

  VisitSpotModel? updatedVisitDetail;

  Future<void> _fetchActualVisitList() async {
    if (!mounted) return;

    setState(() {
      inprogressactualvisit = true;
    });

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.visitSpotGetUrl(widget.visitItem.id.toString()),
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
      final data = response.responseData['data'];
      final Map<String, dynamic> actualvisitJson = data['visit'];

      setState(() {
        updatedVisitDetail = VisitSpotModel.fromVisitJson(actualvisitJson);
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                response.errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        inprogressactualvisit = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchActualVisitList();
    if (widget.onCreated != null) {
      widget.onCreated!(_fetchActualVisitList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayItem = updatedVisitDetail ?? widget.visitItem;

    return Card(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.9),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Action Buttons
            const Text(
              "Actual Visit Details",
              style: TextStyle(
                fontSize: 16,
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),

            // Time Info Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Time",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  height: 2,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
            buildInfoRow(
              "Start",
              "${formatDisplayTime(displayItem.actualVisitStartTime ?? " ")} ${displayItem.actualVisitStartDate ?? " "}"
                  .trim(),
            ),
            buildInfoRow(
              "Reached",
              "${formatDisplayTime(displayItem.visitReachTime ?? " ")} ${displayItem.actualVisitReachedDate ?? " "}"
                  .trim(),
            ),
            buildInfoRow(
              "End",
              "${formatDisplayTime(displayItem.actualVisitEndTime ?? " ")} ${displayItem.actualVisitEndDate ?? " "}"
                  .trim(),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  height: 2,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
            buildInfoRow("Start", displayItem.startAddress ?? " "),
            buildInfoRow("Reached", displayItem.reachAddress ?? " "),
            buildInfoRow("End", displayItem.endAddress ?? " "),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transport",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  height: 2,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
            buildInfoRow("Mode", displayItem.vehicleType ?? " "),
            buildInfoRow("Conveyance", "${displayItem.vehicleBill ?? " "} Tk"),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String formatDisplayTime(String? time) {
    if (time == null || time.isEmpty || time == "null") return "N/A";
    try {
      if (time.contains("AM") || time.contains("PM")) return time;
      return DateFormat(
        'hh:mm a',
      ).format(DateTime.parse("2026-01-01 ${time.trim()}"));
    } catch (e) {
      return time;
    }
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return " ";

    // Attempt to parse step by step
    DateTime? dt = DateTime.tryParse(date);

    if (dt == null) {
      try {
        dt = DateFormat('dd-MM-yyyy').parse(date);
      } catch (_) {
        return " "; // If it cannot be parsed in any way
      }
    }

    return DateFormat('dd-MM-yyyy').format(dt);
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Text(
            " : ",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}


// Expanded Section
            // if (_isExpanded) ...[
            // const Divider(color: Colors.grey, height: 20),
   // Expand Button
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       _isExpanded = !_isExpanded;
                //     });
                //   },
                //   icon: Icon(
                //     _isExpanded ? Icons.expand_less : Icons.expand_more,
                //     color: const Color(0xFF7F2AFF),
                //   ),
                // ),
                  // ],


