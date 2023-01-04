import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/authentication/auth.dart';
import 'package:travel_providers_app/provider_screens/home.dart';
import 'package:travel_providers_app/splashscreen/customersplashscreen.dart';
import 'package:travel_providers_app/splashscreen/splashscreen.dart';

class ChooseAccount extends StatefulWidget {
  const ChooseAccount({Key? key}) : super(key: key);

  @override
  State<ChooseAccount> createState() => _ChooseAccountState();
}

class _ChooseAccountState extends State<ChooseAccount> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title:Text("CHOOSE ACCOUNT"),
        centerTitle: true,
      ),
      body: Container(
        height: 700,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/travel.jpg"),
            fit: BoxFit.cover
          ),

        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary: Colors.amber[400],
                    minimumSize: Size.fromHeight(50),
                  ),

                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MysplashApp()));
                  }, child: Text("Provider Account",style: TextStyle(fontSize: 24),)),
              SizedBox(height: 20,),
              ElevatedButton(
                style:ElevatedButton.styleFrom(
                  primary: Colors.amber[400],
                  minimumSize: Size.fromHeight(50),
                ),

                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerSplash()));
              }, child: Text("Customer Account",style: TextStyle(fontSize: 24),)),

            ],
          ),
        ),
      ),
    );
  }
}
