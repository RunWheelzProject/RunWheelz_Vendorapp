import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool circular = false;
  //PickedFile? _imageFile = null;
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Form(

        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),

          children: <Widget>[

            imageProfile(),
            const SizedBox(
              height: 30,

            ),
            nameTextField(),
            const SizedBox(
              height: 20,
            ),
            emailTextField(),

            const SizedBox(
              height: 20,
            ),
            phonenumberTextField(),
            const SizedBox(

              width: 2,

              height: 90,),
            ElevatedButton(
              child: const Text('Update'),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,

              ),
              onPressed: () {},
            ),

//

          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(

      child: Stack(children: <Widget>[

        CircleAvatar(
          radius: 60.0,

          backgroundImage: _imageFile == null ? const AssetImage("images/logo.png")as ImageProvider
              : FileImage(File(_imageFile!.path)),
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
                builder: ((builder) => bottomSheet()),
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

  Widget bottomSheet() {
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
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

/*  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
     setState(() {
      _imageFile = pickedFile as PickedFile;
     });
  }*/




  Future<File?> takePhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    final File? file = File(image!.path);
    setState(() {
      _imageFile = image;
    });
    return file;
  }


  Widget nameTextField() {
    return TextFormField(

      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "",
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(

      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.purple,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.purple,
        ),
        labelText: "Email",

      ),
    );
  }

  Widget phonenumberTextField() {
    return TextFormField(

      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.purple,
                width: 2,
              )),
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.purple,
          ),
          labelText: "PhoneNumber"

      ),
    );
  }














}

