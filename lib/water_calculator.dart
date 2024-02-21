import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'water_tracker.dart';

class WaterCalculatorScreen extends StatefulWidget {
  const WaterCalculatorScreen({Key? key});

  @override
  WaterCalculatorScreenState createState() => WaterCalculatorScreenState();
}

class WaterCalculatorScreenState extends State<WaterCalculatorScreen> {
  int brushingTime = 2; // Default value for brushing time
  int showerTime = 15; // Default value for shower time
  int dishwashingTime = 10; // Default value for dishwashing time
  int gardeningFrequency = 3; // Default value for gardening frequency
  bool rainwaterReuse = false; // Default value for rainwater reuse
  bool gardenWatering = false; // Default value for garden watering
  bool leakFixed = false; // Default value for leak fixing
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Calculator'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildQuestion(
                'How many minutes do you take for brushing your teeth?',
                brushingTime,
                (value) {
                  setState(() {
                    brushingTime = value!;
                  });
                },
                List.generate(
                  6,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1} minutes'),
                  ),
                ),
              ),
              buildQuestion(
                'How many minutes do you take for showering?',
                showerTime,
                (value) {
                  setState(() {
                    showerTime = value!;
                  });
                },
                List.generate(
                  11,
                  (index) => DropdownMenuItem<int>(
                    value: index + 10,
                    child: Text('${index + 10} minutes'),
                  ),
                ),
              ),
              buildQuestion(
                'How many minutes do you take for dishwashing?',
                dishwashingTime,
                (value) {
                  setState(() {
                    dishwashingTime = value!;
                  });
                },
                List.generate(
                  16,
                  (index) => DropdownMenuItem<int>(
                    value: index + 5,
                    child: Text('${index + 5} minutes'),
                  ),
                ),
              ),
              buildQuestionBool(
                'Have you reused rainwater?',
                rainwaterReuse,
                (value) {
                  setState(() {
                    rainwaterReuse = value!;
                  });
                },
              ),
              buildQuestionBool(
                'Do you water your garden?',
                gardenWatering,
                (value) {
                  setState(() {
                    gardenWatering = value!;
                  });
                },
              ),
              buildQuestionBool(
                'Have you fixed a leak?',
                leakFixed,
                (value) {
                  setState(() {
                    leakFixed = value!;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  calculateWaterConsumption();
                },
                child: const Text('Complete'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestion(String question, int value, Function(int?) onChanged, List<DropdownMenuItem<int>> items) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15)
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width/2,
                child: Text(
                  question,
                  style: const TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownButton<int>(
                value: value,
                onChanged: onChanged,
                items: items,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestionBool(String question, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15)
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                children: [
                  Text('Yes'),
                  Radio<bool>(
                    value: true,
                    groupValue: value,
                    onChanged: onChanged,
                  ),
                  Text('No'),
                  Radio<bool>(
                    value: false,
                    groupValue: value,
                    onChanged: onChanged,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> addPointsToUser(String userId) async {
  try {
    // Get reference to the user's points document
    DocumentReference pointsDocRef = FirebaseFirestore.instance
        .collection("userPoints")
        .doc(userId)
        .collection("points")
        .doc("points");

    // Get current value of points
    int oldValue = 0;
    DocumentSnapshot pointsSnapshot = await pointsDocRef.get().then((value){
      print(value['points']);
      oldValue = value['points'];
      return value;}) ;

    int newValue = oldValue + 50;

    // Update points in Firestore
    await pointsDocRef.update({"points": newValue});
  } catch (e) {
    print('Error adding points to user: $e');
  }
}
Future<void> saveMoodData(WaterData water) async {
    await FirebaseFirestore.instance.collection('waterData').doc(userId).collection("water").add(water.toJson());
}

  void calculateWaterConsumption() async{
    // Calculate water consumption for each activity
    int brushingWaterConsumption = brushingTime * 2; // 2 gallons per minute
    int showerWaterConsumption = showerTime * 2; // 2 gallons per minute
    int dishwashingWaterConsumption = dishwashingTime * 3; // 3 gallons per minute
    int gardeningWaterConsumption = gardeningFrequency * 5; // 5 gallons per watering session

    // Calculate additional water consumption based on user's actions
    int additionalWaterConsumption = 0;
    if (rainwaterReuse) {
      additionalWaterConsumption += 10; // Assuming 10 gallons saved by rainwater reuse
    }
    if (gardenWatering) {
      additionalWaterConsumption += 5 * gardeningFrequency; // Assuming 5 gallons per watering session
    }
    if (leakFixed) {
      additionalWaterConsumption -= 20; // Assuming 20 gallons saved by fixing a leak
    }

    // Total water consumption
    int totalWaterConsumption = 3;

    // Average water consumption by people (for comparison)
    int averageWaterConsumption = 8 * 30 * 2; // 8 gallons per day for 30 days, multiplied by 2 (for each activity)

    // CO2 emission calculation (assuming 1 gallon of water equals 0.072 kg CO2 emission)
    double co2Emission = totalWaterConsumption * 0.072;
    await FirebaseFirestore.instance.collection("dailyAcitiviy").doc(userId).collection("data").add({
      "date":DateTime.now(),
      "waterReuse":rainwaterReuse,
      "fixLead":leakFixed,
      "rainWater":rainwaterReuse,
      "garden":gardenWatering,
      "co2Emission":co2Emission,
      "waterConsume":3,
    });
    addPointsToUser(userId);
    WaterData water = WaterData(waterL: 3, date: DateTime.now(), isFuture: false);
    saveMoodData(water);
    // Show results
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Water Consumption Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your total water consumption is: $totalWaterConsumption gallons.'),
              const SizedBox(height: 10.0),
              if (totalWaterConsumption > averageWaterConsumption)
                const Text('Your water consumption is above average.'),
              const SizedBox(height: 10.0),
              Text('CO2 emissions based on your water consumption: ${co2Emission.toStringAsFixed(2)} kg.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
