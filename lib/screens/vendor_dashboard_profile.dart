import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file/memory.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/role.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_assign_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../manager/profile_manager.dart';
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
import 'package:file/file.dart' as file;


class VendorDashboardProfile extends StatefulWidget {
  const VendorDashboardProfile({Key? key}) : super(key: key);


  @override
  VendorDashboardProfileState createState() => VendorDashboardProfileState();
}

class VendorDashboardProfileState extends State<VendorDashboardProfile> {

  bool circular = false;
  File? _imageFile;
  File? _imageURL;
  Image? image;

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

  Future<Uint8List> getImage(int id) async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendor/get-image/${id}"));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      log("imageJson: ${json}");
      return const Base64Codec().decode(json["image"]);
    }
    throw Exception("image not found");
  }

  @override
  void initState() {
    super.initState();
    int id = Provider.of<ProfileManager>(context, listen: false).vendorRegistrationRequest.id as int;
    getImage(id).then((bytes) {
      setState(() => {
        _imageURL = MemoryFileSystem().file('test.jpg')..writeAsBytesSync(bytes)
      });
    }).catchError((error) => log("GetImageError: $error"));
  }
  @override
  Widget build(BuildContext context) {
    final VendorManager vendorManager = Provider.of<VendorManager>(context);
    VendorRegistrationRequest vendor = vendorManager.vendorRegistrationRequest;
    _nameController.text = vendor.ownerName ?? "not exists";
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
                return const VendorDashBoard();
              })
          )
        },
        //VendorSelectExecutiveScreen
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    if (vendorManager.isEnable) {
                      vendorManager.isEnable = false;
                      RoleDTO role = RoleDTO(id: 4, roleName: "VENDOR");
                      vendorManager.vendorRegistrationRequest.role = role;
                      VendorRegistrationService().updateVendorInfo(vendorManager.vendorRegistrationRequest);
                      Future<VendorRegistrationRequest> future = VendorRegistrationService().getVendorById(vendorManager.vendorRegistrationRequest.id as int);
                      future.then((VendorRegistrationRequest staffDTO) => vendorManager.vendorRegistrationRequest = staffDTO)
                          .catchError((error) { log("error: $error"); });
                    } else {
                      vendorManager.isEnable = true;
                    }
                },
                icon: Icon(
                  vendorManager.isEnable ? Icons.save : Icons.edit,
                  color: Colors.purple,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog<String>(
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text("Delete"),
                          content: Text(
                              "Are you sure deleting Vendor: -  '${vendor.ownerName}' -  ?",
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
                      enabled: vendorManager.isEnable,
                      decoration: vendorManager.isEnable ? enableInputDecoration : disableInputDecoration,
                      onChanged: (val) => vendorManager.vendorRegistrationRequest.ownerName = val,
                    ),
                  ),
                ],
              ),
              const Text("Vendor", style: const TextStyle(fontSize: 16))
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
                  enabled: vendorManager.isEnable,
                  decoration: vendorManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => vendorManager.vendorRegistrationRequest.phoneNumber = val,
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
                  enabled: vendorManager.isEnable,
                  decoration: vendorManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => vendorManager.vendorRegistrationRequest.aadharNumber = val,
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
                  enabled: vendorManager.isEnable,
                  decoration: vendorManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => vendorManager.vendorRegistrationRequest.addressLine = val,
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
            backgroundImage: _imageURL != null ? FileImage(_imageURL!) : _imageFile == null
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
                takePhoto(ImageSource.camera, _picker).then((t) {
                  File file = t as File;
                  var request = http.MultipartRequest("POST", Uri.parse("${res.APP_URL}/api/vendor/image-upload"));
                  request.files.add(http.MultipartFile(
                      'image',
                      file.readAsBytes().asStream(),
                      file.lengthSync(),
                      filename: path.basename(file.path), contentType: MediaType('image', 'jpg')
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
                takePhoto(ImageSource.gallery, _picker).then((t) {
                  File file = t as File;
                  var request = http.MultipartRequest("POST", Uri.parse("${res.APP_URL}/api/vendor/image-upload"));
                  request.files.add(http.MultipartFile(
                      'image',
                      file.readAsBytes().asStream(),
                      file.lengthSync(),
                      filename: path.basename(file.path), contentType: MediaType('image', 'jpg')
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
    final VendorManager vendorManager = Provider.of<VendorManager>(context);
    final XFile? image = await _picker.pickImage(source: source);
    String dir = path.dirname(image?.path as String);
    String newPath = path.join(dir, vendorManager.vendorRegistrationRequest.id.toString());
    final File file = File(image!.path);
    file.rename(newPath).then((f) {
      setState(() {
        _imageFile = f;
      });
    });

    return file;
  }

}

