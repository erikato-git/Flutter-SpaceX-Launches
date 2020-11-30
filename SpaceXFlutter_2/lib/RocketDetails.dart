import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'model/Launch.dart';
import 'model/Rocket.dart';



class RocketDetails extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Rocket rocket;

  // In the constructor, require a Todo.
  RocketDetails({Key key, @required this.rocket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("Rocket: "+rocket.rocketName),
      ),

      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 70,
            child: Container(
              height: 250.0,
              width: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(rocket.image),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 375,
            left: 140,
            
            child:Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
                  Text("Rocket name: "+rocket.rocketName),
                  SizedBox(height: 15),
                  Text("Rocket price: \$"+rocket.cost.toString()),
              ]
            ),
          )

        ],
      ),

    );
  }
}

