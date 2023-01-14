import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/customer_screens/customer_auth.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';

import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';



class CustomerUpdateProfile extends StatefulWidget {
  const CustomerUpdateProfile({Key? key}) : super(key: key);

  @override
  State<CustomerUpdateProfile> createState() => _CustomerUpdateProfileState();
}

class _CustomerUpdateProfileState extends State<CustomerUpdateProfile> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController customerName= TextEditingController();
  TextEditingController customeraddress= TextEditingController();
  TextEditingController customerphone= TextEditingController();

  Future<void> formValidation() async{
    if(customerName.text.isEmpty && customeraddress.text.isEmpty && customerphone.text.isEmpty){
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
      UpdateCustomerDetails();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerHome()));

    }
  }

  Future UpdateCustomerDetails() async{
    FirebaseFirestore.instance.collection("customers").doc(sharedPreferences!.getString("uid")).update({

      "customerName":customerName.text.trim(),
      "customeraddress":customeraddress.text.trim(),
      "customerphone":customerphone.text,

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: Text("UPDATE PROFILE"),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerHome()));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                firebaseAuth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerAuth()));
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
              .collection("customers")
              .where("customerEmail", isEqualTo: sharedPreferences!.getString("email"))
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
                  customerName.text=task['customerName'];
                  customeraddress.text=task['customeraddress'];
                  customerphone.text=task['customerphone'];
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
                                          controller: customerName,
                                          isObsecure: false,
                                          hinttext: "Enter the  Name",
                                        ),

                                        CustomTextFields(
                                          data: Icons.hotel,
                                          controller: customeraddress,
                                          isObsecure: false,
                                          hinttext: "Enter the Address",
                                        ),
                                        CustomTextFields(
                                          data: Icons.countertops,
                                          controller: customerphone,
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
                                          onPressed: ()async{

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
