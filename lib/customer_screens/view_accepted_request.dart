import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';

import '../Common_access/Common.dart';
import 'customer_auth.dart';

class ViewAcceptedRequest extends StatefulWidget {
  const ViewAcceptedRequest({Key? key}) : super(key: key);

  @override
  State<ViewAcceptedRequest> createState() => _ViewAcceptedRequestState();
}

class _ViewAcceptedRequestState extends State<ViewAcceptedRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("VIEW ACCEPTED REQUEST"),
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
                    MaterialPageRoute(builder: (context) =>CustomerAuth()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body:Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/customer view.jpg"),
                fit: BoxFit.cover)),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("request_reply").where("customer_email",isEqualTo:sharedPreferences!.getString("email").toString()).snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                return ListView.builder(
                    itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                    itemBuilder: (context,index){
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
                                      Text("Provider Email : ${task['provider_email']}",style:TextStyle(fontSize: 18),),
                                      Text("Provider Name : ${task['provider_name']}",style:TextStyle(fontSize: 18),),
                                      Text("Traveling Place Name : ${task['traveling_place']}",style:TextStyle(fontSize: 18),),
                                      Text("Package Name : ${task['package_name']}",style:TextStyle(fontSize: 18),),
                                      Text("Hotel Name : ${task['hotel_name']}",style:TextStyle(fontSize: 18),),
                                      Text("Traveling Days : ${task['traveling_days']}",style:TextStyle(fontSize: 18),),
                                      Text("Max Person Count : ${task['person_count']}",style:TextStyle(fontSize: 18),),

                                      Text("Traveling Vehicle Type: ${task['vehicle_type']}",style:TextStyle(fontSize: 18),),
                                      Text("Package Price: ${task['package_price']}",style:TextStyle(fontSize: 18),),
                                      Text("Payment Status: ${task['payment_status']}",style:TextStyle(fontSize: 18),),
                                      Text("Payment Request: ${task['payment_request']}",style:TextStyle(fontSize: 18),),
                                      Text("Request Date: ${task['request_date']}",style:TextStyle(fontSize: 18),),
                                      Text("Request Status: ${task['request_status']}",style:TextStyle(fontSize: 18),),

                                      Text("NOTE : ${task['Note']}",style:TextStyle(fontSize: 18),),
                                      SizedBox(height: 10,)
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
