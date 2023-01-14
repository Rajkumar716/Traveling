import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/customer_screens/customer_auth.dart';
import 'package:travel_providers_app/customer_screens/customer_login.dart';
import 'package:travel_providers_app/customer_screens/menu_drawer.dart';



import '../Common_access/Common.dart';
import 'customer_send_request.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("Customer Home"),
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
      drawer: CustomerDrawer(),
      body: Container(
        decoration: BoxDecoration(

            image: DecorationImage(
                image: AssetImage("images/customer_dash.jpg"),
                fit: BoxFit.cover

            )
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("packages").snapshots(),
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
                                color: Colors.orange[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10,),
                                    Text("Provider Name : ${task['providername']}",style:TextStyle(fontSize: 18),),
                                    Text("Package Name : ${task['packagename']}",style:TextStyle(fontSize: 18),),
                                    Text("Place Name : ${task['place_name']}",style:TextStyle(fontSize: 18),),
                                    Text("Traveling Days : ${task['days_count']}",style:TextStyle(fontSize: 18),),
                                    Text("Max Person Count : ${task['person_count']}",style:TextStyle(fontSize: 18),),
                                    Text("Staying Hotel Name : ${task['Hotel_name']}",style:TextStyle(fontSize: 18),),
                                    Text("Traveling Vehicle Type: ${task['vehicletype']}",style:TextStyle(fontSize: 18),),
                                    Text("Package Price: ${task['package_price']}",style:TextStyle(fontSize: 18),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.purple[200]),

                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSendRequest(providername:task['providername'],
                                              packagename:task['packagename'],days:task['days_count'],person:task['person_count'],
                                                  hotel:task['Hotel_name'],vehicle:task['vehicletype'],price:task['package_price'],providerid:task['providerid'],place_name:task['place_name'])));
                                        }, child: Text("Send Request Page")),

                                      ],
                                    ),
                                    SizedBox(height: 10,),
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
