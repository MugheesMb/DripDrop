
// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';

import 'autoComplet.dart';
class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final MapServices _mapServices = MapServices();
  List<AutoCompleteResult> _autocompleteResults = [];
    TextEditingController searchController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    bool hasCleanWater = false;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  
  void searchPlaces(String query) async {
    List<AutoCompleteResult> results = await _mapServices.searchPlaces(query);
    setState(() {
      _autocompleteResults = results;
    });
  }
  Widget buildListItem(AutoCompleteResult placeItem) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          //var place = await MapServices().getPlace(placeItem.placeId);
          // gotoSearchedPlace(place['geometry']['location']['lat'],
          //     place['geometry']['location']['lng']);
          // searchFlag.toggleSearch();
          locationController.text = placeItem.description.toString();
          _autocompleteResults = [];
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25.0),
            const SizedBox(width: 4.0),
            SizedBox(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }

  
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("Add Clean Water Location"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: locationController,
                          validator: (val){if(val!.isEmpty){return "Please enter a location";}},
                          decoration: const InputDecoration(labelText: 'Location'),
                          
                           onChanged: (value) {
            searchPlaces(value);
                  },
                        ),
                        _autocompleteResults.isNotEmpty
                            ? Container(
                              height: 200.0,
                              width: screenWidth - 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: ListView(
                                children: [
                                  ..._autocompleteResults
                                      .map((e) => buildListItem(e))
                                ],
                              ),
                            )
                            : Container(),
                        TextFormField(
                          controller: detailsController,
                          validator: (val){if(val!.isEmpty){return "Please enter details";}},
                          decoration: const InputDecoration(labelText: 'Details'),
                        ),
                        Row(
                          children: [
                            const Text('Clean Water:'),
                            Checkbox(
                              value: hasCleanWater,
                              onChanged: (bool? value) {
                                setState(() {
                                  hasCleanWater = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                        ElevatedButton(onPressed: (){
                          if(_formKey.currentState!.validate()){
                            Navigator.of(context).pop();
                          }
                          }, child: const Text("Add Water Details"))
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}