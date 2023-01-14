import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/customer_screens/customer_auth.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';

import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';


class CustomerChangePassword extends StatefulWidget {
  const CustomerChangePassword({Key? key}) : super(key: key);

  @override
  State<CustomerChangePassword> createState() => _CustomerChangePasswordState();
}

class _CustomerChangePasswordState extends State<CustomerChangePassword> {
  TextEditingController old_Password=TextEditingController();
  TextEditingController new_paswordd=TextEditingController();

  var auth=FirebaseAuth.instance;
  var CurrentUser=firebaseAuth.currentUser;


  changePassword(email,old_pass,new_pass)async{
    if(old_Password.text.isEmpty && new_paswordd.text.isEmpty){
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: "Please Fill The Text Feilds........",
            );
          });
    }else{
      var cred=EmailAuthProvider.credential(email: email, password: old_pass);
      await CurrentUser?.reauthenticateWithCredential(cred).then((value){
        CurrentUser!.updatePassword(new_pass);
        firebaseAuth.signOut();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomerAuth()));
      }).catchError((error){
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                message: error.message.toString(),
              );
            });
      });

    }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("CHANGE PASSWORD"),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerHome()));
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/provider_reply.jpg"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 200, 10, 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                      child: Column(

                        children: [

                          CustomTextFields(
                            data: Icons.password,
                            controller: old_Password,
                            isObsecure: false,

                            hinttext: "Enter Your Old Password",
                          ),
                          CustomTextFields(
                            data: Icons.password,
                            controller: new_paswordd,
                            isObsecure: false,

                            hinttext: "Enter New Password",
                          ),

                          ElevatedButton(
                              style:
                              ElevatedButton.styleFrom(primary: Colors.amber),
                              onPressed: ()  async{
                                print(sharedPreferences!.getString("email").toString());
                                await changePassword(sharedPreferences!.getString("email").toString(),old_Password.text, new_paswordd.text);

                              },
                              child: Text("CHANGE PASSWORD"))
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
