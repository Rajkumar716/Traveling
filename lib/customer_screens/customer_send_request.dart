import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_providers_app/customer_screens/customer_auth.dart';
import 'package:travel_providers_app/customer_screens/customer_login.dart';
import 'package:travel_providers_app/customer_screens/menu_drawer.dart';

import '../Common_access/Common.dart';
import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'customer_home.dart';



class CustomerSendRequest extends StatefulWidget {
 String providername,packagename,days,person,hotel,vehicle,price,providerid,place_name;
 CustomerSendRequest({required this.providername,required this.packagename,required this.days,required this.person,required this.hotel,required this.vehicle,required this.price,required this.providerid,required this.place_name});

  @override
  State<CustomerSendRequest> createState() => _CustomerSendRequestState(providername,packagename,days,person,hotel,vehicle,price,providerid,place_name);
}

class _CustomerSendRequestState extends State<CustomerSendRequest> {
  String providername,packagename,days,person,hotel,vehicle,price,providerid,place_name;
  _CustomerSendRequestState(this.providername,this.packagename,this.days,this.person,this.hotel,this.vehicle,
      this.price,this.providerid,this.place_name);
  String email=sharedPreferences!.getString("email").toString();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController requestpackage_name = TextEditingController();

  TextEditingController requesthotel_name = TextEditingController();
  TextEditingController requestperson_count = TextEditingController();
  TextEditingController requesttraveling_days = TextEditingController();
  TextEditingController requestvehicle_type = TextEditingController();
  TextEditingController requestpackage_price = TextEditingController();
  TextEditingController request_Date = TextEditingController();

  TextEditingController requestplaceController = TextEditingController();


  Future SaveDataFireStore() async{
    String send_date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    FirebaseFirestore.instance.collection("customer_requests").doc().set(
        {
          "customer_id":sharedPreferences!.getString("uid"),
          "customer_email":sharedPreferences!.getString("email"),
          "provider_id":providerid,
          "provider_name":providername,
          "package_name":packagename,
          "place_name":place_name,
          "Staying_hotel":hotel,
          "person_count":person,
          "days_count":days,
          "vehicle_type":vehicle,
          "package_price":price,
          "request_date":request_Date.text,
          "request_send_date":send_date


        }

    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestpackage_name.text=packagename;
    requestplaceController.text=place_name;
    requesthotel_name.text=hotel;
    requestperson_count.text=person;
    requesttraveling_days.text=days;
    requestpackage_price.text=price;
    requestvehicle_type.text=vehicle;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("CUSTOMER SEND REQUEST"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                firebaseAuth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>CustomerAuth()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
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
                  Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFields(
                            data: Icons.backpack,
                            controller: requestpackage_name,
                            isObsecure: false,
                            enablde: false,
                            hinttext: "Enter Package Name",
                          ),
                          CustomTextFields(
                            data: Icons.place,
                            controller: requestplaceController,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Place Name",
                          ),
                          CustomTextFields(
                            data: Icons.hotel,
                            controller: requesthotel_name,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Hotel Name",
                          ),
                          CustomTextFields(
                            data: Icons.countertops,
                            controller: requestperson_count,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Person Count",
                          ),
                          CustomTextFields(
                            data: Icons.calendar_view_day,
                            controller: requesttraveling_days,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Days Count",
                          ),
                          CustomTextFields(
                            data: Icons.travel_explore,
                            controller: requestvehicle_type,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Vehicle type",
                          ),
                          CustomTextFields(
                            data: Icons.price_change,
                            controller: requestpackage_price,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Package Price",
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),

                            ),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              controller: request_Date,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusColor: Theme.of(context).primaryColor,
                                  icon: Icon(Icons.calendar_today), //icon of text field
                                  labelText: "Request  Date" //label text of field
                              ),
                              readOnly: true,
                              onTap: () async{
                                DateTime? pickedDate = await showDatePicker(
                                    context: context, initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101)
                                );
                                if(pickedDate != null ){
                                  print(pickedDate);
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  print(formattedDate);

                                  setState(() {
                                    request_Date.text = formattedDate; //set output date to TextField value.
                                  });
                                }
                              },

                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 10,),
                  ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          primary: Colors.amber
                      ),
                      onPressed: (){

                        if(request_Date.text.isEmpty){
                          showDialog(context: context,
                              builder: (context){
                                return ErrorDialog(
                                  message: "Date Not Selected........",
                                );
                              });
                        }else{
                          showDialog(context: context,
                              builder: (context){
                                return LoadingDialog(
                                  message: "Sending Package Request Happening",
                                );
                              });
                          SaveDataFireStore();
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomerHome()));

                        }

                      }, child: Text("SEND REQUEST")),
                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
