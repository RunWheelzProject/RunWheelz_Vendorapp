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

import '../manager/profile_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';


class Profile extends StatelessWidget {
  final bool isStaff;
  final bool isVendor;


  bool circular = false;
  //PickedFile? _imageFile = null;
  XFile? _imageFile;

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

  Profile({Key? key, this.isStaff = false, this.isVendor = false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ProfileManager profileManager = Provider.of<ProfileManager>(context);
    late final StaffDTO staffDTO;
    late final VendorRegistrationRequest vendor;

    if (isStaff) {
      staffDTO = profileManager.staffDTO;
      log("staffDTO2: ${jsonEncode(staffDTO)}");
      _nameController.text = staffDTO.name ?? "not exits";
      _phoneController.text = staffDTO.phoneNumber ?? "not exits";
      _aadhaarController.text = staffDTO.aadharNumber ?? "not exits";
      _addressController.text = staffDTO.addressLine ?? "not exits";
    }
      if (isVendor) {
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
                  return const StaffManagementPage();
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
                    if (profileManager.isEnable) {
                      profileManager.isEnable = false;
                      StaffService().updateStaffInfo(profileManager.staffDTO);
                      Future<StaffDTO> future = StaffService().getStaffById(staffDTO.id as int);
                      future.then((StaffDTO staffDTO) => profileManager.staffDTO = staffDTO)
                      .catchError((error) { log("error: $error"); });
                    } else {
                      profileManager.isEnable = true;
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
                Text(isVendor ? "Vendor" : "Staff", style: const TextStyle(fontSize: 16))
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
/*
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
  }*/

  Widget imageProfile(BuildContext context, ImagePicker _picker) {
    return Center(

      child: Stack(children: <Widget>[

        const CircleAvatar(
          radius: 60.0,
          backgroundImage: AssetImage("images/logo.png")
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
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, _picker);
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
    /*setState(() {
      _imageFile = image;
    });*/
    return file;
  }

}

