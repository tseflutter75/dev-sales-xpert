import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/sales/data/models/pending_model.dart';
import 'package:devsalesxpert/features/sales/data/models/sales_usermodel.dart';
import 'package:devsalesxpert/features/sales/presentation/screens/add_item_entry_screen.dart';
import 'package:devsalesxpert/features/sales/presentation/screens/add_item_update_screen.dart';
import 'package:devsalesxpert/features/sales/presentation/screens/sales_order_update_screen.dart';
import 'package:devsalesxpert/features/sales/presentation/widgets/sale_view_pending.dart';

class SalesOrderPendingCard extends StatefulWidget {
  final PendingModel item;
  final int index;
  final VoidCallback onRefresh;
  final VoidCallback onRefreshSaleEditEntryback;
  final VoidCallback onRefreshItemEntryback;
  final VoidCallback onRefreshItemUpdateback;
  final VoidCallback SaleDelete;
  final VoidCallback ItemDelete;

  const SalesOrderPendingCard({
    super.key,
    required this.item,
    required this.index,
    required this.onRefresh,
    required this.onRefreshItemEntryback,
    required this.onRefreshItemUpdateback,
    required this.onRefreshSaleEditEntryback,
    required this.SaleDelete,
    required this.ItemDelete,
  });

  @override
  State<SalesOrderPendingCard> createState() => _SalesOrderPendingCardState();
}

class _SalesOrderPendingCardState extends State<SalesOrderPendingCard> {
  bool inprogressssalespending = false;
  bool inprogressalesend = false;
  bool deleteinprogresssale = false;
  bool deleteinprogressitem = false;

  SalesItemModel? saleData;
  final List<SalesItemModel> _saleorderList = [];
  bool inprogressssalesitem = false;

  Future<void> fetchSaleItemView() async {
    inprogressssalesitem = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.salesItemViewUrl(widget.item.id.toString()),
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      _saleorderList.clear();
      final responseData = response.responseData['data'];
      final Map<String, dynamic> saleJson = responseData['sale'] ?? {};
      final List<dynamic> itemsList = responseData['items'] ?? [];

      for (var itemJson in itemsList) {
        final Map<String, dynamic> combinedMap = {
          ...saleJson, // সেলের সব ডেটা ঢুকলো
          ...itemJson, // আইটেমের সব ডেটা ঢুকলো এবং common keys (যেমন id) ওভাররাইট হলো
        };

        final itemModel = SalesItemModel(
          // Sales fields
          id: saleJson['id'],
          memoNo: saleJson['memo_no'],
          companyName: saleJson['company_name'],
          netTotal: saleJson['net_total'],
          collectionAmount: saleJson['collection_amount'],
          dueAmount: saleJson['due_amount'],
          grossDiscount: saleJson['gross_discount'],
          grossDiscountAmount: saleJson['gross_discount_amount'],
          grossTotal: saleJson['gross_total'],

          // Item fields
          Iid: itemJson['id'], // এটিই আপনার ডিলিট করার ID (176)
          itemId: itemJson['item_id'],
          attributeId: itemJson['attribute_id'],
          attributeName: itemJson['attribute_name'],
          groupId: itemJson['group_id'],
          groupName: itemJson['group_name'],
          itemName: itemJson['item_name'],
          itemCode: itemJson['item_code'],
          uom: itemJson['uom'],
          quantity: itemJson['quantity'],
          itemRate: itemJson['item_rate'],
          totalAmount: itemJson['total_amount'],
        );

        _saleorderList.add(itemModel);
      }

      if (_saleorderList.isNotEmpty) {
        saleData = _saleorderList.first;
      }
    } else {
      // Error SnackBar logic...
    }

    inprogressssalesitem = false;
    if (mounted) setState(() {});
  }

  final List<PendingModel> _salependingList = [];
  Future<void> getsalesOrderPending() async {
    inprogressssalespending = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.salespendingUrl,
      token: AuthController.accessToken,
    );
    if (response.isSuccess) {
      _salependingList.clear();
      final visitpendingdata = response.responseData;
      for (Map<String, dynamic> visitpendingjosn
          in visitpendingdata['data']['sales']) {
        final visitpendingmodelall = PendingModel.fromJson(visitpendingjosn);
        _salependingList.add(visitpendingmodelall);
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
    inprogressssalespending = false;
    setState(() {});
  }

  // sale_SEND POST
  Future<void> _SaleSendToHistory() async {
    if (inprogressalesend) return;

    inprogressalesend = true;

    setState(() {});

    final Map<String, dynamic> requestBody = {"id": widget.item.id.toString()};

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.saleSendUrl(widget.item.id.toString()),
      body: requestBody,
      token: AuthController.accessToken,
    );

    print(response.responseData);
    print(response.responseCode);

    if (response.isSuccess && response.responseData["success"] == true) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Color(0xFF00A8AA),

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
      inprogressalesend = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSaleItemView();
  }

  @override
  Widget build(BuildContext context) {
    print("helloooooooooooooooooooooooooo BANGLADESH");
    print("sale id = ${saleData?.id.toString()}");
    print("sale item id = ${saleData?.Iid.toString()}");
    print("item name = ${saleData?.itemId.toString()}");

    var item = widget.item;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: buildInfoRow("Invoice No", item.orderNo ?? "")),

                InkWell(
                  onTap: () => Get.to(
                    () => SaleItemViewPending(index: item.id, item: item),
                  ),
                  child: const Icon(Icons.remove_red_eye, color: Colors.blue),
                ),

                SizedBox(width: 5),

                InkWell(
                  onTap: () async {
                    var updated = await Get.to(
                      () => SalesOrderUpdateScreen(item: item, index: item.id),
                    );
                    if (updated == true) {
                      widget.onRefreshSaleEditEntryback();

                      setState(() {});
                    }
                  },
                  child: Icon(Icons.edit, color: Colors.deepPurpleAccent),
                ),

                SizedBox(width: 5),

                GestureDetector(
                  onTap: () async {
                    // 1️⃣ Show confirmation dialog
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirm deletion?"),
                        content: Text("Are you sure you want to delete this?"),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false), // No
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(result: true), // Yes
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF8F66DC),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    // 2️⃣ If user pressed No or dismissed dialog, return
                    if (confirm != true) return;

                    await _saleDelete();

                    widget.SaleDelete();
                    if (mounted) {
                      setState(() {});
                    }
                  },

                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),

            buildInfoRow("Order Date", item.saleDate ?? ""),
            buildInfoRow("Delivery Date", item.receiveDate ?? ""),
            buildInfoRow("Payment Mode", item.paymentTypeText ?? ""),
            buildInfoRow("Collection Mode", item.collectionMood ?? ""),
            buildInfoRow("Sales By", item.createdByName ?? ""),
            buildInfoRow("Customer", item.partyName ?? ""),
            buildInfoRow("Address", item.deliveryAddress ?? ""),
            buildInfoRow("Order Status", item.statusText ?? ""),

            // FOR SALE ITEM API ANOTHER API
            buildInfoRow("Discount", "${saleData?.grossDiscount.toString()} %"),

            SizedBox(height: 10),

            // Table Headers
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(
                        flex: 5,
                        child: Text(
                          "Item",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
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

                      Expanded(
                        flex: 5,
                        child: Text(
                          "Action",
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
                  child: Divider(color: Colors.grey.shade200, thickness: 1),
                ),
              ],
            ),

            //  List
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(),
              itemCount: _saleorderList.length,
              itemBuilder: (context, index) {
                final items = _saleorderList[index];

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              _buildItemText(items),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text(
                              items.groupName ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              items.quantity.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              items.uom ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              items.itemRate.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              items.totalAmount.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),

                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var updated = await Get.to(
                                      () => AddItemUpdateScreen(
                                        item: items,
                                        saleitemid: items.Iid,
                                        saleid: item.id, // sale item id
                                      ),
                                    );

                                    if (updated == true) {
                                      widget.onRefreshItemUpdateback();
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.deepPurpleAccent,
                                    size: 18,
                                  ),
                                ),

                                InkWell(
                                  onTap: () async {
                                    // 1️⃣ Show confirmation dialog
                                    bool? confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Confirm deletion?"),
                                        content: Text(
                                          "Are you sure you want to delete this?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: false), // No
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: true), // Yes
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF8F66DC),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    // 2️⃣ If user pressed No or dismissed dialog, return
                                    if (confirm != true) return;

                                    await _itemDelete(items.Iid.toString());

                                    widget.ItemDelete();
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                      child: Divider(color: Colors.grey.shade200, thickness: 1),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(right: 42),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRowEqual(
                        "Gross Total",
                        saleData?.grossTotal.toString() ?? "",
                      ),

                      buildInfoRowEqual(
                        "Discount",
                        saleData?.grossDiscountAmount.toString() ?? "",
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
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      buildInfoRowEqual(
                        "Order Balance",
                        saleData?.dueAmount.toString() ?? "",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),

            buildInfoRow("Remarks", item.remarks ?? ""),

            SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 35,
                    width: 150,
                    child: FilledButton(
                      onPressed: () async {
                        var updated = await Get.to(
                          () => AddItemEntryScreen(
                            item: item,
                            index: item.id,
                            modelName: "GmSale",
                          ),
                        );

                        if (updated == true) {
                          widget.onRefreshItemEntryback();
                          setState(() {});
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.orange;
                            }
                            return const Color(0xFF7F2AFF);
                          },
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all(
                          const Size(370, 50),
                        ),
                        overlayColor: WidgetStateProperty.all(
                          Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        "Add Item",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 4),

                Expanded(
                  child: SizedBox(
                    height: 35,
                    width: 150,
                    child: FilledButton(
                      onPressed: () async {
                        if (_saleorderList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              backgroundColor: Color(0xFF00A8AA),
                              content: Center(
                                child: Text(
                                  "Your list is empty! Cannot send without items.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );

                          return; // লিস্ট ফাঁকা হলে এখানেই ফাংশন বন্ধ করে দিবে
                        }
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Send To Office"),
                            content: Text(
                              "Are you sure you want to sent to office?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false), // No
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true), // Yes
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF8F66DC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        // 2️⃣ If user pressed No or dismissed dialog, return
                        if (confirm != true) return;

                        // list faka thakle jabe na history te

                        await _SaleSendToHistory();
                        widget.onRefresh();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.orange;
                            }
                            return const Color(0xFF7F2AFF);
                          },
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all(
                          const Size(370, 50),
                        ),
                        overlayColor: WidgetStateProperty.all(
                          Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        "Send to Office",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// ---------- STATUS ----------
          ],
        ),
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

  // // delete sale
  Future<void> _saleDelete() async {
    deleteinprogresssale = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.deleteRequest(
      url: Urls.saleDelete(widget.item.id.toString()),
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Color(0xFF00A8AA),

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
    } else {
      // ignore: use_build_context_synchronously
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

    deleteinprogresssale = false;
    setState(() {});
  }

  // delete sale item
  Future<void> _itemDelete(String itemId) async {
    deleteinprogresssale = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.deleteRequest(
      url: Urls.ItemDeleteUrl(itemId),
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Color(0xFF00A8AA),

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
    } else {
      // ignore: use_build_context_synchronously
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

    deleteinprogresssale = false;
    setState(() {});
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

  // Widget buildInfoRowEqual(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 1),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 80,
  //           child: Text(label, style: TextStyle(fontSize: 10)),
  //         ),
  //         Text(
  //           "= ",
  //           style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
  //         ),

  //         Text(value, style: TextStyle(fontSize: 10)),
  //       ],
  //     ),
  //   );
  // }

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
            width: 60,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
