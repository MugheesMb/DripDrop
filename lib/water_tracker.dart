
// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';


class MoodTrackerChartScreen extends StatefulWidget {
  const MoodTrackerChartScreen({super.key});

  @override
  MoodTrackerChartScreenState createState() => MoodTrackerChartScreenState();
}

class MoodTrackerChartScreenState extends State<MoodTrackerChartScreen> {
  List<int> dailyMoodValues = [10,20, 30, 5, 15,40,10];
  var userId = FirebaseAuth.instance.currentUser!.uid;
  int gal = 0;
  @override
  void initState() {
    super.initState();
    }

  

  // Future<void> _saveDailyMoodValues() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setStringList('daily_mood_values', dailyMoodValues.map((value) => value.toString()).toList());
  // }

  //final ScrollController _scrollController = ScrollController();

  Future<List<WaterData>> fetchWaterDataFromFirestore() async {
    final QuerySnapshot query = await FirebaseFirestore.instance.collection('waterData').doc(userId).collection("water").get();
    return query.docs.map((doc) => WaterData.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }
  

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 50, 15, 70),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.fromLTRB(18, 32.5, 18, 0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            gradient: LinearGradient(
              begin: const Alignment(0, -1),
              end: const Alignment(0, 1),
              colors: [
                Colors.blue[900] as Color,
                Colors.blue[600] as Color,
                Colors.blue[400] as Color,
                Colors.blue[400] as Color,
                Colors.blue[600] as Color,
                Colors.blue[900] as Color,
              ],
              stops: const [0, 0.201, 0.529, 0.665, 0.800,1],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32.5),
                constraints: const BoxConstraints(maxWidth: 296),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: Text(
                        'See how you much water you save every day!',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.2125,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Image.asset("assets/save-water.gif")
                  ],
                ),
              ),
            ],
          ),
        ),
      
              // Text(
              //   'Water Saving Tracker',
              //   softWrap: true,
              //   style: TextStyle(
              //     fontSize: 25,
              //     fontWeight: FontWeight.bold,
              //     height: 1.2125,
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/3,
                child: FutureBuilder<List<WaterData>>(
      future: fetchWaterDataFromFirestore(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while fetching data.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final WaterDataList = snapshot.data;
//           snapshot.data!.forEach((item) {
//   // Check if the item contains the "waterL" key
//   // Add the value of "waterL" to the total
//   gal += item.waterL;
// });
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                
                gridData: FlGridData(
                  show: true,
                
                 // drawVerticalGrid: false,
                  getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Color(0xff37434d),
                    strokeWidth: 1,
                  );
                  },
                ),
                titlesData: FlTitlesData(
                  
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val,title){
                        if(val == 0){return const Text("Mon");}
                        if(val == 1){return const Text("Tue");}
                        if(val == 2){return const Text("Wed");}
                        if(val == 3){return const Text("Thu");}
                        if(val == 4){return const Text("Fri");}
                        if(val == 5){return const Text("Sat");}
                        if(val == 6){return const Text("Sun");}
                        return const Text("");
                      }
                    )
                    
                  ),
                  topTitles: const AxisTitles(
                    axisNameSize: 26,
                    axisNameWidget: Text("This week water saved")
                  ),
                  leftTitles: const AxisTitles(
                  axisNameSize: 26,
                  axisNameWidget:Text("Water Gallons"),
                  
                  )
                ),
                
                
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                  bottom: BorderSide(color: Color(0xff37434d), width: 1),
                  left: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.transparent),
                  top: BorderSide(color: Colors.transparent),
                  ),
                ),
                // minX: 0,
                 minY: 2,
                // maxY: 6,
                // maxX: 6,
                lineBarsData: [
                  LineChartBarData(
                  spots: WaterDataList!
                      .asMap()
                      .entries
                      .map((entry) => FlSpot(entry.key.toDouble(), entry.value.waterL.toDouble()))
                      .toList(),
                  isCurved: false,
                  color: Colors.black,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text('No data available');
        }
      },
    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:  FirebaseFirestore.instance.collection("waterData").doc(userId).collection("water").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
          
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
          
                  num totalWaterL = 0;
          
                  if (snapshot.hasData) {
                    // Iterate through the snapshot data and sum up the "waterL" values
                    snapshot.data!.docs.forEach((doc) {
                      // Convert each document to a map and check if it contains "waterL" key
                      final data = doc.data();
                      if (data.containsKey("waterL")) {
          totalWaterL += data["waterL"];
                      }
                    });
                  }
          
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(
                          'You saved over \n$totalWaterL gallons of water \nthis week',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: totalWaterL/20,
                        center: Text("${((totalWaterL/20)*100).toInt()}%"),
                        progressColor: Theme.of(context).primaryColor,
                        addAutomaticKeepAlive: false,
                      ),
                        ]
                      ),
                    ),
                  );
                },
              ),
        )
        ],
    );
  }

  Widget dayLabel(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 35),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w100,
          height: 1.2125,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMoodChart() {
    List<FlSpot> spots = dailyMoodValues
        .asMap()
        .entries
        .map((entry) {
      int dayIndex = entry.key;
      int moodValue = entry.value;
      return FlSpot(dayIndex.toDouble(), moodValue.toDouble());
    })
        .toList();

    return SizedBox(
      width: 400,
      height: 186,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: dailyMoodValues.length.toDouble() - 1,
          minY: 0,
          maxY: 5,
          // Assuming mood values are from 1 to 5, adjust this as needed.
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.black,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              aboveBarData: BarAreaData(show: false),
              barWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class WaterData {
  int waterL; // 1 for 'Depressed', 2 for 'Sad', 3 for 'Neutral', 4 for 'Happy', 5 for 'Very Happy'
  DateTime date;
  bool isFuture;

  WaterData({
    required this.waterL,
    required this.date,
    required this.isFuture,
  });

  // Convert a map (Firestore document data) to a WaterData object.
  factory WaterData.fromJson(Map<String, dynamic> json) {
    return WaterData(
      waterL: json['waterL'] as int,
      date: (json['date'] as Timestamp).toDate(),
      isFuture: json['isFuture'] as bool,
    );
  }

  // Convert a WaterData object to a map (Firestore document data).
  Map<String, dynamic> toJson() {
    return {
      'waterL': waterL,
      'date': date,
      'isFuture': isFuture,
    };
  }
}