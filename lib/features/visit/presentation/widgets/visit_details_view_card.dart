import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/visit/data/models/visit_and_spot_visit_usermodel.dart';

class VisitDetailsCard extends StatefulWidget {
  final VisitSpotModel item;
  final int cardIndex;
  final VoidCallback? onEditTap;

  const VisitDetailsCard({
    super.key,
    required this.cardIndex,
    required this.item,
    this.onEditTap,
  });

  @override
  State<VisitDetailsCard> createState() => _VisitDetailsCardState();
}

class _VisitDetailsCardState extends State<VisitDetailsCard> {
  /// ---------- SAFE DATE ----------
  String formatDate(String? date) {
    try {
      if (date == null || date.isEmpty) {
        return "--";
      }
      DateTime dt;
      // Try ISO parse first, then common 'dd-MM-yyyy' format
      try {
        dt = DateTime.parse(date);
      } catch (e) {
        try {
          dt = DateFormat('dd-MM-yyyy').parse(date);
        } catch (e) {
          return "--";
        }
      }

      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (e) {
      return "--";
    }
  }

  /// ---------- SAFE TIME ----------
  String formatTime(String? time) {
    try {
      if (time == null || time.isEmpty) {
        return "--";
      }

      DateTime dt;
      // If already in AM/PM format
      if (time.contains("AM") || time.contains("PM")) {
        try {
          dt = DateFormat('hh:mm a').parse(time);
        } catch (e) {
          return "--";
        }
      } else {
        // Try to parse as HH:mm:ss or HH:mm
        try {
          dt = DateTime.parse("2026-01-01 $time");
        } catch (e) {
          try {
            dt = DateFormat('HH:mm').parse(time);
          } catch (e) {
            return "--";
          }
        }
      }

      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return "--";
    }
  }

  bool inprogressactualvisit = false;

  // API থেকে আসা আপডেট ডেটা এখানে সেভ হবে
  VisitSpotModel? updatedVisitDetail;

  Future<void> _fetchActualVisitList() async {
    if (!mounted) return;

    setState(() {
      inprogressactualvisit = true;
    });

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.visitSpotGetUrl(widget.item.id.toString()),
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
    _fetchActualVisitList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String visitType = widget.item.visitType ?? "N/A";
    final displayItem = updatedVisitDetail ?? widget.item;

    return Card(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.9),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- HEADER ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  visitType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                if (widget.onEditTap != null)
                  InkWell(
                    onTap: widget.onEditTap,
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Color(0xFF7F2AFF),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            /// ---------- DATE ----------
            buildInfoRow("Visit Date", displayItem.visitDate ?? "--"),

            /// ---------- PURPOSE ----------
            buildInfoRow(
              "Purpose",
              widget.item.visitPurpose ?? "--",
              fontWeight: FontWeight.w500,
            ),

            /// ---------- MEETING ONLY ----------
            if (visitType == "Meeting") ...[
              buildInfoRow("Client Name", displayItem.clientName ?? "--"),
              buildInfoRow("Contact Person", displayItem.contactPerson ?? "--"),
              buildInfoRow("Mobile", widget.item.contactPersonMobile ?? "--"),
            ],

            /// ---------- TIME ----------
            buildInfoRow("Time (From)", formatTime(displayItem.visitStartTime)),
            buildInfoRow("Time (To)", formatTime(displayItem.visitEndTime)),

            /// ---------- LOCATION ----------
            buildInfoRow("Location (From)", displayItem.visitFrom ?? "--"),
            buildInfoRow("Location (To)", displayItem.visitTo ?? "--"),
            buildInfoRow("Note", displayItem.remarks ?? "--"),

            /// ---------- STATUS ----------
            if (displayItem.status != null)
              buildInfoRow(
                "Status",
                widget.item.status ?? "--",
                valueColor: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
          ],
        ),
      ),
    );
  }

  /// ---------- COMMON ROW ----------
  Widget buildInfoRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          Text(
            " : ",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: valueColor,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
