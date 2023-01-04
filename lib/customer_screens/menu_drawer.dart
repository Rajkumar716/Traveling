import 'package:flutter/material.dart';
import 'package:travel_providers_app/Common_access/Common.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color:Colors.amber[600],
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(sharedPreferences!.getString("photourl").toString()),
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(sharedPreferences!.getString("name").toString(),style: TextStyle(fontSize: 20,color: Colors.white),),
                  SizedBox(height: 8,),
                  Text(sharedPreferences!.getString("email").toString(),style: TextStyle(fontSize: 20,color: Colors.white),)
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("ProFile",style: TextStyle(fontSize: 15),),
            onTap: (){

            },
          ),
          SizedBox(height: 5,),
          ListTile(
            leading: Icon(Icons.view_array),
            title: Text("View Send Request",style: TextStyle(fontSize: 15),),
            onTap: (){

            },
          ),
          SizedBox(height: 5,),
          ListTile(
            leading: Icon(Icons.view_array),
            title: Text("View Accept Request",style: TextStyle(fontSize: 15),),
            onTap: (){

            },
          ),

        ],
      ),
    );
  }
}
