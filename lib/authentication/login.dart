import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/provider_screens/home.dart';
import 'package:travel_providers_app/widgets/custom_textFeilds.dart';
import 'package:travel_providers_app/widgets/error_dialog.dart';
import 'package:travel_providers_app/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController emailcontroller= TextEditingController();
  TextEditingController passwordcontroller= TextEditingController();

  Formvalidation(){
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
           Navigator.push(context,MaterialPageRoute(builder: (context)=> ProviderHome()));

         });
    }
  }

  Future readDataAndSetLocalData(User Currentuser)async{
    await FirebaseFirestore.instance.collection("providers").doc(Currentuser.uid).get().then((snapshot)async{
         await sharedPreferences!.setString("uid", Currentuser.uid);
         await sharedPreferences!.setString("email", snapshot.data()!["providerEmail"]);
         await sharedPreferences!.setString("name", snapshot.data()!["providerName"]);
         await sharedPreferences!.setString("photourl", snapshot.data()!["providerimageurl"]);

      
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,

            child: Padding(
              padding: EdgeInsets.all(15),
              child:CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundImage: AssetImage("images/login.jpg"),
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
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 200,
            height: 60,
            child:ElevatedButton(onPressed: (){
              Formvalidation();
            }, child: Text("Login",style: TextStyle(color: Colors.white),)) ,
          ),

        ],
      )
    );
  }
}
