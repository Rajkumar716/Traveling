import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/authentication/auth.dart';


class ProviderViewAcceptRequest extends StatefulWidget {
  const ProviderViewAcceptRequest({Key? key}) : super(key: key);

  @override
  State<ProviderViewAcceptRequest> createState() => _ProviderViewAcceptRequestState();
}

class _ProviderViewAcceptRequestState extends State<ProviderViewAcceptRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: Text("VIEW SEND REPLYS"),

        centerTitle: true,

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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("request_reply")
              .where("accept_provider_id", isEqualTo: sharedPreferences!.getString("uid"))
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
                  return  Stack(
                    children: [
                      Column(

                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.amber[400],
                              child: Column(

                                children: [

                                  SizedBox(height: 10,),
                                  Text("Customer Email : ${task['customer_email']}",style:TextStyle(fontSize: 18),),
                                  Text("Package Request Date : ${task['request_date']}",style:TextStyle(fontSize: 18),),
                                  Text("Request Status: ${task['request_status']}",style:TextStyle(fontSize: 18),),
                                  Text("Package Name : ${task['package_name']}",style:TextStyle(fontSize: 18),),
                                  Text("Place Name : ${task['traveling_place']}",style:TextStyle(fontSize: 18),),
                                  Text("Hotel Name : ${task['hotel_name']}",style:TextStyle(fontSize: 18),),
                                  Text("Max Person Count : ${task['person_count']}",style:TextStyle(fontSize: 18),),
                                  Text("Staying Days : ${task['traveling_days']}",style:TextStyle(fontSize: 18),),
                                  Text("Traveling Vehicle Type: ${task['vehicle_type']}",style:TextStyle(fontSize: 18),),
                                  Text("Package Price: ${task['package_price']}",style:TextStyle(fontSize: 18),),
                                  Text("Payment Status : ${task['payment_status']}",style:TextStyle(fontSize: 18),),

                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber[700]
                                          ),
                                          onPressed: (){

                                            FirebaseFirestore.instance.collection("request_reply").doc(task.id).update(
                                                {

                                                        "payment_status":"PAID"

                                                });

                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProviderViewAcceptRequest()));

                                          }, child: Text("Update Payment Status",style: TextStyle(fontSize: 20),)),
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
