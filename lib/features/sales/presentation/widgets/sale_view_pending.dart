import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/sales/data/models/pending_model.dart';
import 'package:devsalesxpert/features/sales/data/models/sales_usermodel.dart';

class SaleItemViewPending extends StatefulWidget {
  final PendingModel item;
  final int? index;
  const SaleItemViewPending({super.key, required this.item, this.index});

  @override
  State<SaleItemViewPending> createState() => _SaleItemViewPendingState();
}

class _SaleItemViewPendingState extends State<SaleItemViewPending> {
  SalesItemModel? saleData;
  final List<SalesItemModel> _saleorderList = [];
  bool inprogressssalesitem = false;
  bool deleteinprogresssale = false;

  Future<void> fetchSaleItemView() async {
    inprogressssalesitem = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.salesItemViewUrl(widget.item.id.toString()),
      token: AuthController.accessToken,
    );
    if (response.isSuccess) {
      // _saleorderList.clear();
      final responseData = response.responseData;

      // 1. Sale Map for object
      if (responseData['data']['sale'] != null) {
        final saleJson = responseData['data']['sale'];
        saleData = SalesItemModel.fromSaleJson(
          saleJson,
        ); // ম্যাপ থেকে মডেলে কনভার্ট
      }

      // 2. Items List
      final List<dynamic> itemsList = responseData['data']['items'];
      for (var itemJson in itemsList) {
        final itemModel = SalesItemModel.fromItemJson(itemJson);
        _saleorderList.add(itemModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    inprogressssalesitem = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSaleItemView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          "Sales Item view",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.1,
                        ), // Soft shadow color
                        spreadRadius: 2, // How far the shadow spreads
                        blurRadius: 4, // How soft the shadow looks
                        offset: const Offset(
                          0,
                          4,
                        ), // Shifts shadow down (X, Y) to look raised
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            ":: Sales Order ::",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: buildInfoRow(
                                "Invoice No",
                                saleData?.memoNo ?? "",
                              ),
                            ),
                          ],
                        ),

                        buildInfoRow("Order Date", saleData?.saleDate ?? ""),
                        buildInfoRow(
                          "Delivery Date",
                          saleData?.receiveDate ?? "",
                        ),

                        buildInfoRow(
                          "Payment Mode",
                          saleData?.paymentTypeText?.toString() ?? "",
                        ),
                        buildInfoRow(
                          "Collection Mode",
                          saleData?.collectionMode?.toString() ?? "",
                        ),
                        buildInfoRow("Sales By", saleData?.employeeName ?? ""),
                        buildInfoRow("Customer", saleData?.partyName ?? ""),
                        buildInfoRow(
                          "Address",
                          saleData?.deliveryAddress ?? "",
                        ),
                        buildInfoRow(
                          "Order Status",
                          saleData?.statusText ?? "",
                        ),

                        // FOR SALE ITEM API ANOTHER API
                        buildInfoRow(
                          "Discount",
                          "${saleData?.grossDiscount.toString()} %",
                        ),
                        SizedBox(height: 10),

                        /// sale order api done............................................................

                        // Table Headers
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Item",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Details",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Qty",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Unit",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Price",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Amount",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                              child: Divider(
                                color: Color(0xFF57F1FF),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        // Attendance List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(),
                          itemCount: _saleorderList.length,
                          itemBuilder: (context, index) {
                            final item = _saleorderList[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Expanded(
                                      //   flex: 4,
                                      //   child: Text(
                                      //     item.itemName!,
                                      //     style: const TextStyle(fontSize: 10),
                                      //   ),
                                      // ),
                                      // Expanded(
                                      //   flex: 5,
                                      //   child: Text(
                                      //     item.itemCode!,
                                      //     textAlign: TextAlign.center,
                                      //     style: const TextStyle(fontSize: 10),
                                      //   ),
                                      // ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          _buildItemText(item),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          item.groupName ?? "",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          item.quantity.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          item.uom!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          item.itemRate.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          item.totalAmount.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),

                                      // Expanded(
                                      //   flex: 5,
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       Get.to(
                                      //         () => AddItemUpdateScreen(
                                      //           index: item.id,
                                      //           item: item,
                                      //         ),
                                      //       );
                                      //     },
                                      //     child: Icon(
                                      //       Icons.edit,
                                      //       color: Colors.deepPurpleAccent,
                                      //       size: 18,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                  child: Divider(
                                    color: Color(0xFF57F1FF),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Spacer(), // এটি পুরো কন্টেন্টকে ডান পাশে রাখবে
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // লেবেল এবং ভ্যালু বাম দিক থেকে সমান থাকবে
                              children: [
                                buildInfoRowEqual(
                                  "Gross Total",
                                  saleData?.grossTotal.toString() ?? "",
                                ),

                                buildInfoRowEqual(
                                  "Discount",
                                  saleData?.grossDiscountAmount.toString() ??
                                      "",
                                ),

                                buildInfoRowEqual(
                                  "Invoice Amount",
                                  saleData?.netTotal.toString() ?? "",
                                ),

                                buildInfoRowEqual(
                                  "Collection",
                                  saleData?.collectionAmount.toString() ?? "",
                                ),

                                Container(
                                  height: 1,
                                  width: 180,
                                  color: Colors.grey.shade400,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                ),
                                buildInfoRowEqual(
                                  "Order Balance",
                                  saleData?.dueAmount.toString() ?? "",
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 5),

                        buildInfoRow("Remarks", saleData?.remarks ?? ""),

                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // widget
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontSize: 12)),
          ),
          Text(
            " : ",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // String _buildItemText(dynamic items) {
  //   String text = items.itemCode ?? "";

  //   if (items.itemName != null &&
  //       items.itemName!.isNotEmpty &&
  //       items.itemName != "N/A") {
  //     text += " - ${items.itemName}";
  //   }

  //   if (items.attributeId != null &&
  //       items.attributeId!.toString().isNotEmpty &&
  //       items.attributeId != "N/A") {
  //     text += " - ${items.attributeName}";
  //   }

  //   return text;
  // }

  String _buildItemText(dynamic items) {
    // At the beginning just take the item code and trim the surrounding spaces
    String itemCode = (items.itemCode ?? "").toString().trim();
    String text = itemCode;

    if (items.itemName != null) {
      String name = items.itemName!.toString().trim();
      if (name.isNotEmpty && name != "N/A") {
        // Only add a hyphen if the item code already exists.
        text += (text.isNotEmpty ? " - " : "") + name;
      }
    }

    if (items.attributeName != null) {
      String attr = items.attributeName!.toString().trim();
      if (attr.isNotEmpty && attr != "N/A") {
        // Only add a hyphen if the text already contains something (code or name)
        text += (text.isNotEmpty ? " - " : "") + attr;
      }
    }

    return text;
  }

  // সংশোধিত ফাংশন
  Widget buildInfoRowEqual(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(fontSize: 10)),
          ),

          Text(
            "= ",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),

          SizedBox(
            width: 60, // আপনার প্রয়োজন অনুযায়ী উইডথ বাড়িয়ে কমিয়ে নিন
            child: Text(
              value,
              textAlign: TextAlign.right, // এখান থেকে রাইট অ্যালাইন হবে
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
