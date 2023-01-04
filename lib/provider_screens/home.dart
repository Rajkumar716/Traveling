import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/authentication/auth.dart';
import 'package:travel_providers_app/provider_screens/add_new_package.dart';
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
        title: Text(sharedPreferences!.getString("name")!),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: StreamBuilder(
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
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Package Name : ${task['packagename']}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                          "Person Count :${task['person_count']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      Text("Days Count :${task['days_count']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      Text("Vehicle Type :${task['vehicletype']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      Text("Hotel Name :${task['Hotel_name']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      Text(
                                          "Provider Name :${task['providername']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      Text(
                                          "Package Price :${task['package_price']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 160),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                FirebaseFirestore.instance
                                                    .collection("packages")
                                                    .where("packagename",
                                                        isEqualTo:
                                                            task['packagename'])
                                                    .get()
                                                    .then((value) {
                                                  value.docs.first.reference
                                                      .delete();
                                                });
                                              },
                                              child: Icon(Icons.delete),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdatePackage(packagename:task['packagename'],packageid:task.id,
                                                                placename:task['Hotel_name'],price:task['package_price'],
                                                                days:task['days_count'],person:task['person_count'],
                                                                vehicle:task['vehicletype'],packimage:task['packageimage'])));
                                              },
                                              child: Icon(Icons.edit),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ADDPACKAGE()));
        },
        child: Text("ADD"),
      ),
    );
  }
}
