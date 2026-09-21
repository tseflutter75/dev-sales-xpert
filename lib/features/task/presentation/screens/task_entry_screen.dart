import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';

class TaskEntry extends StatefulWidget {
  final int fromTabIndex;
  const TaskEntry({super.key, this.fromTabIndex = 1});

  @override
  State<TaskEntry> createState() => _TaskEntryState();
}

class _TaskEntryState extends State<TaskEntry> {
  // Controllers
  final businessUnitCtrl = TextEditingController();
  final projectCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final assignDateCtrl = TextEditingController();

  final onBehalfCtrl = TextEditingController();
  final assignedByCtrl = TextEditingController();
  final assigneeCtrl = TextEditingController();
  final priorityCtrl = TextEditingController();

  final taskTitleCtrl = TextEditingController();
  final dueDateCtrl = TextEditingController();
  final taskDetailsCtrl = TextEditingController();
  final taskStatusCtrl = TextEditingController();
  final actualStatusCtrl = TextEditingController();
  final attachmentCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool inprogressstaskentry = false;

  File? image;

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
          "Task Entry",
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
                /// start
                TextFormField(
                  controller: projectCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Project is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Project",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: categoryCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Category is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Category",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: assignDateCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Assign Date is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Assign Date",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: onBehalfCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'On Behalf is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "On Behalf of",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: assignedByCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Assigned By is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Assigned By",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: assigneeCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Assignee is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Assignee",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: priorityCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Priority is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Priority",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: taskTitleCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Task Title is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: dueDateCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Due Date is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Due Date",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: taskDetailsCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Task Details is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Task Details",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: taskStatusCtrl,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Task Status is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Task Status",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _openCamera();
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        color: Colors.grey.shade300,
                        child: Icon(Icons.camera_alt_outlined, size: 40),
                      ),
                    ),
                    SizedBox(width: 20),

                    image == null
                        ? Text('No image taken')
                        : Image.file(
                            File(image!.path),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                  ],
                ),

                SizedBox(height: 10),

                Visibility(
                  visible: inprogressstaskentry == false,
                  replacement: Center(child: CustomCircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        taskEntry();
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
                        // ignore: deprecated_member_use
                        Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      //  bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: widget.fromTabIndex,
      // ),
    );
  }

  Future<void> _openCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> taskEntry() async {
    if (inprogressstaskentry) return;

    inprogressstaskentry = true;
    setState(() {});
    try {
      final user = AuthController.userModel!;
      // ১. Multipart Request তৈরি করা
      var request = http.MultipartRequest('POST', Uri.parse(Urls.taskEntryUrl));

      // ২. হেডার যোগ করা
      request.headers.addAll({
        "Authorization": "Bearer ${AuthController.accessToken}",
        "Accept": "application/json",
      });

      // request.fields['business_unit'] = businessUnitCtrl.text.trim();
      request.fields['company_id'] = user.companyid.toString();
      request.fields['employee_id'] = user.empoloyeeid.toString();
      request.fields['project'] = projectCtrl.text.trim();
      request.fields['category'] = categoryCtrl.text.trim();
      request.fields['assign_date'] = assignDateCtrl.text.trim();

      request.fields['on_behalf_of'] = onBehalfCtrl.text.trim();
      request.fields['assigned_by'] = assignedByCtrl.text.trim();
      request.fields['assignee'] = assigneeCtrl.text.trim();
      request.fields['priority'] = priorityCtrl.text.trim();

      request.fields['task_title'] = taskTitleCtrl.text.trim();
      request.fields['due_date'] = dueDateCtrl.text.trim();
      request.fields['task_details'] = taskDetailsCtrl.text.trim();

      request.fields['task_status'] = taskStatusCtrl.text.trim();
      request.fields['actual_status'] = actualStatusCtrl.text.trim();

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image!.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      String serverMessage =
          decodedData['message']?.toString() ?? "Request failed";

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          decodedData['success'] == true) {
        clearFields();

        Get.back(result: true);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFF00A8AA),
            content: Center(
              child: Text(
                serverMessage,
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
            backgroundColor: Colors.red,
            content: Center(
              child: Text(
                serverMessage,
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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        inprogressstaskentry = false;
      });
    }
  }

  void clearFields() {
    businessUnitCtrl.clear();
    projectCtrl.clear();
    categoryCtrl.clear();
    assignDateCtrl.clear();
    onBehalfCtrl.clear();
    assignedByCtrl.clear();
    assigneeCtrl.clear();
    priorityCtrl.clear();
    taskTitleCtrl.clear();
    dueDateCtrl.clear();
    taskDetailsCtrl.clear();
    taskStatusCtrl.clear();
    actualStatusCtrl.clear();
    attachmentCtrl.clear();
  }

  @override
  void dispose() {
    businessUnitCtrl.dispose();
    projectCtrl.dispose();
    categoryCtrl.dispose();
    assignDateCtrl.dispose();
    onBehalfCtrl.dispose();
    assignedByCtrl.dispose();
    assigneeCtrl.dispose();
    priorityCtrl.dispose();
    taskTitleCtrl.dispose();
    dueDateCtrl.dispose();
    taskDetailsCtrl.dispose();
    taskStatusCtrl.dispose();
    actualStatusCtrl.dispose();
    attachmentCtrl.dispose();
    super.dispose();
  }
}
