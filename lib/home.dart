import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_water/water_calculator.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color dark = Colors.green;
  final Color normal = Colors.orange;
  final Color light = Colors.red;
    var userId = FirebaseAuth.instance.currentUser!.uid;
  double emission = 0;
  bool planted = false;
  bool recycled = false;
  bool shopped = false;
  bool energy = false;
  int num = 0;
  void getEmissionLevel(BuildContext context) async {
    //double emission = 0;
    var collection = FirebaseFirestore.instance.collection('EmissionLevel');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value1 = data?["Emission"];
      var value2 = data?["planted"];
      var value3 = data?["recycled"];
      var value4 = data?["shopped"];
      var value5 = data?["energy"];
      print(value1);
      setState(() {
        emission = value1 / 2000;
        planted = value2;
        recycled = value3;
        shopped = value4;
        energy = value5;
      });
    }
  }

  bool value = false;

  // Widget _buildListItem(Plant plant) {
  //   int growth = 0;
  //   if (plant.status == "seed") {
  //     growth = 25;
  //   }
  //   if (plant.status == "sprouted") {
  //     growth = 50;
  //   }
  //   if (plant.status == "small plant") {
  //     growth = 75;
  //   }
  //   if (plant.status == "adult plant") {
  //     growth = 100;
  //   }
  //   return Column(
  //     children: [
  //       InkWell(
  //         onTap: () {
  //           // Navigator.of(context).push(MaterialPageRoute(
  //           //   builder: (BuildContext context) =>
  //           //       PlantDetailScreen(plantId: plant.plantId),
  //           // ));
  //         },
  //         child: Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Container(
  //                             height: 50,
  //                             width: 50,
  //                             decoration: BoxDecoration(
  //                                 color: const Color.fromARGB(255, 185, 244, 117),
  //                                 border:
  //                                     Border.all(width: 5, color: Colors.green),
  //                                 borderRadius: BorderRadius.circular(15)),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(3.0),
  //                               child:
  //                                   SvgPicture.asset("assets/plant_icon.svg"),
  //                             )),
  //                       ),
  //                       Text(
  //                         plant.name,
  //                         style: const TextStyle(
  //                             fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "$growth%",
  //                       style: const TextStyle(fontSize: 16),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               proBar(growth / 100, false),
  //               const SizedBox(
  //                 height: 10,
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 10,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildList(QuerySnapshot<Object?>? snapshot) {
  //   if (snapshot!.docs.isEmpty) {
  //     return const Center(child: Text("No Plants in the garden Yet!"));
  //   } else {
  //     return ListView.builder(
  //       itemCount: snapshot.docs.length,
  //       itemBuilder: (context, index) {
  //         final doc = snapshot.docs[index];
  //         final task = Plant.fromSnapshot(doc);
  //         return _buildListItem(task);
  //       },
  //     );
  //   }
  // }

  Widget bottomTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Your Emissions';
        break;
      case 1:
        text = 'Global Emissions';
        break;
      case 2:
        text = 'PAK Emissions';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

  bool leakFixed = false;
  bool gardenWatering = false;
  bool rainwaterReuse = false;
  bool waterReuse = false;
  bool isCompleted = false;

  
Future<Map<String, dynamic>> fetchDailyActivity(String userId) async {
  Map<String, dynamic> activityData = {};
  
  try {
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime endOfToday = startOfToday.add(const Duration(days: 1));
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("dailyAcitiviy")
        .doc(userId)
        .collection("data")
        .where("date", isGreaterThanOrEqualTo: startOfToday)
        .where("date", isLessThan: endOfToday)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      activityData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      setState(() {
    leakFixed = activityData['fixLead'];
  gardenWatering = activityData['garden'] ?? false;
  rainwaterReuse = activityData['rainWater'] ?? false;
  waterReuse = activityData['waterReuse'] ?? false;
  });
    }
  } catch (e) {
    print('Error fetching daily activity: $e');
  }

  return activityData;
}

Future<bool> isDocForTodayPresent(String userId) async {
  try {
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime endOfToday = startOfToday.add(const Duration(days: 1));

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("dailyAcitiviy")
        .doc(userId)
        .collection("data")
        .where("date", isGreaterThanOrEqualTo: startOfToday)
        .where("date", isLessThan: endOfToday)
        .get();
        setState(() {
          isCompleted = querySnapshot.docs.isNotEmpty;
        });
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking if document for today is present: $e');
    return false;
  }
}
    
  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        "${meta.formattedValue} Ton",
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    if (num == 0) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => getEmissionLevel(context));
          fetchDailyActivity(userId);
          isDocForTodayPresent(userId);
      num++;
    }
    final name = FirebaseAuth.instance.currentUser!.displayName;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Hello",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18)),
                      Text(" $name!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).primaryColor)),
                      // SizedBox(
                      //   height: 80,
                      //   width: 80,
                      //   child: Image.asset("assets/cli-matee.png"),
                      // )
                    ],
                  ),
                  IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(
                        Icons.menu_rounded,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              heading("Carbon Emissions"),
              AspectRatio(
                aspectRatio: 1.26,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final barsSpace = 60.0 * constraints.maxWidth / 400;
                      final barsWidth = 41.0 * constraints.maxWidth / 400;
                      return BarChart(
                        swapAnimationDuration:
                            const Duration(milliseconds: 150), // Optional
                        swapAnimationCurve: Curves.linear,
                        BarChartData(
                            alignment: BarChartAlignment.center,
                            barTouchData: BarTouchData(
                              enabled: true,
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitles,
                                  reservedSize: 28,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                  getTitlesWidget: leftTitles,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                                show: true,
                                //checkToShowHorizontalLine: (value) =>
                                //value % 10 == 0,
                                getDrawingHorizontalLine: (value) => const FlLine(
                                      //color: AppColors.borderColor.withOpacity(0.1),
                                      strokeWidth: 1,
                                    ),
                                drawVerticalLine: true,
                                drawHorizontalLine: true),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            groupsSpace: barsSpace,
                            barGroups: getData(barsWidth, barsSpace)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              heading("Daily Acitivties"),
              const SizedBox(
                height: 5,
              ),
              Container(
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 3,
        blurRadius: 5,
        offset: const Offset(0, 0), // changes position of shadow
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Save 20 Gallons of water today"),
            Checkbox(
              value: leakFixed, // Set value based on leakFixed variable
              onChanged: (bool? newValue) {
                // setState(() {
                //   leakFixed = newValue ?? false; // Update leakFixed variable
                // });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Fix a Leak"),
            Checkbox(
              value: gardenWatering, // Set value based on gardenWatering variable
              onChanged: (bool? newValue) {
                // setState(() {
                //   gardenWatering = newValue ?? false; // Update gardenWatering variable
                // });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Capture Rain Water"),
            Checkbox(
              value: rainwaterReuse, // Set value based on rainwaterReuse variable
              onChanged: (bool? newValue) {
                // setState(() {
                //   rainwaterReuse = newValue ?? false; // Update rainwaterReuse variable
                // });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Reuse Water"),
            Checkbox(
              value: rainwaterReuse, // Set value based on rainwaterReuse variable
              onChanged: (bool? newValue) {
                // setState(() {
                //   rainwaterReuse = newValue ?? false; // Update rainwaterReuse variable
                // });
              },
            )
          ],
        ),
      ],
    ),
  ),
),
const SizedBox(height: 20),
              isCompleted? const SizedBox() :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text("Complete Daily Activities \nto earn points"),
                      ElevatedButton(onPressed: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WaterCalculatorScreen()));
                                      }, child: const Text("Daily Activity") )
              ],),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    const Text("Your Credit:"),
                    StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("userPoints")
          .doc(userId)
          .collection("points")
          .doc("points")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int points = snapshot.data?['points'] ?? 0;
          return Text(points.toString(), style: TextStyle(fontSize: 55, color: Theme.of(context).primaryColor),);
        }
      },
    )
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(children: [
                  const Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: SizedBox(
                                width: 300,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 0, left: 5, bottom: 5),
                                  child: Text(
                                    "We do not inherit the Earth from our ancestors, we borrow it from our children",
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    left: 130,
                    top: 30,
                    bottom: 0,
                    child: SizedBox(
                        height: 300,
                        width: 300,
                        child: SvgPicture.asset("assets/tree_svg.svg")),
                  ),
                  Positioned(
                      top: 20,
                      left: 05,
                      child: SizedBox(
                          height: 100,
                          width: 100,
                          child: SvgPicture.asset("assets/quotes.svg",color: Theme.of(context).primaryColor,))),
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              // heading("Plants Growth Tracker"),
              // StreamBuilder<QuerySnapshot>(
              //     stream: FirebaseFirestore.instance
              //         .collection("User Plants")
              //         .doc("$userId Plants")
              //         .collection("Plants")
              //         .snapshots(),
              //     builder: ((context, snapshot) {
              //       if (!snapshot.hasData) return const LinearProgressIndicator();
              //       print(snapshot.data);
              //       return SizedBox(
              //           height: MediaQuery.of(context).size.height / 2.3,
              //           child: _buildList(snapshot.data));
              //     })),
              const SizedBox(
                height: 20,
              ),
              heading("Awareness Guide"),
              CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                ),
                items: [
                  "assets/aware 1.png",
                  "assets/aware 2.png",
                  "assets/aware 3.png",
                  "assets/aware 4.png",
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(i),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text heading(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 0,
        barRods: [
          BarChartRodData(
            backDrawRodData: BackgroundBarChartRodData(
                color: Theme.of(context).primaryColor, toY: 20, fromY: 50),
            toY: emission,
            color: Theme.of(context).primaryColor,
            // rodStackItems: [
            //   BarChartRodStackItem(
            //     0,
            //     30,
            //     widget.dark,
            //   ),
            //   BarChartRodStackItem(0, emission / 2, Colors.blue),
            //   BarChartRodStackItem(emission / 2, emission / 3, Colors.yellow),
            // ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 50.5,
        barRods: [
          BarChartRodData(
              toY: 4.8,
              color: Colors.grey,
              // rodStackItems: [
              //   BarChartRodStackItem(0, 4.8 / 2, widget.normal),
              //   BarChartRodStackItem(130, 140, widget.normal),
              //   BarChartRodStackItem(140, 7000, widget.normal),
              // ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              width: barsWidth),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 0,
        barRods: [
          BarChartRodData(
              toY: 1.2,
              color: Colors.blueGrey,
              // rodStackItems: [
              //   BarChartRodStackItem(0, 60.5, widget.light),
              //   BarChartRodStackItem(60.5, 180, widget.light),
              //   BarChartRodStackItem(180, 5000, widget.light),
              // ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              width: barsWidth),
        ],
      ),
    ];
  }
}