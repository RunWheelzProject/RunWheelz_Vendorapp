/*import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/services/vendor_registration.dart';
import 'package:path/path.dart';

import '../manager/profile_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';


class Profile extends StatefulWidget {
  final bool isStaff;
  final bool isVendor;

  Profile({Key? key, this.isStaff = false, this.isVendor = false}) : super(key: key);
  @override
  ProfileState createState() => ProfileState();
}
class ProfileState extends State<Profile> {



  bool circular = false;
  //PickedFile? _imageFile = null;
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
    ProfileManager profileManager = Provider.of<ProfileManager>(context);
    late final StaffDTO staffDTO;
    late final VendorRegistrationRequest vendor;

    if (widget.isStaff) {
      staffDTO = profileManager.staffDTO;
      log("staffDTO2: ${jsonEncode(staffDTO)}");
      _nameController.text = staffDTO.name ?? "not exits";
      _phoneController.text = staffDTO.phoneNumber ?? "not exits";
      _aadhaarController.text = staffDTO.aadharNumber ?? "not exits";
      _addressController.text = staffDTO.addressLine ?? "not exits";
    }
      if (widget.isVendor) {
        vendor = profileManager.vendorRegistrationRequest;
        _nameController.text = vendor.ownerName ?? "not exists";
        _phoneController.text = vendor.phoneNumber ?? "not exists";
        _aadhaarController.text = vendor.aadharNumber ?? "not exists";
        _addressController.text = vendor.addressLine ?? "not exists";
      }

      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return widget.isStaff ? const StaffManagementPage() : VendorManagementPage();
                })
            )
          },
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
                    if (widget.isStaff) {
                      if (profileManager.isEnable) {
                        profileManager.isEnable = false;
                        StaffService().updateStaffInfo(profileManager.staffDTO);
                        Future<StaffDTO> future = StaffService().getStaffById(staffDTO.id as int);
                        future.then((StaffDTO staffDTO) => profileManager.staffDTO = staffDTO)
                            .catchError((error) { log("error: $error"); });
                      } else {
                        profileManager.isEnable = true;
                      }
                    }
                    if (widget.isVendor) {
                      if (profileManager.isEnable) {
                        profileManager.isEnable = false;
                        VendorRegistrationService().updateVendorInfo(profileManager.vendorRegistrationRequest);
                        Future<VendorRegistrationRequest> future =
                        VendorRegistrationService().getVendorById(vendor.id as int);
                        future.then((VendorRegistrationRequest vendor) => profileManager.vendorRegistrationRequest = vendor)
                            .catchError((error) { log("error: $error"); });
                      } else {
                        profileManager.isEnable = true;
                      }
                    }
                  },
                  icon: Icon(
                    profileManager.isEnable ? Icons.save : Icons.edit,
                    color: Colors.purple,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog<String>(
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text("Delete"),
                            content: Text(
                                "Are you sure deleting Vendor: -  '${staffDTO.name}' -  ?",
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
                        enabled: profileManager.isEnable,
                        decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                        onChanged: (val) => profileManager.staffDTO.name = val,
                      ),
                    ),
                  ],
                ),
                Text(widget.isVendor ? "Vendor" : "Staff", style: const TextStyle(fontSize: 16))
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
                    enabled: profileManager.isEnable,
                    decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                    onChanged: (val) => profileManager.staffDTO.phoneNumber = val,
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
                    enabled: profileManager.isEnable,
                    decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                    onChanged: (val) => profileManager.staffDTO.aadharNumber = val,
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
                    enabled: profileManager.isEnable,
                    decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                    onChanged: (val) => profileManager.staffDTO.addressLine = val,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
*//*
  Widget fieldName(String key, String? value, String title, BuildContext context, String? data) {
    ProfileManager profileManager = Provider.of<ProfileManager>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(key, style: const TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.bold)),
        //Text(value ?? "not exists", style: const TextStyle(fontSize: 20)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IntrinsicWidth(
              child: TextField(
                controller: _name,
                enabled: profileManager.isEnable,
                decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                onChanged: (val) => data = val,
              ),
            ),
          ],
        ),
        Text(title, style: const TextStyle(fontSize: 16))
      ],
    );
  }

  Widget fieldLeft(String key, String? value, BuildContext context) {
    ProfileManager profileManager = Provider.of<ProfileManager>(context);
    TextEditingController controller = TextEditingController();
    controller.text = value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(key, style: const TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.bold)),
        IntrinsicWidth(
          child: TextField(
            controller: controller,
            enabled: profileManager.isEnable,
            decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
            onChanged: (val) => data = val,
          ),
        )
      ],
    );
  }*//*

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
          right:1,
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
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
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
                String newPath = path.join(dir, profileManager.staffDTO.id.toString());
                log("path: ${newPath}");
                _imageFile?.rename(newPath).then((file) {
                  log("path: ${file?.path}");

                  log("_imagePath: ${_imageFile?.path}");
                  var request = http.MultipartRequest("POST", Uri.parse("${res.APP_URL}/api/staff/image-upload"));
                  request.files.add(http.MultipartFile(
                      'image',
                      file.readAsBytes().asStream(),
                      file.lengthSync(),
                      filename: basename(file.path), contentType: MediaType('image', 'jpeg')
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
                  var request = http.MultipartRequest("POST", Uri.parse("${res.APP_URL}/api/staff/image-upload"));
                  request.files.add(http.MultipartFile(
                      'image',
                      file.readAsBytes().asStream(),
                      file.lengthSync(),
                      filename: basename(file.path), contentType: MediaType('image', 'jpeg')
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

}*/



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

class ProfileData {
  String name;
  String phoneNumber;
  String aadharNumber;
  String addressLine;

  ProfileData({
    this.name = "",
    this.phoneNumber = "",
    this.aadharNumber = "",
    this.addressLine = ""
  });

}

class VendorDashboardProfile extends StatefulWidget {
  bool isStaff;
  bool isVendor;

  VendorDashboardProfile({Key? key, this.isStaff = false, this.isVendor = false}) : super(key: key);

  @override
  VendorDashboardProfileState createState() => VendorDashboardProfileState();
}

class VendorDashboardProfileState extends State<VendorDashboardProfile> {
  ProfileData profileData = ProfileData();
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
    int id = Provider.of<VendorManager>(context, listen: false).vendorRegistrationRequest.id as int;
    final ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);

    getImage(id).then((bytes) {
      setState(() => {
        _imageURL = MemoryFileSystem().file('test.jpg')..writeAsBytesSync(bytes)
      });
    }).catchError((error) => log("GetImageError: $error"));

    if (widget.isStaff) {
      log("manager: ${jsonEncode(profileManager.staffDTO)}");
      setState(() {
        _nameController.text = profileManager.staffDTO.name ?? "not exists";
        _phoneController.text = profileManager.staffDTO.phoneNumber ?? "not exists";
        _aadhaarController.text = profileManager.staffDTO.aadharNumber ?? "not exists";
        _addressController.text = profileManager.staffDTO.addressLine ?? "not exists";
        profileData.name = profileManager.staffDTO.name ?? "";
        profileData.phoneNumber = profileManager.staffDTO.phoneNumber ?? "";
        profileData.aadharNumber = profileManager.staffDTO.aadharNumber ?? "";
        profileData.addressLine = profileManager.staffDTO.addressLine ?? "";
      });
    }

    if (widget.isVendor) {
      setState(() {
        _nameController.text = profileManager.vendorRegistrationRequest.ownerName ?? "not exists";
        _phoneController.text = profileManager.vendorRegistrationRequest.phoneNumber  ?? "not exists";
        _aadhaarController.text = profileManager.vendorRegistrationRequest.aadharNumber ?? "not exists";
        _addressController.text = profileManager.vendorRegistrationRequest.addressLine ?? "not exists";
        profileData.name = profileManager.vendorRegistrationRequest.ownerName?? "";
        profileData.phoneNumber = profileManager.vendorRegistrationRequest.phoneNumber ?? "";
        profileData.aadharNumber = profileManager.vendorRegistrationRequest.aadharNumber ?? "";
        profileData.addressLine = profileManager.vendorRegistrationRequest.addressLine ?? "";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final ProfileManager profileManager = Provider.of<ProfileManager>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return widget.isVendor ? const VendorDashBoard() : const RunWheelManagementPage();
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),

        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              IconButton(
                onPressed: () {
                  if (widget.isVendor) {
                    if (profileManager.isEnable) {
                      profileManager.isEnable = false;
                      RoleDTO role = RoleDTO(id: 4, roleName: "VENDOR");
                      profileManager.vendorRegistrationRequest.role = role;
                      profileManager.vendorRegistrationRequest.ownerName = profileData?.name;
                      profileManager.vendorRegistrationRequest.phoneNumber = profileData?.phoneNumber;
                      profileManager.vendorRegistrationRequest.aadharNumber = profileData?.aadharNumber;
                      profileManager.vendorRegistrationRequest.addressLine = profileData?.addressLine;

                      log("isVendor: ${jsonEncode(profileManager.vendorRegistrationRequest)}");
                      VendorRegistrationService().updateVendorInfo(profileManager.vendorRegistrationRequest);
                      Future<VendorRegistrationRequest> future = VendorRegistrationService().getVendorById(profileManager.vendorRegistrationRequest.id as int);
                      future.then((VendorRegistrationRequest staffDTO) => profileManager.vendorRegistrationRequest = staffDTO)
                          .catchError((error) { log("error: $error"); });
                    } else {
                      profileManager.isEnable = true;
                    }
                  }
                  if (widget.isStaff) {
                    if (profileManager.isEnable) {
                      profileManager.isEnable = false;
                      profileManager.staffDTO.name = profileData?.name;
                      profileManager.staffDTO.phoneNumber = profileData?.phoneNumber;
                      profileManager.staffDTO.aadharNumber = profileData?.aadharNumber;
                      profileManager.staffDTO.addressLine = profileData?.addressLine;

                      StaffService().updateStaffInfo(profileManager.staffDTO);
                      Future<StaffDTO> future = StaffService().getStaffById(profileManager.staffDTO.id as int);
                      future.then((StaffDTO staffDTO) => profileManager.staffDTO = staffDTO)
                          .catchError((error) { log("error: $error"); });
                    } else {
                      profileManager.isEnable = true;
                    }
                  }
                },
                icon: Icon(
                  profileManager.isEnable ? Icons.save : Icons.edit,
                  color: Colors.purple,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog<String>(
                      builder: (BuildContext context) => AlertDialog(
                          title: const Text("Delete"),
                          content: Text(
                              "Are you sure deleting Vendor: -  '${profileData?.name}' -  ?",
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
                      enabled: profileManager.isEnable,
                      decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                      onChanged: (val) {
                        profileData?.name = val;
                      }
                    ),
                  ),
                ],
              ),
              Text(widget.isStaff ? "Staff" : "Vendor", style: const TextStyle(fontSize: 16))
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
                  enabled: profileManager.isEnable,
                  decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => profileData?.phoneNumber = val,
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
                  enabled: profileManager.isEnable,
                  decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => profileData?.aadharNumber = val,
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
                  enabled: profileManager.isEnable,
                  decoration: profileManager.isEnable ? enableInputDecoration : disableInputDecoration,
                  onChanged: (val) => profileData?.addressLine = val,
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
    final VendorManager vendorManager = Provider.of<VendorManager>(context);
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
                takePhoto(ImageSource.gallery, _picker);

                String dir = path.dirname(_imageFile?.path as String);
                String newPath = path.join(dir, vendorManager.vendorRegistrationRequest.id.toString());
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
    final ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    final XFile? image = await _picker.pickImage(source: source);
    String dir = path.dirname(image?.path as String);
    String newPath = path.join(dir, profileManager.vendorRegistrationRequest.id.toString());
    final File file = File(image!.path);
    file.rename(newPath).then((f) {
      setState(() {
        _imageFile = f;
      });
    });

    return file;
  }

}

