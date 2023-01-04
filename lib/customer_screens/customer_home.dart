import 'package:flutter/material.dart';
import 'package:travel_providers_app/customer_screens/customer_auth.dart';
import 'package:travel_providers_app/customer_screens/customer_login.dart';
import 'package:travel_providers_app/customer_screens/menu_drawer.dart';


import '../Common_access/Common.dart';

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
        child: Center(
          child: Text("Home Page"),
        ),
      ),

    );
  }


}
