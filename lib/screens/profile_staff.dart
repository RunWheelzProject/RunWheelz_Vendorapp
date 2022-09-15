import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_assign_screen.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../manager/profile_manager.dart';
import '../manager/staff_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';
import 'login_page_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import '../manager/profile_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';


class StaffProfile extends StatefulWidget {
  const StaffProfile({Key? key}) : super(key: key);


  @override
  StaffStateProfile createState() => StaffStateProfile();
}

class StaffStateProfile extends State<StaffProfile> {

  bool circular = false;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final InputDecoration enableInputDecoration = const InputDecoration(
      contentPadding: EdgeInsets.only(left: 5, right: 10),
      fillColor: Color(0xfffbf0f0)
  );
  final InputDecoration disableInputDecoration = const InputDecoration(
      fillColor: Colors.white
  );



  @override
  Widget build(BuildContext context) {
    final StaffManager staffManager = Provider.of<StaffManager>(context);
    final StaffDTO vendor = staffManager.staffDTO;
    _nameController.text = vendor.name ?? "not exists";
    _phoneController.text = vendor.phoneNumber ?? "not exists";
    _aadhaarController.text = vendor.aadharNumber ?? "not exists";
    _addressController.text = vendor.addressLine ?? "not exists";

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return const StaffManagementPage();
              })
          )
        },
        //VendorSelectExecutiveScreen
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "My Profile",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),

        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              IconButton(
                onPressed: () {
                  if (staffManager.isEnable) {
                    staffManager.isEnable = false;
                    StaffService().updateStaffInfo(staffManager.staffDTO);
                    Future<StaffDTO> future =
                    StaffService().getStaffById(vendor.id as int);
                    future.then((StaffDTO vendor) => staffManager.staffDTO = vendor)
                        .catchError((error) { log("error: $error"); });
                  } else {
                    staffManager.isEnable = true;
                  }
                },
                icon: Icon(
                  staffManager.isEnable ? Icons.save : Icons.edit,
                  color: Colors.purple,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog<String>(
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text("Delete"),
                          content: Text(
                              "Are you sure deleting Vendor: -  '${vendor.name}' -  ?",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black87)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, 'YES'),
                              child: const Text(
                                'YES',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, 'NO'),
                              child: const Text('NO'),
                            )
                          ]),
                      context: context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.purple,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const LoginScreen();
                      })
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          imageProfile(context, _picker),
          const SizedBox(height: 30,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Name", style: TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.bold)),
              //Text(value ?? "not exists", style: const TextStyle(fontSize: 20)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IntrinsicWidth(
                    child: TextField(
                      controller: _nameController,
                      enabled: staffManager.isEnable,
                      decoration: staffManager.isEnable ? enableInputDecoration : disableInputDecoration,
                      onChanged: (val) => staffManager.staffDTO.name = val,
                    ),
                  ),
                ],
              ),
              const Text("Staff", style: const TextStyle(fontSize: 16))
            ],
          ),
          const SizedBox(height: 80,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Phone Number", style: TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.bold)),
              IntrinsicWidth(
                child: TextField(
                  controller: _phoneController,
                  enabled: staffManager.isEnable,
                  decoration: staffManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => staffManager.staffDTO.phoneNumber = val,
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Aadhaar Card", style: TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.bold)),
              IntrinsicWidth(
                child: TextField(
                  controller: _aadhaarController,
                  enabled: staffManager.isEnable,
                  decoration: staffManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => staffManager.staffDTO.aadharNumber = val,
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Address", style: TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.bold)),
              IntrinsicWidth(
                child: TextField(
                  controller: _addressController,
                  enabled: staffManager.isEnable,
                  decoration: staffManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => staffManager.staffDTO.addressLine = val,
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget imageProfile(BuildContext context, ImagePicker _picker) {
    return Center(

      child: Stack(children: <Widget>[

        CircleAvatar(
            radius: 60.0,
            backgroundImage: _imageFile == null
                ? const AssetImage("images/logo.jpg")
            as ImageProvider
                : FileImage(File(_imageFile!.path))
          //backgroundImage: AssetImage("assets/profile_default_image.png")
        ),
        Positioned(
          top: 96.0,
          //bottom:1.0,
          right: 1,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context, _picker)),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.purple,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet(BuildContext context, ImagePicker _picker) {
    final ProfileManager profileManager = Provider.of<ProfileManager>(context);
    return Container(
      height: 100.0,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera, _picker);

                String dir = path.dirname(_imageFile?.path as String);
                String newPath = path.join(dir,  profileManager.vendorDTO.id.toString());
                _imageFile?.rename(newPath).then((file) {
                  var request = http.MultipartRequest("POST", Uri.parse("${res.APP_URL}/api/vendor/image-upload"));
                  request.files.add(http.MultipartFile(
                      'image',
                      file.readAsBytes().asStream(),
                      file.lengthSync(),
                      filename: path.basename(file.path), contentType: MediaType('image', 'jpeg')
                  ),);
                  request.send().then((response) {
                    if (response.statusCode == 200) log("Uploaded!");
                  });

                });
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, _picker);

                String dir = path.dirname(_imageFile?.path as String);
                String newPath = path.join(dir, profileManager.staffDTO.id.toString());
                log("path: ${newPath}");
                _imageFile?.rename(newPath).then((file) {
                  log("path: ${file?.path}");

                  log("_imagePath: ${_imageFile?.path}");
                  var request = http.MultipartRequest("POST", Uri.parse("${res.APP_URL}/api/vendor/image-upload"));
                  request.files.add(http.MultipartFile(
                      'image',
                      file.readAsBytes().asStream(),
                      file.lengthSync(),
                      filename: path.basename(file.path), contentType: MediaType('image', 'jpeg')
                  ),);
                  request.send().then((response) {
                    if (response.statusCode == 200) log("Uploaded!");
                  });

                });
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }



  Future<File?> takePhoto(ImageSource source, ImagePicker _picker) async {
    final XFile? image = await _picker.pickImage(source: source);
    final File file = File(image!.path);
    setState(() {
      log("image updated");
      _imageFile = File(image.path);
    });
    return file;
  }

}

