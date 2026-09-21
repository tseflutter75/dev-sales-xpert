import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/sales/data/models/from_filter_feild.dart';
import 'package:devsalesxpert/features/sales/data/models/item_attribute_details.dart';
import 'package:devsalesxpert/features/sales/data/models/item_attribute_model.dart';
import 'package:devsalesxpert/features/sales/data/models/item_brand_name_model.dart';
import 'package:devsalesxpert/features/sales/data/models/item_filter_model.dart';
import 'package:devsalesxpert/features/sales/data/models/item_group_list_model.dart';
import 'package:devsalesxpert/features/sales/data/models/items_details_model.dart';
import 'package:devsalesxpert/features/sales/data/models/sales_usermodel.dart';

class AddItemUpdateScreen extends StatefulWidget {
  // final int fromTabIndex;
  final SalesItemModel item;
  final int? saleitemid;
  final int? saleid;
  final String? modelName;

  const AddItemUpdateScreen({
    super.key,
    required this.item,
    this.saleitemid,
    this.saleid,
    this.modelName,

    //  this.fromTabIndex = 2
  });

  @override
  State<AddItemUpdateScreen> createState() => _AddItemUpdateScreenState();
}

class _AddItemUpdateScreenState extends State<AddItemUpdateScreen> {
  // Controllers
  final _itemnameController = TextEditingController();
  final _unitController = TextEditingController();
  final _quantityController = TextEditingController();
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool hasUnit = false;

  bool inprogressssalesorderentry = false;

  File? image;

  // brand list api
  final List<ItemBrandNameModel> _itemBrandList = [];
  ItemBrandNameModel? selectedBrandName;
  Future<void> _fetchBrandNameList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.brandNameUrl,
      token: AuthController.accessToken,
    );
    _itemBrandList.clear();
    if (!mounted) return;
    if (response.isSuccess) {
      final BrandData = response.responseData;
      for (Map<String, dynamic> BrandJson in BrandData['data']) {
        final brandModelall = ItemBrandNameModel.fromJson(BrandJson);
        _itemBrandList.add(brandModelall);
      }
      setState(() {});
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
  }

  // item group list api
  final List<ItemGroupListModel> _itemGroupList = [];
  ItemGroupListModel? selectedItemGroup;
  Future<void> _fetchItemGroupList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.itemGroupUrl,
      token: AuthController.accessToken,
    );
    _itemGroupList.clear();
    if (response.isSuccess) {
      final itemData = response.responseData;
      for (Map<String, dynamic> itemGroupJson in itemData['data']) {
        final groupModelall = ItemGroupListModel.fromJson(itemGroupJson);
        _itemGroupList.add(groupModelall);
      }
      setState(() {});
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
  }

  // item filter list api
  final List<ItemFilterModel> _itemFilterList = [];
  ItemFilterModel? selectedItemFilter;

  Future<void> _fetchItemFilterList() async {
    final Map<String, dynamic> requestBody = {
      "brand_id": selectedBrandName?.id,
      "group_id": selectedItemGroup?.id,
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.itemFilterUrl,
      body: requestBody,
      token: AuthController.accessToken,
    );

    _itemFilterList.clear();
    if (response.isSuccess) {
      final filterData = response.responseData;
      for (Map<String, dynamic> itemFilterJson in filterData['data']['items']) {
        final filterModelall = ItemFilterModel.fromJson(itemFilterJson);
        _itemFilterList.add(filterModelall);
      }
      setState(() {});
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
  }

  // // item details get api
  final List<ItemDetailsModel> _itemDetailsList = [];
  ItemDetailsModel? selectedItemDetails;

  Future<void> _fetchItemDetails() async {
    if (selectedItemFilter == null) return;
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.itemsDetailsUrl(
        selectedItemFilter!.id.toString(),
      ), // single item API
      token: AuthController.accessToken,
    );
    _itemDetailsList.clear();
    if (response.isSuccess) {
      final data = response.responseData;

      // যদি API wrapper থাকে: { "success": true, "data": {...} }
      if (data != null && data['data'] != null) {
        selectedItemDetails = ItemDetailsModel.fromJson(data['data']);
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange,
            content: Center(
              child: Text(
                'No item data found',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  // // item attribute get api
  final List<ItemAttribute> _itemAttributeList = [];
  ItemAttribute? selectedAttribute;
  Future<void> _fetchItemAttributeList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.itemsAttributeListUrl(selectedItemFilter!.id.toString()),
      token: AuthController.accessToken,
    );
    _itemAttributeList.clear();
    if (response.isSuccess) {
      final attributeData = response.responseData;
      for (Map<String, dynamic> attributeJson
          in attributeData['data']['attributes']) {
        final attributeModel = ItemAttribute.fromJson(attributeJson);
        _itemAttributeList.add(attributeModel);
      }

      setState(() {});
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
  }

  // // item attribute details get api
  final List<ItemAttributeDetails> _itemAttributeDetailsList = [];
  ItemAttributeDetails? selectedItemArributeDetails;

  Future<void> _fetchItemAttributeDetails() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.itemsAttributeDetailsUrl(
        selectedAttribute!.id.toString(),
      ), // single item API
      token: AuthController.accessToken,
    );
    _itemAttributeDetailsList.clear();

    if (response.isSuccess) {
      final data = response.responseData;

      // যদি API wrapper থাকে: { "success": true, "data": {...} }
      if (data != null && data['data'] != null) {
        selectedItemArributeDetails = ItemAttributeDetails.fromJson(
          data['data'],
        );
        setState(() {});
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange,
            content: Center(
              child: Text(
                'No item data found',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  // from value
  final List<FormFilterField> fromFilterFeildList = [];
  FormFilterField? selectedFromFilterFeild;
  Future<void> _fetchFromFilterFeildList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.fromValueUrl(widget.modelName.toString()),
      token: AuthController.accessToken,
    );
    fromFilterFeildList.clear();
    if (response.isSuccess) {
      final fromFilterFeildData = response.responseData;
      for (Map<String, dynamic> fromFilterFeildJson
          in fromFilterFeildData['data']['form_filter_fields']) {
        final fromFilterFeildModel = FormFilterField.fromJson(
          fromFilterFeildJson,
        );
        fromFilterFeildList.add(fromFilterFeildModel);
      }
      setState(() {});
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
  }

  bool isFieldActive(String column) {
    return fromFilterFeildList.any(
      (f) => f.column == column && f.active == true,
    );
  }

  Future<void> initializeItemData() async {
    // 1. Load the word filler list
    await _fetchItemFilterList();

    if (_itemFilterList.isNotEmpty && widget.item.itemId != null) {
      // 2. Find the current item from the list
      try {
        selectedItemFilter = _itemFilterList.firstWhere(
          (f) => f.id.toString().trim() == widget.item.itemId.toString().trim(),
        );
      } catch (e) {
        selectedItemFilter = null;
      }

      if (selectedItemFilter != null) {
        // 3. Fetch item details (this is necessary to get hasAttribute)
        await _fetchItemDetails();

        if (selectedItemDetails != null) {
          setState(() {
            hasUnit = true;
            _unitController.text = selectedItemDetails!.uomName ?? "";
          });

          // 4. Now it's time to load the attributes (if any)
          if (selectedItemDetails?.hasAttribute == 1) {
            await _fetchItemAttributeList();

            if (_itemAttributeList.isNotEmpty) {
              setState(() {
                selectedAttribute = _itemAttributeList.firstWhere(
                  (e) =>
                      e.id.toString().trim() ==
                      widget.item.attributeId.toString().trim(),
                  orElse: () => _itemAttributeList.first,
                );
              });

              // 5. Get price details of selected attribute
              await _fetchItemAttributeDetails();

              setState(() {
                _priceController.text =
                    selectedItemArributeDetails?.attributePrice?.toString() ??
                    "";
              });
            }
          } else {
            // If there is no attribute, set the item rate directly
            setState(() {
              _priceController.text = widget.item.itemRate.toString();
            });
          }
        }
      }
    }
  }

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
    super.initState();

    fetchSaleItemView();

    _fetchFromFilterFeildList();
    _fetchBrandNameList();
    _fetchItemGroupList();

    // function..
    initializeItemData();

    // 6 Quantity & Amount auto
    _quantityController.text = widget.item.quantity.toString();
    _amountController.text = widget.item.totalAmount.toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(" sale id ${widget.saleid}");
    // print(" sale item id ${widget.saleitemid.toString()}");
    // print(" item id ${selectedItemFilter?.id.toString()}");

    print(
      "Attribute Id.............................${widget.item.attributeId}",
    );

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
          "Update Item",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildInfoRow("Invoice No", saleData?.memoNo ?? ""),
                buildInfoRow("Order Date", saleData?.saleDate ?? ""),
                buildInfoRow("Sales By", saleData?.employeeName ?? ""),
                buildInfoRow("Customer", saleData?.partyName ?? ""),

                SizedBox(height: 10),

                /// start
                // brand
                if (isFieldActive("item_brand")) ...[
                  DropdownSearch<ItemBrandNameModel>(
                    items: _itemBrandList,
                    itemAsString: (ItemBrandNameModel t) =>
                        t.BrandName.toString(),
                    selectedItem: selectedBrandName,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search), // এখানে search icon
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,

                        hintText: "Select Brand Name",
                        labelText: "Brand Name",
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (ItemBrandNameModel? brand) async {
                      setState(() {
                        selectedBrandName = brand;
                        selectedItemFilter = null;
                        selectedAttribute = null;
                        _itemFilterList.clear();
                        _unitController.clear();
                        _priceController.clear();
                        _itemAttributeList.clear();
                        _quantityController.clear();
                        _amountController.clear();
                      });
                      await _fetchItemFilterList();
                    },
                    // validator: (ItemBrandNameModel? client) =>
                    //     client == null ? "Please select a brand name" : null,
                  ),
                  const SizedBox(height: 10),
                ],

                // Group
                if (isFieldActive("item_group")) ...[
                  DropdownSearch<ItemGroupListModel>(
                    items: _itemGroupList,
                    itemAsString: (ItemGroupListModel t) =>
                        t.groupName.toString(),
                    selectedItem: selectedItemGroup,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search), // এখানে search icon
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,

                        hintText: "Select Group Name",
                        labelText: "Group Name",
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (ItemGroupListModel? group) async {
                      setState(() {
                        selectedItemGroup = group;
                        selectedItemFilter = null;
                        selectedAttribute = null;
                        _unitController.clear();
                        _priceController.clear();
                        _itemAttributeList.clear();
                        _quantityController.clear();
                        _amountController.clear();
                        _itemFilterList.clear();
                      });
                      await _fetchItemFilterList();
                    },
                    // validator: (ItemGroupListModel? client) =>
                    //     client == null ? "Please select a group name" : null,
                  ),
                  const SizedBox(height: 10),
                ],

                // select item item filter api
                if (isFieldActive("item_id_search")) ...[
                  DropdownSearch<ItemFilterModel>(
                    items: _itemFilterList,
                    itemAsString: (ItemFilterModel t) {
                      if (t.itemName == null || t.itemName!.isEmpty) {
                        return t.itemCode.toString(); // Shudhu code dekhabe
                      }
                      return "${t.itemCode} - ${t.itemName}";
                    },
                    selectedItem: selectedItemFilter,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search), // এখানে search icon
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,

                        hintText: "Select item",
                        labelText: "Select Item",

                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (ItemFilterModel? filter) async {
                      if (filter != null) {
                        setState(() {
                          selectedItemFilter = filter;
                          selectedItemDetails = null;
                          selectedAttribute = null;
                          _unitController.clear();
                          _priceController.clear();
                          _itemAttributeList.clear();
                          _quantityController.clear();
                          _amountController.clear();
                        });
                        await _fetchItemDetails();

                        // unit bosbe
                        if (selectedItemDetails != null) {
                          _unitController.text =
                              selectedItemDetails!.uomName ?? "";
                          hasUnit = true;
                        }

                        // has att 1 hole has att feild asbe
                        if (selectedItemDetails!.hasAttribute == 1) {
                          await _fetchItemAttributeList();
                        } else if (selectedItemDetails!.hasAttribute == null ||
                            selectedItemDetails!.hasAttribute == 0) {
                          _priceController.text = selectedItemDetails!.price
                              .toString();
                        }

                        await _fetchItemFilterList();
                      }
                    },
                    // validator: (ItemFilterModel? filter) =>
                    //     filter == null ? "Please select a group name" : null,
                  ),
                  const SizedBox(height: 10),
                ],

                SizedBox(height: 10),

                if (hasUnit) ...[
                  TextField(
                    controller: _unitController,
                    readOnly: true, // ❌ user cannot edit
                    decoration: InputDecoration(
                      labelText: "Unit",
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // item attribute drop dwon
                if (selectedItemDetails?.hasAttribute == 1) ...[
                  DropdownSearch<ItemAttribute>(
                    items: _itemAttributeList,
                    itemAsString: (ItemAttribute t) =>
                        t.attributeName.toString(),
                    selectedItem: selectedAttribute,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search), // এখানে search icon

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,

                        hintText: "Select Attribute",
                        labelText: "Select Attribute",
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (ItemAttribute? client) async {
                      if (client != null) {
                        setState(() {
                          selectedAttribute = client;
                          selectedItemArributeDetails = null;
                        });
                      }
                      await _fetchItemAttributeDetails();
                      if (selectedItemArributeDetails?.attributePrice != null) {
                        _priceController.text = selectedItemArributeDetails!
                            .attributePrice
                            .toString();
                      }
                    },
                    // validator: (ItemAttribute? client) =>
                    //     client == null ? "Please select a attribute" : null,
                  ),
                  SizedBox(height: 10),
                ],

                TextFormField(
                  controller: _priceController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'price is required'
                      : null,
                  onChanged: (v) => _calculateTotal(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _quantityController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'quantity is required'
                      : null,
                  onChanged: (v) => _calculateTotal(),
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'amount is required'
                      : null,
                  onChanged: (v) => _calculateTotal(),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Visibility(
                  visible: inprogressssalesorderentry == false,
                  replacement: Center(child: CustomCircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _additemUpdate();
                        Get.back(result: true);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.orange;
                        }
                        return const Color(0xFF7F2AFF);
                      }),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      minimumSize: WidgetStateProperty.all(const Size(370, 50)),
                      overlayColor: WidgetStateProperty.all(
                        Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

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
                      child: Divider(color: Colors.grey.shade200, thickness: 1),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                            color: Colors.grey.shade200,
                            thickness: 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
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

  // ক্লাসের উপরে বা initState-এ
  final _currencyFormat = NumberFormat('#,##0', 'en_US'); // অথবা 'bn_BD'

  // calculate ফাংশনে
  void _calculateTotal() {
    double price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    double quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;

    double total = price * quantity;

    _amountController.text = _currencyFormat.format(total);
  }

  Future<void> _additemUpdate() async {
    if (inprogressssalesorderentry) return;

    inprogressssalesorderentry = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "sale_id": widget.item.id.toString(),
      "item_id": selectedItemFilter!.id.toString(), // item name
      "quantity": _quantityController.text.trim(), // quantity
      "item_unit": _unitController.text.trim(), // unit
      "item_rate": _priceController.text.trim(), // price
      "total_amount":
          double.tryParse(_amountController.text.replaceAll(',', '').trim()) ??
          0.0, // amount
      "attribute_id": selectedAttribute?.id.toString(),
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.saleSingleItemEditUrl(widget.saleitemid.toString()),
      body: requestBody,
      token: AuthController.accessToken,
    );

    print(response.responseData);
    print(response.responseCode);

    if (response.isSuccess && response.responseData["success"] == true) {
      _clearText();

      print("readddyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
      print(widget.item.id.toString());
      print(widget.saleitemid.toString());
      print(selectedItemFilter!.id.toString());

      Get.back(result: true);

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
      inprogressssalesorderentry = false;
      setState(() {});
    }
  }

  void _clearText() {
    selectedBrandName = null;
    selectedItemGroup = null;
    selectedItemFilter = null;
    selectedAttribute = null;
    _itemnameController.clear();
    _quantityController.clear();
    _unitController.clear();
    _priceController.clear();
    _amountController.clear();
  }

  @override
  void dispose() {
    _itemnameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
