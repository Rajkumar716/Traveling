import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/authentication/auth.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';
import 'package:travel_providers_app/provider_screens/home.dart';
import 'package:travel_providers_app/provider_screens/send_reply_request.dart';

import '../Common_access/Common.dart';

class ProviderViewRequest extends StatefulWidget {
  const ProviderViewRequest({Key? key}) : super(key: key);

  @override
  State<ProviderViewRequest> createState() => _ProviderViewRequestState();
}

class _ProviderViewRequestState extends State<ProviderViewRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("CUSTOMER SEND REQUEST"),
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
                image: AssetImage("images/view_request.jpg"),
                fit: BoxFit.cover

            )
        ),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("customer_requests")
                .where("provider_id",
                    isEqualTo: sharedPreferences!.getString("uid").toString())
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
                      return Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.amber[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Customer Email : ${task['customer_email']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Package Name : ${task['package_name']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Place Name : ${task['place_name']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Traveling Days : ${task['days_count']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Max Person Count : ${task['person_count']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Staying Hotel Name : ${task['Staying_hotel']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Traveling Vehicle Type: ${task['vehicle_type']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Package Price: ${task['package_price']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Customer Request Date: ${task['request_date']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Request Send Date: ${task['request_send_date']}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.amber),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProviderReplyRequest(email:task['customer_email'],
                                                packagename:task['package_name'],travelingday:task['days_count'],personcount:task['person_count'],
                                                hotelname:task['Staying_hotel'],vehicletype:task['vehicle_type'],packageprice:task['package_price'],
                                                request_date:task['request_date'],place_name:task['place_name'])));
                                              },
                                              child: Text("Request Reply Page"))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    });
              }
            }),
      ),
    );
  }
}
