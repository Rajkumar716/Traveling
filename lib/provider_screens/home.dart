import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/authentication/auth.dart';
import 'package:travel_providers_app/provider_screens/add_new_package.dart';
import 'package:travel_providers_app/provider_screens/provider_menu_drawer.dart';
import 'package:travel_providers_app/provider_screens/update_package.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({Key? key}) : super(key: key);

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: Text("PROVIDER HOME"),
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
      drawer: ProviderMenu(),
      body: Container(
          decoration: BoxDecoration(

              image: DecorationImage(
                  image: AssetImage("images/provider_dash.jpg"),
                  fit: BoxFit.cover

              )
          ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("packages")
              .where("providerid", isEqualTo: sharedPreferences!.getString("uid"))
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.amber[400],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10,),
                                  Text("Package Name : ${task['packagename']}",style:TextStyle(fontSize: 18),),
                                  Text("Place Name : ${task['place_name']}",style:TextStyle(fontSize: 18),),
                                  Text("Hotel Name : ${task['Hotel_name']}",style:TextStyle(fontSize: 18),),
                                  Text("Max Person Count : ${task['person_count']}",style:TextStyle(fontSize: 18),),
                                  Text("Staying Days : ${task['days_count']}",style:TextStyle(fontSize: 18),),
                                  Text("Traveling Vehicle Type: ${task['vehicletype']}",style:TextStyle(fontSize: 18),),
                                  Text("Package Price: ${task['package_price']}",style:TextStyle(fontSize: 18),),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber[700]
                                          ),
                                          onPressed: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdatePackage(packagename:task['packagename'],packageid:task.id,
                                                            placename:task['Hotel_name'],price:task['package_price'],
                                                            days:task['days_count'],person:task['person_count'],
                                                            vehicle:task['vehicletype'],packimage:task['packageimage'],place_name:task['place_name'])));

                                      }, child: Icon(Icons.edit)),
                                      SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber[700]
                                        ),
                                          onPressed: (){

                                        FirebaseFirestore.instance.collection("packages").where("packagename",isEqualTo: task['packagename']).get().then((value){
                                         value.docs.first.reference.delete();
                                        });

                                      }, child: Icon(Icons.delete)),

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[400],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ADDPACKAGE()));
        },
        child: Text("ADD"),
      ),
    );
  }
}
