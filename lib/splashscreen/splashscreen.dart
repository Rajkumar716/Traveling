import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/authentication/auth.dart';
import 'package:travel_providers_app/provider_screens/home.dart';

class MysplashApp extends StatefulWidget {

  MysplashApp();

  @override
  State<MysplashApp> createState() => _MysplashAppState();
}

class _MysplashAppState extends State<MysplashApp> {


  starttimer(){
    Timer(const Duration(seconds: 10),()async{

          Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthScreen()));




    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starttimer();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
         width: 200,
        height: 100,
        decoration: BoxDecoration(

          image: DecorationImage(
            image: AssetImage("images/provider1.jpg"),
            fit: BoxFit.cover

          )
        ),
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.all(10),
                  child: Text( "WelCome To Provider Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Signatra",
                    fontSize: 30,
                    letterSpacing: 3,

                  ),))
            ],
          ) ,
        ),
      ),
    );
  }
}
