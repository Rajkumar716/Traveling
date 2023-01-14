import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/provider_screens/home.dart';

import '../authentication/auth.dart';
import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class ProviderEditProfile extends StatefulWidget {
  const ProviderEditProfile({Key? key}) : super(key: key);

  @override
  State<ProviderEditProfile> createState() => _ProviderEditProfileState();
}

class _ProviderEditProfileState extends State<ProviderEditProfile> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController providerName= TextEditingController();
  TextEditingController provideraddress= TextEditingController();
  TextEditingController providerphone= TextEditingController();

  Future<void> formValidation() async{
    if(providerName.text.isEmpty && provideraddress.text.isEmpty && providerphone.text.isEmpty){
      showDialog(context: context,
          builder: (context){
            return ErrorDialog(
              message: "Enter Text Feilds.........",
            );
          });
    }else{
      showDialog(context: context,
          builder: (context){
            return LoadingDialog(
              message: "Updating Package Happening",
            );
          });
      UpdateProviderDetails();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProviderHome()));

    }
  }

  Future UpdateProviderDetails() async{
    FirebaseFirestore.instance.collection("providers").doc(sharedPreferences!.getString("uid")).update({

         "providerName":providerName.text.trim(),
          "provideraddress":provideraddress.text.trim(),
          "providerphone":providerphone.text,

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: Text("PROFILE DETAILS"),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProviderHome()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                firebaseAuth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body:  Container(
        decoration: BoxDecoration(

            image: DecorationImage(
                image: AssetImage("images/provider_dash.jpg"),
                fit: BoxFit.cover

            )
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("providers")
              .where("providerEmail", isEqualTo: sharedPreferences!.getString("email"))
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot task =
                  (snapshot.data! as QuerySnapshot).docs[index];
                  providerName.text=task['providerName'];
                  provideraddress.text=task['provideraddress'];
                  providerphone.text=task['providerphone'];
                  return  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 200,),
                                  Form(
                                    key: _formkey,
                                    child: Column(

                                      children: [
                                        CustomTextFields(
                                          data: Icons.person,
                                          controller: providerName,
                                          isObsecure: false,
                                          hinttext: "Enter the  Name",
                                        ),

                                        CustomTextFields(
                                          data: Icons.hotel,
                                          controller: provideraddress,
                                          isObsecure: false,
                                          hinttext: "Enter the Address",
                                        ),
                                        CustomTextFields(
                                          data: Icons.countertops,
                                          controller: providerphone,
                                          isObsecure: false,
                                          hinttext: "Enter PHone Number",
                                        ),



                                      ],
                                    ),),

                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(

                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber[700],

                                          ),
                                          onPressed: (){

                                            formValidation();

                                          }, child: Text("UPDATE PROFILE",style: TextStyle(fontSize: 20),)),
                                      SizedBox(width: 10,),


                                    ],
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],

                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
