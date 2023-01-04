

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/provider_screens/home.dart';
import 'package:travel_providers_app/widgets/custom_textFeilds.dart';
import 'dart:io';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;


class UpdatePackage extends StatefulWidget {
 String packagename,packageid,placename,price,days,person,vehicle,packimage;
 UpdatePackage({required this.packagename,required this.packageid,required this.placename,required this.days,
   required this.person,required this.vehicle,required this.price,required this.packimage});

  @override
  State<UpdatePackage> createState() => _UpdatePackageState(packagename,packageid,placename,price,days,person,vehicle,packimage);
}

class _UpdatePackageState extends State<UpdatePackage> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController packagenamecontroller= TextEditingController();
  TextEditingController hotelname= TextEditingController();
  TextEditingController person_count= TextEditingController();
  TextEditingController traveling_days= TextEditingController();
  TextEditingController vehicle_type= TextEditingController();
  TextEditingController package_price= TextEditingController();

 String packagename,packageid,placename,price,days,person,vehicle,packimage;
 _UpdatePackageState(this.packagename,this.packageid,this.placename,this.price,this.days,this.person,this.vehicle,this.packimage);

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
                message: "Updating Package Happening",
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

        UpdateDataFireStore();
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ProviderHome()));


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

  Future UpdateDataFireStore() async{
        FirebaseFirestore.instance.collection("packages").doc(packageid).update(
            {
              "Hotel_name":hotelname.text.trim(),
              "days_count":traveling_days.text,
              "package_price":package_price.text,
              "packageimage":packageimageurl,
              "packagename":packagenamecontroller.text.trim(),
              "person_count":person_count.text,
              "vehicletype":vehicle_type.text


            });

  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packagenamecontroller.text=packagename;
     hotelname.text=placename;
    person_count.text=person;
    traveling_days.text=days;
    vehicle_type.text=vehicle;
    package_price.text=price;



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Package"),
        centerTitle: true,
      ),body: SingleChildScrollView(
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
                  backgroundImage:imagefile==null ? null:FileImage(File(imagefile!.path)),
                  child: imagefile==null ? CircleAvatar(backgroundImage: NetworkImage(packimage),):null,

                ),
              ),
              SizedBox(height: 10,),
              Form(
              key: _formkey,
               child: Column(
                 children: [
                   CustomTextFields(
                     data: Icons.backpack,
                     controller: packagenamecontroller,
                     isObsecure: false,
                     hinttext: "Enter the Package Name",
                   ),
                   CustomTextFields(
                     data: Icons.hotel,
                     controller: hotelname,
                     isObsecure: false,
                     hinttext: "Enter the Hotel Name",
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
                   SizedBox(height: 10,),
                   ElevatedButton(onPressed: (){
                          formValidation();
                   }, child: Text("UpDate Package"))

                 ],
               ),)

            ],
          ),
        ),
      ),
    ),

    );
  }
}
