import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/Launch.dart';
import 'model/Rocket.dart';
import 'package:SpaceXFlutter_2/RocketDetails.dart';
import 'package:intl/intl.dart';

class LaunchList extends StatefulWidget {
  @override
  _LaunchListState createState() => _LaunchListState();
}

class _LaunchListState extends State<LaunchList> {
  Future<List<Launch>> getData() async{
    var launchData = await http.get("https://api.spacexdata.com/v2/launches");
    var jsonLaunchData = json.decode(launchData.body);
    List<Launch> launches = [];

    for(var l in jsonLaunchData){
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String dateStr = l["launch_date_local"].split("T")[0];
      final DateTime tmpTime = DateFormat('yyyy-MM-dd').parse(dateStr);
      final String formattedStr = formatter.format(tmpTime);
      Launch launch = Launch(flightNumber: l["flight_number"],missionName: l["mission_name"],launchYear: l["launch_year"],rocketId: l["rocket"]["rocket_id"],missionImage: l["links"]["mission_patch"],launchDate: formattedStr);
      launches.add(launch);
    }

    //attach Rocket-obj
    var rocketData = await http.get("https://api.spacexdata.com/v2/rockets");
    var jsonRocketData = json.decode(rocketData.body);

    for(var r in jsonRocketData){
      Rocket newRocket = Rocket(rocketId: r["id"],rocketName: r["name"], cost: r["cost_per_launch"],image: r["flickr_images"][0]);
      for(var l in launches){
        if(l.rocketId == newRocket.rocketId){
          l.rocket = newRocket;
        }
      }
    }

    launches.removeWhere((element) => element.rocket == null);

    return launches;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("SpaceX Rocket Launches"),
      ),
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            
            if(snapshot.data == null){

              return Container(
                child: Center(
                  child: Text("Loading........."),
                ),
              );

            }else{

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data[index].missionImage
                      ),
                    ),
                    title: Text("Flyvning: "+snapshot.data[index].flightNumber.toString()),
                    subtitle: Text("Mission: "+snapshot.data[index].missionName + ", Launch date: "+snapshot.data[index].launchDate),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RocketDetails(rocket: snapshot.data[index].rocket),
                        ),
                      );
                    },                  
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
