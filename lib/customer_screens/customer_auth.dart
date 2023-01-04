import 'package:flutter/material.dart';
import 'package:travel_providers_app/authentication/Register.dart';
import 'package:travel_providers_app/authentication/login.dart';
import 'package:travel_providers_app/customer_screens/customer_login.dart';
import 'package:travel_providers_app/customer_screens/customer_register.dart';


class CustomerAuth extends StatefulWidget {
  const CustomerAuth({Key? key}) : super(key: key);

  @override
  State<CustomerAuth> createState() => _CustomerAuthState();
}

class _CustomerAuthState extends State<CustomerAuth> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Customer's",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "Lobster"
            ),),
          centerTitle:true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock,color: Colors.white,),
                text: "Login",

              ),
              Tab(
                icon: Icon(Icons.person,color: Colors.white,),
                text: "Register",

              )

            ],
            indicatorColor: Colors.black,
          ),

        ),
        body: Container(
          child: TabBarView(
            children: [
              Customer_login(),
             Customer_register(),

            ],
          ),
        ),

      ),
    );
  }
}
