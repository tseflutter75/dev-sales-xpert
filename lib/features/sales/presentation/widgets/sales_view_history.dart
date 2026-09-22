import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/sales/data/models/history_model.dart';
import 'package:devsalesxpert/features/sales/data/models/sales_usermodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SaleItemViewHistory extends StatefulWidget {
  final SaleHistoryModel item;

  final int? index;
  const SaleItemViewHistory({super.key, required this.item, this.index});

  @override
  State<SaleItemViewHistory> createState() => _SaleItemViewHistoryState();
}

class _SaleItemViewHistoryState extends State<SaleItemViewHistory> {
  SalesItemModel? saleData;
  final List<SalesItemModel> _saleorderList = [];
  bool inprogressssalesitem = false;

  Future<void> fetchSaleItemViewHistory() async {
    inprogressssalesitem = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.salesItemViewUrl(widget.item.id.toString()),
      token: AuthController.accessToken,
    );
    if (response.isSuccess) {
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

  // dwonload invoice pdf  api function
  bool dwonloadInvoiceProgess = false;
  Future<void> salesInvoiceItemDwonload() async {
    if (dwonloadInvoiceProgess) return;

    setState(() {
      dwonloadInvoiceProgess = true;
    });

    try {
      final url = Urls.salesItemDwonloadUrl(widget.item.id.toString());

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthController.accessToken}',
          'Accept': 'application/pdf',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        await downloadPdf(
          response.bodyBytes,
          fileName: 'Invoice_${widget.item.id}.pdf',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text('Download failed: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Invoice API error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text('Download failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          dwonloadInvoiceProgess = false;
        });
      }
    }
  }

  // share invoice api function
  bool shareInvoiceProgess = false;
  Future<void> shareInvoicePdf() async {
    if (dwonloadInvoiceProgess) return;

    setState(() {
      shareInvoiceProgess = true;
    });

    try {
      final url = Urls.salesItemDwonloadUrl(widget.item.id.toString());

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthController.accessToken}',
          'Accept': 'application/pdf',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();

        final file = File('${directory.path}/Invoice_${widget.item.id}.pdf');

        await file.writeAsBytes(response.bodyBytes, flush: true);

        await SharePlus.instance.share(
          ShareParams(
            text: 'Sales Invoice',
            files: [XFile(file.path, mimeType: 'application/pdf')],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Unable to share invoice: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Share invoice error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Share failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          shareInvoiceProgess = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSaleItemViewHistory();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              ":: Sales Order ::",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            Spacer(),

                            GestureDetector(
                              onTap: dwonloadInvoiceProgess
                                  ? null
                                  : salesInvoiceItemDwonload,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: dwonloadInvoiceProgess
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.download_rounded,
                                        color: Color(0xFF007AFF),
                                        size: 20,
                                      ),
                              ),
                            ),

                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: shareInvoiceProgess
                                  ? null
                                  : shareInvoicePdf,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.share_rounded,
                                  color: Color(0xFF007AFF),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
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
                                          item.groupName!,
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
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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

  // dwonload function
  Future<void> downloadPdf(Uint8List bytes, {String? fileName}) async {
    try {
      Directory directory;

      if (Platform.isAndroid) {
        // Android 9 বা নিচে permission
        final deviceInfo = await DeviceInfoPlugin().androidInfo;

        if (deviceInfo.version.sdkInt < 29) {
          final permission = await Permission.storage.request();

          if (!permission.isGranted) {
            throw Exception('Storage permission denied');
          }
        }

        directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final name =
          fileName ?? 'Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final file = File('${directory.path}/$name');

      await file.writeAsBytes(bytes, flush: true);

      debugPrint('PDF saved: ${file.path}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF00A8AA),
            content: Text('Invoice downloaded successfully'),
          ),
        );
      }
    } catch (e) {
      debugPrint('PDF download error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text('Download failed: $e'),
          ),
        );
      }
    }
  }
}
