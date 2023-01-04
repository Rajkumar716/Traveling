import 'package:flutter/material.dart';


CircularProgress(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10),
    child: CircularProgressIndicator(
         valueColor: AlwaysStoppedAnimation(
           Colors.amber
         ),
    )
  );

}