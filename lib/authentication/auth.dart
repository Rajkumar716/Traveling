import 'package:flutter/material.dart';
import 'package:travel_providers_app/authentication/Register.dart';
import 'package:travel_providers_app/authentication/login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Provider's",
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
              LoginScreen(),
                 RegisterScreen(),

            ],
          ),
        ),

      ),
    );
  }
}
