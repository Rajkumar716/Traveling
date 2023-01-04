import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {

  final TextEditingController? controller;
  final IconData? data;
  final String? hinttext;
  final String? value;
  bool? isObsecure=true;
  bool? enablde=true;

  CustomTextFields({ this.controller,this.data,this.hinttext,this.isObsecure,this.enablde,this.value});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),

      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        enabled: enablde,
        controller: controller,
        obscureText: isObsecure!,
        validator: (value){
          if(value !=null && value.isEmpty){
            return "Enter the Value";
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.cyan,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hinttext
        ),


      ),
    );
  }
}
