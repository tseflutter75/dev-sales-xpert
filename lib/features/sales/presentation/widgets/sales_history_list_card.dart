import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/sales/data/models/history_model.dart';
import 'package:devsalesxpert/features/sales/presentation/widgets/sales_view_history.dart';

class SalesOrderHistoryCard extends StatefulWidget {
  const SalesOrderHistoryCard({super.key});

  @override
  State<SalesOrderHistoryCard> createState() => _SalesOrderHistoryCardState();
}

class _SalesOrderHistoryCardState extends State<SalesOrderHistoryCard> {
  /// All sales grouped by date
  Map<String, List<SaleHistoryModel>> groupedHistory = {};

  /// Loader flag
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSalesHistory();
  }

  /// STEP 1: API call
  Future<void> fetchSalesHistory() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.saleshistoryUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      prepareSalesData(response.responseData);
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  /// STEP 2: Convert API data → grouped by date
  void prepareSalesData(dynamic apiData) {
    groupedHistory.clear();
    final salelist = apiData['data']['sales']; // api
    // single item
    for (var item in salelist) {
      // json to dart
      final model = SaleHistoryModel.fromJson(item);
      final date = model.saleDate ?? "No Date";

      groupedHistory.putIfAbsent(date, () => []);
      groupedHistory[date]!.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (groupedHistory.isEmpty) {
      return const Center(child: Text("No Sales History Found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedHistory.length,
      itemBuilder: (context, index) {
        final date = groupedHistory.keys.elementAt(index);
        final sales = groupedHistory[date]!;

        final total = calculateTotal(sales);
        final collection = calculateCollection(sales);

        return buildDateCard(date, sales, total, collection);
      },
    );
  }

  /// STEP 3: Card UI per date
  Widget buildDateCard(
    String date,
    List<SaleHistoryModel> sales,
    double total,
    double collection,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Soft shadow color
              spreadRadius: 2, // How far the shadow spreads
              blurRadius: 4, // How soft the shadow looks
              offset: const Offset(
                0,
                4,
              ), // Shifts shadow down (X, Y) to look raised
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoRow("Date", formatDate(date)),
            const Divider(),
            _buildTableHeader(),
            for (int i = 0; i < sales.length; i++) _buildDataRow(sales[i], i),
            _buildTotalFooter(total, collection),
          ],
        ),
      ),
    );
  }

  /// STEP 4: Calculations (easy & reusable)
  double calculateTotal(List<SaleHistoryModel> list) {
    double sum = 0;
    for (var item in list) {
      sum += double.tryParse(item.totalAmount.toString()) ?? 0;
    }
    return sum;
  }

  double calculateCollection(List<SaleHistoryModel> list) {
    double sum = 0;
    for (var item in list) {
      sum += double.tryParse(item.collectionAmount.toString()) ?? 0;
    }
    return sum;
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "SL",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Invoice",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Customer",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Total",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Coll.",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "View",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(SaleHistoryModel item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("${index + 1}", style: const TextStyle(fontSize: 10)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.orderNo ?? "N/A",
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.partyName ?? "N/A",
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${item.grandTotal ?? 0}",
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${item.collectionAmount ?? 0}",
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () =>
                  Get.to(() => SaleItemViewHistory(item: item, index: index)),
              child: const Icon(
                Icons.remove_red_eye,
                size: 16,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalFooter(double total, double coll) {
    final numberFormatter = NumberFormat('#,##0');
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(5),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          const Expanded(
            flex: 12,
            child: Text(
              "Total:",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              numberFormatter.format(total),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              numberFormatter.format(coll),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Text(
      "$label: $value",
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    );
  }

  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
