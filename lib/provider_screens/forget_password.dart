import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';

import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';


class ForGetPassword extends StatefulWidget {
  const ForGetPassword({Key? key}) : super(key: key);

  @override
  State<ForGetPassword> createState() => _ForGetPasswordState();
}

class _ForGetPasswordState extends State<ForGetPassword> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController emailcontroller= TextEditingController();


  Future<void> formvalidation()async{
    if(emailcontroller.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return ErrorDialog(
              message: "Please Enter The Email......",
            );
          });
    }else{
      await  firebaseAuth.sendPasswordResetEmail(email: emailcontroller.text);
      print(emailcontroller.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: Text("RESRT PASSWORD"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/forget_password.jpg"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 300, 10, 300),
            child: Column(


              children: [
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
                        SizedBox(height: 10,),
                        Container(
                          width: 200,
                          height: 60,
                          child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber[500]
                              ),
                              onPressed: () async{


                                 formvalidation();



                              }, child: Text("Send Reset Link",style: TextStyle(color: Colors.white,fontSize: 20),)) ,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

