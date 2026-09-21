class Urls {
  // static const _baseUrl = "https://software.digonta.space/api";
  static const _baseUrl = "https://dev.bom.hisab-kitab.xyz/api";

  static const loginUrl = "$_baseUrl/auth/login";
  static const updatePasswordUrl = "$_baseUrl/password/update";

  // live tracking
  static const liveTrackingUrl = "$_baseUrl/employee-live-tracking";

  // individual get api drop dwon
  static const employeefromUrl = "$_baseUrl/employees";

  // home screen
  static const savepostattendancetUrl = "$_baseUrl/attendance-store";
  static const phonebookUrl = "$_baseUrl/phone-book";
  static const jobcardUrl = "$_baseUrl/job-card";
  static const calendarUrl = "$_baseUrl/calendar";
  static const noticesUrl = "$_baseUrl/notices";
  static const noticesNotificationUrl = "$_baseUrl/notice-notifications";
  static const attendanceReportUrl = "$_baseUrl/daily-attendance-report";

  // leaveinfo
  static const leavetypefromUrl = "$_baseUrl/leave-types";
  static const leaveHistoryUrl = "$_baseUrl/leave-history";
  static const leaveBalanceUrl = "$_baseUrl/leave-balance";
  static const leaveRequestUrl = "$_baseUrl/leave-store";
  static updateleaveRequestUrl(String id) => "$_baseUrl/leave/edit/$id";
  static deleteleaveRequestUrl(String id) => "$_baseUrl/leave/delete/$id";
  static const leaveCategoryUrl = "$_baseUrl/leave-category-list";

  // visit
  static const visitcustomerUrl = "$_baseUrl/customer/store";
  static const visittranspotUrl = "$_baseUrl/vehicles";
  static const clientfromUrl = "$_baseUrl/client-list";
  static const purposefromUrl = "$_baseUrl/visit-purpose-list";
  static const visitstoreUrl = "$_baseUrl/visit/store";
  static const visitpendingUrl = "$_baseUrl/visit/pending";
  static const visithistoryUrl = "$_baseUrl/visit/history";
  static const conveyanceUrl = "$_baseUrl/conveyance-list";
  static const sentbillApprovalUrl = "$_baseUrl/send-for-approval";

  static visitUpdateUrl(String id) => "$_baseUrl/visit/update/$id";

  static visitstartUrl(String id) => "$_baseUrl/visit/start/$id";
  static visitreachUrl(String id) => "$_baseUrl/visit/reach/$id";
  static visitcompleteUrl(String id) => "$_baseUrl/visit/complete/$id";

  static const visitspotstoreUrl = "$_baseUrl/visit/spot/store";
  static visitSpotUpdateUrl(String id) => "$_baseUrl/visit/spot/update/$id";
  static visitSpotGetUrl(String id) => "$_baseUrl/visit/show/$id";

  // task
  static const taskEntryUrl = "$_baseUrl/task/store";
  static const taskViewUrl = "$_baseUrl/task/store";

  // sales
  static const salesorderEntryUrl = "$_baseUrl/sale/store";
  static additemsalesEntryUrl(String id) => "$_baseUrl/sale/item-store/$id";
  static salesItemViewUrl(String id) => "$_baseUrl/sale/show/$id";
  static const salespendingUrl = "$_baseUrl/sale/pending";
  static const saleshistoryUrl = "$_baseUrl/sale/history";
  static const collectionListUrl = "$_baseUrl/collections";
  static const paymentMoodUrl = "$_baseUrl/sale/payment-list";
  static const itemsListUrl = "$_baseUrl/items";
  static itemsDetailsUrl(String id) => "$_baseUrl/item/show/$id";
  static itemsAttributeListUrl(String id) =>
      "$_baseUrl/item-attribute-list/$id";
  static itemsAttributeDetailsUrl(String id) =>
      "$_baseUrl/item-attribute-details/$id";
  static saleSendUrl(String id) => "$_baseUrl/sale/send-to-office/$id";
  static saleEdit(String id) => "$_baseUrl/sale/update/$id";
  static saleSingleItemEditUrl(String id) => "$_baseUrl/sale/item-update/$id";
  static saleDelete(String id) => "$_baseUrl/sale/delete/$id";
  static ItemDeleteUrl(String id) => "$_baseUrl/sale/item-delete/$id";
  static const collectionEntryUrl = "$_baseUrl/collection/store";
  static collectionUpdateUrl(String id) => "$_baseUrl/collection/update/$id";
  static collectionDelete(String id) => "$_baseUrl/collection/delete/$id";
  static customerDetailsa(String id) => "$_baseUrl/customer/show/$id";
  static fromValueUrl(String model) => "$_baseUrl/form-structure/$model";
  // static const fromValueUrl = "$_baseUrl/form-structure";
  static const brandNameUrl = "$_baseUrl/item-brands";
  static const itemGroupUrl = "$_baseUrl/item-groups";
  static const itemFilterUrl = "$_baseUrl/sale/get-filtered-items";
  static salesItemDwonloadUrl(String id) => "$_baseUrl/sale/invoice/$id";
}
