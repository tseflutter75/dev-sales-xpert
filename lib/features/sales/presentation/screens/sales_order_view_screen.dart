import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/sales/data/models/collection_list_model.dart';
import 'package:devsalesxpert/features/sales/data/models/pending_model.dart';
import 'package:devsalesxpert/features/sales/presentation/screens/collection_entry_screen.dart';
import 'package:devsalesxpert/features/sales/presentation/screens/sales_order_entry_screen.dart';
import 'package:devsalesxpert/features/sales/presentation/widgets/sales_collection_list.dart';
import 'package:devsalesxpert/features/sales/presentation/widgets/sales_history_list_card.dart';
import 'package:devsalesxpert/features/sales/presentation/widgets/sales_pending_list_card.dart';

class SalesOrderViewScreen extends StatefulWidget {
  const SalesOrderViewScreen({super.key});

  @override
  State<SalesOrderViewScreen> createState() => _SalesOrderViewScreenState();
}

class _SalesOrderViewScreenState extends State<SalesOrderViewScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool inprogressssalespending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    getsalesOrderPending();
    _collectionListApi();
  }

  final List<PendingModel> _salependingList = [];
  Future<void> getsalesOrderPending() async {
    inprogressssalespending = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.salespendingUrl,
      token: AuthController.accessToken,
    );
    if (!mounted) return;
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

  // collection list api
  bool inprogresscollection = false;
  final List<CollectionModel> _collectionList = [];
  Future<void> _collectionListApi() async {
    inprogresscollection = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.collectionListUrl,
      token: AuthController.accessToken,
    );
    if (!mounted) return;
    if (response.isSuccess) {
      final collectiondata = response.responseData;
      _collectionList.clear();
      for (Map<String, dynamic> convenyancejson
          in collectiondata['data']['collections']) {
        final collectionmodelall = CollectionModel.fromJson(convenyancejson);
        _collectionList.add(collectionmodelall);
      }
    }

    inprogresscollection = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          leading: IconButton(
            padding: EdgeInsets.only(bottom: 51),
            onPressed: () {
              Get.offAll(() => BottomNavControllerScreen());
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Text(
                  "Sales Item View",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        bool? updated = await Get.to(
                          () => SalesOrderEntryScreen(modelName: "GmSale"),
                        );

                        if (updated == true) {
                          getsalesOrderPending();
                        }
                      },
                      child: Container(
                        height: 35,
                        width: 90,
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
                        padding: const EdgeInsets.all(1.5),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              "Add Order",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///
                  ],
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
          centerTitle: true,
          toolbarHeight: 100,

          bottom: TabBar(
            controller: tabController,
            dividerColor: Color(0xFF8F66DC),
            labelColor: const Color(0xFF7F2AFF),
            unselectedLabelColor: Colors.black54,
            indicatorColor: const Color(0xFF7F2AFF),
            tabs: const [
              Tab(text: "Pending"),
              Tab(text: "History"),
              Tab(text: "Collection"),
            ],
          ),
        ),
      ),

      body: ScreenBackground(
        child: TabBarView(
          controller: tabController,
          children: [
            // PENDING TAB
            Visibility(
              visible: inprogressssalespending == false,
              replacement: Center(child: CustomCircularProgressIndicator()),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 16,
                  right: 16,
                  bottom: 90,
                ),
                itemCount: _salependingList.length,
                itemBuilder: (context, index) {
                  var item = _salependingList[index];
                  return SalesOrderPendingCard(
                    item: item,
                    index: index,
                    onRefresh: () {
                      getsalesOrderPending();
                    },

                    // item entry edit
                    onRefreshItemEntryback: () {
                      getsalesOrderPending();
                    },

                    onRefreshItemUpdateback: () {
                      getsalesOrderPending();
                    },
                    onRefreshSaleEditEntryback: () {
                      getsalesOrderPending();
                    },

                    SaleDelete: () {
                      getsalesOrderPending();
                      setState(() {});
                    },
                    ItemDelete: () {
                      getsalesOrderPending();
                      setState(() {});
                    },
                  );
                },
              ),
            ),

            // HISTORY TAB........................................................................
            SingleChildScrollView(
              child: Column(
                children: [const SizedBox(height: 10), SalesOrderHistoryCard()],
              ),
            ),

            // COLLECTION TAB.......................................................................
            Column(
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    var result = await Get.to(() => CollectionEntryScreen());

                    if (result == true) {
                      await _collectionListApi();

                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    height: 35,
                    width: 100,
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
                    padding: const EdgeInsets.all(1.5),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),

                      child: Center(
                        child: Text(
                          "Collection Add",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      // Table Headers
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 4,
                              child: Text(
                                "MR",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Customer",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 4,
                              child: Text(
                                "Mode",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Text(
                                "Action",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 5,
                        child: Divider(color: Color(0xFF57F1FF), thickness: 1),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Visibility(
                    visible: inprogresscollection == false,
                    replacement: Center(
                      child: CustomCircularProgressIndicator(),
                    ),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(),
                      itemCount: _collectionList.length,
                      itemBuilder: (context, index) {
                        // final reverseIndex = _datalist.length - 1 - index;

                        var item = _collectionList[index];

                        return SalesOrderCollectionList(
                          item: item,
                          index: index,

                          onDelete: () async {
                            setState(() {
                              _collectionListApi();
                            });
                          },
                          onEditCollection: () async {
                            setState(() {
                              _collectionListApi();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
