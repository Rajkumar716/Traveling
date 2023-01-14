import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';
import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';



class Customer_register extends StatefulWidget {
  const Customer_register({Key? key}) : super(key: key);

  @override
  State<Customer_register> createState() => _Customer_registerState();
}

class _Customer_registerState extends State<Customer_register> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController namecontroller= TextEditingController();
  TextEditingController emailcontroller= TextEditingController();
  TextEditingController passwordcontroller= TextEditingController();
  TextEditingController confirmpasscontroller= TextEditingController();
  TextEditingController phonecontroller= TextEditingController();
  TextEditingController locationcontroller= TextEditingController();

  // get the picture from the gallery
  XFile? imagefile;
  final ImagePicker _picker=ImagePicker();
  String customerimageurl="";

  Future<void> _getimage() async{
    imagefile=await _picker.pickImage(source: ImageSource.gallery) as XFile?;

    setState(() {
      imagefile;
    });
  }

  Future<void> formvalidation()async{
    if(imagefile == null){
      showDialog(context: context,
          builder: (context){
            return ErrorDialog(
              message: "Select the Image......",
            );
          });
    }else{
      if(passwordcontroller.text==confirmpasscontroller.text){
        if(confirmpasscontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty && namecontroller.text.isNotEmpty && phonecontroller.text.isNotEmpty && locationcontroller.text.isNotEmpty){
          showDialog(context: context,
              builder: (context){
                return LoadingDialog(
                  message: "Registering Happening",
                );
              });
          //Save the Image file into FirebaseStore
          String FileName=DateTime.now().microsecondsSinceEpoch.toString();
          fstorage.Reference reference=fstorage.FirebaseStorage.instance.ref().child("customer").child(FileName);
          fstorage.UploadTask uploadTask=reference.putFile(File(imagefile!.path));
          fstorage.TaskSnapshot taskSnapshot=await uploadTask.whenComplete((){});
          await taskSnapshot.ref.getDownloadURL().then((url){
            customerimageurl=url;
          });

          //save data to the FirebaseFireStore
          authenticateandsignup();

        }else{
          showDialog(context: context,
              builder: (context){
                return ErrorDialog(
                  message: "Please Fill All Text Feilds...",
                );
              });
        }

      }else{
        showDialog(context: context,
            builder: (context){
              return ErrorDialog(
                message: "Confirm Password Not match With Password",
              );
            });
      }

    }
  }


  //save the email and passworsd to the Authentication to the firebase
  void authenticateandsignup()async{
    User? Currentuser;

    await firebaseAuth.createUserWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim()).then((Auth){
      Currentuser=Auth.user;

    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
          builder: (context){
            return ErrorDialog(
                message: error.message.toString()
            );
          });
    });

    if(Currentuser != null){
      SaveDataFireStore(Currentuser!).then((value){
        Route newroute=MaterialPageRoute(builder: (context)=>CustomerHome());
        Navigator.push(context, newroute);
      });
    }


  }


  Future SaveDataFireStore(User CurrentUser)async{
    FirebaseFirestore.instance.collection('customers').doc(CurrentUser.uid).set(
        {
          "customerUID":CurrentUser.uid,
          "customerEmail":CurrentUser.email,
          "customerName": namecontroller.text.trim(),
          "customerimageurl":customerimageurl,
          "customerphone":phonecontroller.text.trim(),
          "customeraddress":locationcontroller.text.trim(),


        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/customer_register.jpg"),
              fit: BoxFit.cover)),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFields(
                        data: Icons.person,
                        controller: namecontroller,
                        isObsecure: false,
                        hinttext: "Enter Username",
                      ),
                      CustomTextFields(
                        data: Icons.email,
                        controller: emailcontroller,
                        isObsecure: false,
                        hinttext: "Enter Email",
                      ),
                      CustomTextFields(
                        data: Icons.password,
                        controller: passwordcontroller,
                        isObsecure: true,
                        hinttext: "Enter Password",
                      ),  CustomTextFields(
                        data: Icons.password,
                        controller: confirmpasscontroller,
                        isObsecure: true,
                        hinttext: "Enter Confirm Password",
                      ),  CustomTextFields(
                        data: Icons.phone,
                        controller: phonecontroller,
                        isObsecure: false,
                        hinttext: "Enter Phone Number",
                      ),
                      CustomTextFields(
                        data: Icons.location_city,
                        controller: locationcontroller,
                        isObsecure: false,
                        hinttext: "Enter location",
                        enablde: true,
                      ),


                    ],
                  ),
                ),
              ),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[500]
                  ),
                  onPressed: (){
                    formvalidation();
              }, child: Text("REGISTER"))

            ],
          ),
        ),
      ),
    );
  }
}
