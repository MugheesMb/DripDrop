// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonateScreen extends StatelessWidget {
  DonateScreen({super.key});

  final userId = FirebaseAuth.instance.currentUser!.uid;


Future<void> donateBottleOfWater(BuildContext context, String userId) async {
  try {
    // Get reference to the user's points document
    final pointsDocRef = FirebaseFirestore.instance
        .collection("userPoints")
        .doc(userId)
        .collection("points");

    int oldValue = 0;
    // Get current value of points
    DocumentSnapshot<Map> pointsSnapshot = await pointsDocRef.doc("points").get();
        if (pointsSnapshot.exists && pointsSnapshot.data()!.containsKey('points')) {
      oldValue = pointsSnapshot.data()!['points'] as int;
    }
    // Check if user has enough points
    if (oldValue >= 1000) {
      // Deduct 1000 points
      int newValue = oldValue - 1000;

      pointsDocRef.doc("points").set({"points": newValue});

      // Show donation message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Your generosity makes a difference! Thank you for supporting our cause."'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/save-plants.gif"),
                const SizedBox(height: 20,),
                const Text("With your help, we'll be partnering with an organization to donate a bottle of water, reaching communities in need across Pakistan."),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show popup for insufficient points
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Points'),
            content: Text('You don\'t have enough points to donate a bottle of water.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    print('Error donating bottle of water: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child: 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height/4,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: const DecorationImage(image: AssetImage("assets/kids.jpeg"), fit: BoxFit.cover)
            ),
          ),
          Text("Donate water to the one who need it the most", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold ,color: Theme.of(context).primaryColor),),
          const Text("We envision our platform as a lifeline for drought-stricken villages in Sindh, Pakistan, where every donation contributes to providing essential water resources. Through our innovative approach of donating a bottle of water for every 1000 points earned on the app, we have the potential to make a meaningful impact on addressing water scarcity in these communities. Leveraging my expertise in app development and community engagement, I am confident that our platform can serve as a reliable source of water donation. By fostering partnerships with local NGOs, businesses, and government agencies, we can ensure the efficient distribution of water to those in need. With a commitment to sustainability and long-term solutions, our platform has the power to transform lives and bring hope to drought-affected areas in Sindh. Together, we can make a difference one drop at a time.", textAlign: TextAlign.justify,),
          Center(child: SizedBox(width: size.width/2,height: size.height*0.06,  child: ElevatedButton(onPressed: (){
            donateBottleOfWater(context,userId,);
          }, child: const Text("Donate Now"))))
        ],
      ),
    )
    );
  }
}