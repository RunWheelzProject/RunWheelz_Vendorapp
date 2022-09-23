import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/role.dart';
import 'package:untitled/model/user_image_dto.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/services/user_image_service.dart';
import 'package:untitled/services/vendor_registration.dart';
import 'package:path_provider/path_provider.dart';

import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';
import 'login_page_screen.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import '../resources/resources.dart' as res;
import 'package:path/path.dart' as path;

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
  bool isMechanic;
  bool isCustomer;

  VendorDashboardProfile({Key? key,
    this.isStaff = false,
    this.isVendor = false,
    this.isMechanic = false,
    this.isCustomer = false
  }) : super(key: key);

  @override
  VendorDashboardProfileState createState() => VendorDashboardProfileState();
}

class VendorDashboardProfileState extends State<VendorDashboardProfile> {
  ProfileData profileData = ProfileData();
  bool circular = false;
  XFile? _imageFile;
  Image? image;
  String title = "";

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

  Future<File> getImageFileFromAssets(List<int> bytes) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final File file = await File("${appDocDirectory.path}/run_wheelz/test.jpg").create(recursive: true);
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  void initState() {
    super.initState();

    if (widget.isMechanic) setState(() => title = "Mechanic");
    if (widget.isStaff) setState(() => title = "Staff");
    if (widget.isVendor) setState(() => title = "Vendor");
    if (widget.isCustomer) setState(() => title = "Customer");

    final ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);

    int? id = 0;
    if (widget.isVendor) id = profileManager.vendorDTO.id;
    if (widget.isCustomer) id = profileManager.customerDTO.id;
    if (widget.isMechanic) id = profileManager.vendorMechanic.id;
    if (widget.isStaff) id = profileManager.staffDTO.id;
    log("id: $id");
    UserImageService().getImage(id as int).then((UserImageDTO userImageDTO) {
      //log("userImage: ${jsonEncode(userImageDTO)}");
      //File file = File('test.jpg').writeAsBytes(userImageDTO.image as List<int>) as File;
      setState(() {
        image = Image.memory(userImageDTO.image as Uint8List);
      });

      getImageFileFromAssets(userImageDTO.image as List<int>).then((file) {
        log(file.path);
        setState(() {
          _imageFile = XFile(file.path);
        });
      });

    });

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
        _nameController.text = profileManager.vendorDTO.ownerName ?? "not exists";
        _phoneController.text = profileManager.vendorDTO.phoneNumber  ?? "not exists";
        _aadhaarController.text = profileManager.vendorDTO.aadharNumber ?? "not exists";
        _addressController.text = profileManager.vendorDTO.addressLine ?? "not exists";
        profileData.name = profileManager.vendorDTO.ownerName?? "";
        profileData.phoneNumber = profileManager.vendorDTO.phoneNumber ?? "";
        profileData.aadharNumber = profileManager.vendorDTO.aadharNumber ?? "";
        profileData.addressLine = profileManager.vendorDTO.addressLine ?? "";
      });
    }

    if (widget.isMechanic) {
      setState(() {
        _nameController.text = profileManager.vendorMechanic.name ?? "not exists";
        _phoneController.text = profileManager.vendorMechanic.phoneNumber  ?? "not exists";
        _aadhaarController.text = profileManager.vendorMechanic.aadharNumber ?? "not exists";
        profileData.name = profileManager.vendorMechanic.name?? "";
        profileData.phoneNumber = profileManager.vendorMechanic.phoneNumber ?? "";
        profileData.aadharNumber = profileManager.vendorMechanic.aadharNumber ?? "";
      });
    }

    if (widget.isCustomer) {
      setState(() {
        _nameController.text = profileManager.customerDTO.name ?? "not exists";
        _phoneController.text = profileManager.customerDTO.phoneNumber  ?? "not exists";
        profileData.name = profileManager.customerDTO.name?? "";
        profileData.phoneNumber = profileManager.customerDTO.phoneNumber ?? "";
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
                if (widget.isStaff) return const RunWheelManagementPage();
                if (widget.isVendor) return const VendorDashBoard();
                if (widget.isCustomer) return CustomerDashBoard(isCustomer: widget.isCustomer, isVendor: widget.isVendor);
                return VendorMechanicDashBoard(requestId: '');
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
                      profileManager.vendorDTO.role = role;
                      profileManager.vendorDTO.ownerName = profileData?.name;
                      profileManager.vendorDTO.phoneNumber = profileData?.phoneNumber;
                      profileManager.vendorDTO.aadharNumber = profileData?.aadharNumber;
                      profileManager.vendorDTO.addressLine = profileData?.addressLine;

                      log("isVendor: ${jsonEncode(profileManager.vendorDTO)}");
                      VendorRegistrationService().updateVendorInfo(profileManager.vendorDTO);
                      Future<VendorDTO> future = VendorRegistrationService().getVendorById(profileManager.vendorDTO.id as int);
                      future.then((VendorDTO staffDTO) => profileManager.vendorDTO = staffDTO)
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
              Text(title, style: const TextStyle(fontSize: 16))
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
            backgroundImage: _imageFile == null
                ? const AssetImage("images/logo.jpg") as ImageProvider
                : FileImage(File(_imageFile!.path))
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
                takePhoto(ImageSource.camera, _picker).then((file) {
                });
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, _picker).then((file) {
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
    String newPath =  "";
    if (widget.isVendor) newPath = path.join(dir, profileManager.vendorDTO.id.toString());
    if (widget.isCustomer) newPath = path.join(dir, profileManager.customerDTO.id.toString());
    if (widget.isMechanic) newPath = path.join(dir, profileManager.vendorMechanic.id.toString());
    if (widget.isStaff) newPath = path.join(dir, profileManager.staffDTO.id.toString());
    log("newPath: $newPath");
    File file = File(image!.path);
    file.rename(newPath).then((file) {
      setState(() {
        _imageFile = XFile(file.path);
      });

      String path = _imageFile != null ? _imageFile?.path as String : "logo.jpg";
      UserImageService().uploadImage(File(path)).then((msg) => log(msg));

    });

    return file;
  }

}

