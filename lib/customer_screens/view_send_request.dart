import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/customer_screens/customer_home.dart';

import '../Common_access/Common.dart';
import 'customer_auth.dart';


class ViewSendRequest extends StatefulWidget {
  const ViewSendRequest({Key? key}) : super(key: key);

  @override
  State<ViewSendRequest> createState() => _ViewSendRequestState();
}

class _ViewSendRequestState extends State<ViewSendRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("VIEW SEND REQUEST"),
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
      body:Container(
        decoration: BoxDecoration(

            image: DecorationImage(
                image: AssetImage("images/view_send_ request.jpg"),
                fit: BoxFit.cover

            )
        ),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("customer_requests").where("customer_id",isEqualTo:sharedPreferences!.getString("uid").toString()).snapshots(),
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
                                      Text("Provider Name : ${task['provider_name']}",style:TextStyle(fontSize: 18),),
                                      Text("Package Name : ${task['package_name']}",style:TextStyle(fontSize: 18),),
                                      Text("Traveling Days : ${task['days_count']}",style:TextStyle(fontSize: 18),),
                                      Text("Max Person Count : ${task['person_count']}",style:TextStyle(fontSize: 18),),
                                      Text("Staying Hotel Name : ${task['Staying_hotel']}",style:TextStyle(fontSize: 18),),
                                      Text("Traveling Vehicle Type: ${task['vehicle_type']}",style:TextStyle(fontSize: 18),),
                                      Text("Package Price: ${task['package_price']}",style:TextStyle(fontSize: 18),),
                                      Text("Request Date: ${task['request_date']}",style:TextStyle(fontSize: 18),),
                                      Text("Request Send Date: ${task['request_send_date']}",style:TextStyle(fontSize: 18),),
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
