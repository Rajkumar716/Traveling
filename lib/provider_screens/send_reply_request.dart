import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_providers_app/authentication/auth.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';
import 'package:travel_providers_app/provider_screens/View_customer_request.dart';

import '../Common_access/Common.dart';
import '../widgets/custom_textFeilds.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'home.dart';

class ProviderReplyRequest extends StatefulWidget {
  String email,
      packagename,
      travelingday,
      personcount,
      hotelname,
      vehicletype,
      packageprice,
      request_date,
      place_name;
  ProviderReplyRequest(
      {required this.email,
      required this.packagename,
      required this.travelingday,
      required this.personcount,
      required this.hotelname,
      required this.vehicletype,
      required this.packageprice,
      required this.request_date,
      required this.place_name});

  @override
  State<ProviderReplyRequest> createState() => _ProviderReplyRequestState(
      email,
      packagename,
      travelingday,
      personcount,
      hotelname,
      vehicletype,
      packageprice,
      request_date,
      place_name);
}

class _ProviderReplyRequestState extends State<ProviderReplyRequest> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController package_name = TextEditingController();
  TextEditingController customeremail = TextEditingController();
  TextEditingController hotel_name = TextEditingController();
  TextEditingController person_count = TextEditingController();
  TextEditingController traveling_days = TextEditingController();
  TextEditingController vehicle_type = TextEditingController();
  TextEditingController package_price = TextEditingController();
  TextEditingController request_Date = TextEditingController();
  TextEditingController commentcontroller = TextEditingController();
  TextEditingController dropdown_value = TextEditingController();
  TextEditingController placeController = TextEditingController();
  String dropdownvalue = "APPROVED";

  String email,
      packagename,
      travelingday,
      personcount,
      hotelname,
      vehicletype,
      packageprice,
      request_date,
      place_name;
  _ProviderReplyRequestState(
      this.email,
      this.packagename,
      this.travelingday,
      this.personcount,
      this.hotelname,
      this.vehicletype,
      this.packageprice,
      this.request_date,
      this.place_name);
  


  Future<void> formvalidation() async {
    if (dropdown_value.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: "Select One Option......",
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return LoadingDialog(
              message: "Request Reply Send",
            );
          });
           SavedRequestReply();
           Navigator.push(context,
               MaterialPageRoute(builder: (context) => ProviderHome()));
      FirebaseFirestore.instance.collection("customer_requests").where("customer_email",isEqualTo:email).get().then((value){
        value.docs.first.reference.delete();
      });
      String Providername=sharedPreferences!.getString("name").toString();

      SendEmail(
          "Reply From the Traveling Provider :"+Providername,
          "Package Name: ${package_name.text} \n Place Name: ${placeController.text}"
              " \n Staying Hotel Name: ${hotel_name.text} \n Person Count: ${person_count.text}"
              " \n Traveling Days: ${traveling_days.text} \n Traveling vehicle: ${vehicle_type.text}"
              " \n Package Price: ${package_price.text} \n Request Status: ${dropdown_value.text} \n Comments: ${commentcontroller.text}",
          customeremail.text);


    }
  }



  Future SavedRequestReply() async {
    String? method="NONE";
    String? note="NONE";
    if(dropdown_value.text=="APPROVED"){
      method="Cash Payment Only";
      note="Prepare For Your Traveling,After The Traveling Completed, Your Can Pay Payment";
    }
    FirebaseFirestore.instance.collection("request_reply").doc().set({
      "package_name": package_name.text,
      "accept_provider_id":sharedPreferences!.getString("uid"),
      "provider_name":sharedPreferences!.getString("name"),
      "provider_email":sharedPreferences!.getString("email"),
      "traveling_place": placeController.text,
      "customer_email": customeremail.text,
      "hotel_name": hotel_name.text,
      "person_count": person_count.text,
      "traveling_days": traveling_days.text,
      "vehicle_type": vehicle_type.text,
      "request_date": request_Date.text,
      "package_price": package_price.text,
      "payment_status": "PENDING",
      "payment_request":method,
      "Note":note,
      "request_status": dropdown_value.text,
      "comments": dropdown_value.text + "\n" + commentcontroller.text
    });
  }

  SendEmail(String subject, String body, String customeremail) async {
    final Email email = Email(
        body: body,
        subject: subject,
        recipients: [customeremail],
        isHTML: false);
    await FlutterEmailSender.send(email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    package_name.text = packagename;
    customeremail.text=email;
    hotel_name.text = hotelname;
    person_count.text = personcount;
    traveling_days.text = travelingday;
    vehicle_type.text = vehicletype;
    package_price.text = packageprice;
    request_Date.text = request_date;
    placeController.text = place_name;
   

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("PROVIDER REPLY REQUEST"),
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
                            controller: package_name,
                            isObsecure: false,
                            enablde: false,
                            hinttext: "Enter Package Name",
                          ),
                          CustomTextFields(
                            data: Icons.email,
                             controller:customeremail ,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Place Name",
                          ),
                          CustomTextFields(
                            data: Icons.place,
                              controller: placeController,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Hotel Name",
                          ),
                          CustomTextFields(
                            data: Icons.hotel,
                                 controller: hotel_name,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Person Count",
                          ),
                          CustomTextFields(
                            data: Icons.person,
                            controller: person_count,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Days Count",
                          ),
                          CustomTextFields(
                            data: Icons.view_day,
                            controller: traveling_days,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Vehicle type",
                          ),
                          CustomTextFields(
                            data: Icons.calendar_view_day,
                            controller: request_Date,
                            enablde: false,
                            isObsecure: false,
                            hinttext: "Enter Package Price",
                          ),
                          CustomTextFields(
                            data: Icons.price_change,
                            controller: package_price,
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
                            child: Row(children: [
                              Text("Choose Option :"),
                              SizedBox(
                                width: 40,
                              ),
                              DropdownButton<String>(
                                value: dropdownvalue,
                                items: <String>['APPROVED', 'REJECTED']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newvalue) {
                                  setState(() {
                                    dropdownvalue = newvalue!;
                                    dropdown_value.text = newvalue;
                                  });
                                },
                              ),
                            ]),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              controller: commentcontroller,
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              decoration: InputDecoration(
                                  hintText: "Enter Remarks",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.redAccent)
                                  )
                              ),

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

                        formvalidation();

                      }, child: Text("SEND REQUEST REPLY")),
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
