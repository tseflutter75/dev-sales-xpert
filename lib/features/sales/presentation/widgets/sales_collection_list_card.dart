// import 'package:attendenceapp/Data/model/sales%20model/collection_list_model.dart';
// import 'package:attendenceapp/Data/service/api_caller.dart';
// import 'package:attendenceapp/Data/utils/base_url.dart';
// import 'package:attendenceapp/Ui/Screens/Bottom%20Nav%20Screens/Sales%20Order/collection/collection_update.dart';
// import 'package:attendenceapp/Ui/controller/AuthController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class SalesOrderCollectionListCard extends StatefulWidget {
//   final CollectionModel item;
//   final int index;
//   final String date;
//   final List<CollectionModel> collectionList;
//   final VoidCallback onDelete;
//   final VoidCallback onEditCollection;

//   const SalesOrderCollectionListCard({
//     super.key,
//     required this.item,
//     required this.index,
//     required this.onDelete,
//     required this.onEditCollection,
//     required this.collectionList,
//     required this.date,
//   });

//   @override
//   State<SalesOrderCollectionListCard> createState() =>
//       _SalesOrderCollectionListCardState();
// }

// class _SalesOrderCollectionListCardState
//     extends State<SalesOrderCollectionListCard> {
//   bool inprogresssvisitspotstrore = false;
//   bool inprogrssspotView = false;
//   bool deleteinprogresscollection = false;

//   bool inprogresscollection = false;

//   Future<void> collectionDelete(String collectionId) async {
//     deleteinprogresscollection = true;
//     setState(() {});

//     ApiResponse response = await ApiCaller.deleteRequest(
//       url: Urls.collectionDelete(collectionId),
//       token: AuthController.accessToken,
//     );

//     if (response.isSuccess && response.responseData["success"] == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           duration: const Duration(seconds: 2),
//           backgroundColor: Color(0xFF00A8AA),

//           content: Center(
//             child: Text(
//               response.errorMessage,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           duration: const Duration(seconds: 2),
//           backgroundColor: Colors.red,

//           content: Center(
//             child: Text(
//               response.errorMessage,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     deleteinprogresscollection = false;
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("hellooooooooooooooooooooo");
//     var item = widget.item;
//     print(item.status);

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade200),
//       ),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 4,
//                   child: Text(
//                     formatDate(item.collectionDate!),

//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 ),

//                 Expanded(
//                   flex: 4,
//                   child: Text(item.mrNo!, style: const TextStyle(fontSize: 10)),
//                 ),

//                 Expanded(
//                   flex: 4,
//                   child: Text(
//                     item.partyName.toString(),

//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 4,
//                   child: Text(
//                     item.collectionMode.toString(),

//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 ),

//                 Expanded(
//                   flex: 3,
//                   child: Text(
//                     item.collectionAmount.toString(),

//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 ),

//                 // status checking...
//                 // item.status.toString() ব্যবহার করা নিরাপদ যাতে Int/String এরর না হয়
//                 item.status.toString() != "1"
//                     ? Expanded(
//                         flex: 3,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment
//                               .spaceEvenly, // আইকনগুলো সমান দূরত্বে রাখবে
//                           children: [
//                             GestureDetector(
//                               onTap: () async {
//                                 var update = await Get.to(
//                                   () => CollectionUpdateScreen(
//                                     item: item,
//                                     index: item.id,
//                                   ),
//                                 );

//                                 if (update == true) {
//                                   widget.onEditCollection();
//                                   if (mounted) setState(() {});
//                                 }
//                               },
//                               child: Icon(
//                                 Icons.edit,
//                                 size: 20,
//                                 color: Colors.deepPurpleAccent,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () async {
//                                 bool? confirm = await showDialog<bool>(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text("Confirm deletion?"),
//                                     content: Text(
//                                       "Are you sure you want to delete this?",
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Get.back(result: false),
//                                         child: Text(
//                                           "No",
//                                           style: TextStyle(
//                                             color: Colors.red,
//                                             fontSize: 18,
//                                           ), // ফন্ট সাইজ একটু কমানো হয়েছে যাতে মোবাইল স্ক্রিনে ধরে
//                                         ),
//                                       ),
//                                       TextButton(
//                                         onPressed: () => Get.back(result: true),
//                                         child: Text(
//                                           "Yes",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             color: Color(0xFF8F66DC),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );

//                                 if (confirm != true) return;

//                                 await collectionDelete(item.id.toString());
//                                 widget.onDelete();
//                                 if (mounted) setState(() {});
//                               },
//                               child: Icon(
//                                 Icons.delete,
//                                 size: 20,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : Expanded(
//                         flex: 3,
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: Text(
//                             "Approved",
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 5,
//             child: Divider(color: Color(0xFF57F1FF), thickness: 1),
//           ),
//           SizedBox(height: 5),
//         ],
//       ),
//     );
//   }

//   String formatDate(String dateString) {
//     // 1. Prothome string-ke DateTime object-e convert koro (Input: 09 Mar, 2026)
//     final DateTime date = DateFormat("dd MMM, yyyy").parse(dateString);

//     // 2. Erpor formatted string return koro (Output: 09--03--2026)
//     return DateFormat('dd--MM--yyyy').format(date);
//   }

//   String formatTimeAmPm(String rawDateTime) {
//     DateTime dateTime = DateTime.parse(rawDateTime);
//     return DateFormat('hh:mm a').format(dateTime);
//   }
// }
