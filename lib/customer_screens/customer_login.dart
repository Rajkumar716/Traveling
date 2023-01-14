import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';
import 'package:travel_providers_app/customer_screens/cutomer_forget_password.dart';

import '../Common_access/Common.dart';
import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';


class Customer_login extends StatefulWidget {
  const Customer_login({Key? key}) : super(key: key);

  @override
  State<Customer_login> createState() => _Customer_loginState();
}

class _Customer_loginState extends State<Customer_login> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController emailcontroller= TextEditingController();
  TextEditingController passwordcontroller= TextEditingController();

  formvalidation()async{
    if(emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty){
      showDialog(
          context: context,
          builder: (context){
            return LoadingDialog(
              message: "Checking Details ",
            );
          });
      loginnow();
    }else{
      showDialog(
          context: context,
          builder:(context){
            return ErrorDialog(
              message: "Enter The Email/Password",
            );
          });
    }
  }

  loginnow()async{
    User? Currentuser;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim()
    ).then((auth){
      Currentuser= auth.user;

    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
          builder:(context){
            return ErrorDialog(
              message:error.message.toString() ,
            );
          });
    });
    if(Currentuser !=null){
      readDataAndSetLocalData(Currentuser!).then((value){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> CustomerHome()));

      });
    }
  }

  Future readDataAndSetLocalData(User Currentuser)async{
    await FirebaseFirestore.instance.collection("customers").doc(Currentuser.uid).get().then((snapshot)async{
      await sharedPreferences!.setString("uid", Currentuser.uid);
      await sharedPreferences!.setString("email", snapshot.data()!["customerEmail"]);
      await sharedPreferences!.setString("name", snapshot.data()!["customerName"]);
      await sharedPreferences!.setString("photourl", snapshot.data()!["customerimageurl"]);


    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/customer_login.jpg"),
              fit: BoxFit.cover)),
      child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.bottomCenter,

                child: Padding(
                  padding: EdgeInsets.all(15),
                  child:CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.20,
                    backgroundImage: AssetImage("images/lock.jpg"),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextFields(
                      data:Icons.email,
                      controller: emailcontroller,
                      isObsecure: false,
                      hinttext: "Enter the Email",
                    ),
                    CustomTextFields(
                      data:Icons.lock,
                      controller: passwordcontroller,
                      isObsecure: true,
                      hinttext: "Enter the Password",
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        children:[ TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerForegetPassword()));
                        }, child: Text("Forget Password?",style: TextStyle(fontSize: 20,color: Colors.white,),))
                        ]
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 200,
                height: 60,
                child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[500]
                    ),
                    onPressed: (){
                  formvalidation();
                }, child: Text("Login",style: TextStyle(color: Colors.white),)) ,
              ),

            ],
          )
      ),
    );
  }
}
