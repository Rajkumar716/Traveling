
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/provider_screens/home.dart';

import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;

class ADDPACKAGE extends StatefulWidget {
  const ADDPACKAGE({Key? key}) : super(key: key);

  @override
  State<ADDPACKAGE> createState() => _ADDPACKAGEState();
}

class _ADDPACKAGEState extends State<ADDPACKAGE> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController packagenamecontroller= TextEditingController();
  TextEditingController placename= TextEditingController();
  TextEditingController hotelname= TextEditingController();
  TextEditingController person_count= TextEditingController();
  TextEditingController traveling_days= TextEditingController();
  TextEditingController vehicle_type= TextEditingController();
  TextEditingController package_price= TextEditingController();

  // get the picture from the gallery
  XFile? imagefile;
  final ImagePicker _picker=ImagePicker();
  String packageimageurl="";

  Future<void> _getimage() async{
    imagefile=await _picker.pickImage(source: ImageSource.gallery) as XFile?;

    setState(() {
      imagefile;
    });
  }

  Future<void> formValidation() async{
    if(imagefile == null){
      showDialog(context: context,
          builder: (context){
            return ErrorDialog(
              message: "Select the Image......",
            );
          });
    }else{
      if(packagenamecontroller.text.isNotEmpty && hotelname.text.isNotEmpty && person_count.text.isNotEmpty && traveling_days.text.isNotEmpty && vehicle_type.text.isNotEmpty && package_price.text.isNotEmpty){
        showDialog(context: context,
            builder: (context){
              return LoadingDialog(
                message: "Adding New Package Happening",
              );
            });
        //Save the Image file into FirebaseStore
        String FileName=DateTime.now().microsecondsSinceEpoch.toString();
        fstorage.Reference reference=fstorage.FirebaseStorage.instance.ref().child("package").child(FileName);
        fstorage.UploadTask uploadTask=reference.putFile(File(imagefile!.path));
        fstorage.TaskSnapshot taskSnapshot=await uploadTask.whenComplete((){});
        await taskSnapshot.ref.getDownloadURL().then((url){
          packageimageurl=url;
        });
        SaveDataFireStore();
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ProviderHome()));

      }else{
        showDialog(context: context,
            builder: (context){
              return ErrorDialog(
                message: "Please Fill All Text Feilds....",
              );
            });
      }

    }
  }

  Future SaveDataFireStore() async{
    FirebaseFirestore.instance.collection("packages").doc().set(
      {
        "providerid":sharedPreferences?.getString("uid"),
        "packagename":packagenamecontroller.text.trim(),
        "place_name":placename.text,
        "providername":sharedPreferences?.getString("name"),
        "person_count":person_count.text,
        "days_count":traveling_days.text,
        "packageimage":packageimageurl,
        "vehicletype":vehicle_type.text,
        "package_price":package_price.text,
        "Hotel_name":hotelname.text,


      }

    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: Text("ADD NEW PACKAGE"),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProviderHome()));
          },
        ),
      ),body: Container(
      decoration: BoxDecoration(

          image: DecorationImage(
              image: AssetImage("images/provider_dash.jpg"),
              fit: BoxFit.cover

          )
      ),
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(


                children: [
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      _getimage();
                    },
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width  * 0.20,
                      backgroundColor: Colors.cyan,
                      backgroundImage:imagefile==null ? null:FileImage(File(imagefile!.path)) ,
                      child: imagefile==null ? Icon(
                        Icons.add_photo_alternate,
                        size:MediaQuery.of(context).size.width * 0.20 ,
                        color: Colors.grey,
                      ):null,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Form(
                    key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFields(
                            data: Icons.backpack,
                            controller: packagenamecontroller,
                            isObsecure: false,
                            hinttext: "Enter Package Name",
                          ),
                          CustomTextFields(
                            data: Icons.place,
                            controller: placename,
                            isObsecure: false,
                            hinttext: "Enter Place Name",
                          ),
                          CustomTextFields(
                            data: Icons.hotel,
                            controller: hotelname,
                            isObsecure: false,
                            hinttext: "Enter Hotel Name",
                          ),
                          CustomTextFields(
                            data: Icons.countertops,
                            controller: person_count,
                            isObsecure: false,
                            hinttext: "Enter Person Count",
                          ),
                          CustomTextFields(
                            data: Icons.calendar_view_day,
                            controller: traveling_days,
                            isObsecure: false,
                            hinttext: "Enter Days Count",
                          ),
                          CustomTextFields(
                            data: Icons.travel_explore,
                            controller: vehicle_type,
                            isObsecure: false,
                            hinttext: "Enter Vehicle type",
                          ),
                          CustomTextFields(
                            data: Icons.price_change,
                            controller: package_price,
                            isObsecure: false,
                            hinttext: "Enter Package Price",
                          ),
                        ],
                      )),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){
                     formValidation();
                  }, child: Text("Add New Package"))

                ],
              ),
            ),
          ),
    ),
      ),
    );
  }
}
