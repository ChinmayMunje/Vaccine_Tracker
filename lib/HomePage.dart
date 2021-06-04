import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vaccin_tracker/Services/AppServices.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AppServices service;
  List<Tracker> centerList = [];
  List allCenters;
  final dateController = TextEditingController();
  TextEditingController pinCode = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = AppServices();
    // this.pinCodeTracker(pinCode.text.toString(),dateController.text.toString());
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccine Tracker',
          style: GoogleFonts.robotoCondensed(fontSize: 25,fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      )
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: pinCode,
                          decoration: InputDecoration(
                            hintText: 'Pin Code',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                              hintText: 'Pick your Date'
                          ),
                          onTap: () async {
                            var date =  await showDatePicker(
                                context: context,
                                initialDate:DateTime.now(),
                                firstDate:DateTime(1900),
                                lastDate: DateTime(2100));
                            dateController.text = date.toString().substring(0,10);


                          },
                        ),
                      ),
                      RaisedButton(
                        color: Colors.green[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onPressed: (){
                          // if(centerList.isEmpty){
                          //   return Text('No Vaccine Available',
                          //     style: GoogleFonts.robotoCondensed(fontSize: 18,fontWeight: FontWeight.bold),
                          //   );
                          // }
                          centerList.clear();
                          String date = dateController.text.toString();
                          final f = new DateFormat('dd-MM-yyyy');
                          String formatDate = f.format(DateTime.parse(date));
                          pinCodeTracker(pinCode.text.toString(), formatDate);
                        },
                        child: Text('Search', style: TextStyle(
                          color: Colors.white,
                        ),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            centerList.isEmpty ? Text('No Vaccine Available',
              style: GoogleFonts.robotoCondensed(fontSize: 18,fontWeight: FontWeight.bold),
            ):
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: centerList.length,
                  itemBuilder: (context,index){
                    print('CENTER'+centerList[index].name);
                    return Flexible(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Center Name: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(centerList[index].name),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Address: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold), ),
                                  Text(centerList[index].address),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Pincode: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(centerList[index].pincode.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Date: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(centerList[index].date.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Vaccin: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(centerList[index].vaccine),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Availability: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(centerList[index].availableCapacity.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Time from: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(centerList[index].from.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Up to: ',style: GoogleFonts.robotoCondensed(fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(centerList[index].to.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      )
    );
  }

  Future pinCodeTracker(String pinCode,String date) async{
    var pinCodeInfo = await service.getPinCode(pinCode,date);
    setState(() {
      if(pinCodeInfo == null){
        return Text('NO Data Found');
      }
      if(pinCodeInfo != null){
        print("OIN CODE INDFR IS "+pinCodeInfo.toString());
        pinCodeInfo["sessions"].forEach((element){
          Tracker tracker = Tracker(
            name: element['name'],
            pincode: element['pincode'],
            address: element['address'],
            date: element['date'],
            vaccine: element['vaccine'],
            availableCapacity: element['available_capacity'],
            from: element['from'],
            to: element['to'],
          );
           centerList.add(tracker);
         });
      }
    });
    return allCenters;
  }
}

class Tracker {
  int centerId;
  String name;
  String address;
  String stateName;
  String districtName;
  String blockName;
  int pincode;
  String from;
  String to;
  int lat;
  int long;
  String feeType;
  String sessionId;
  String date;
  int availableCapacityDose1;
  int availableCapacityDose2;
  int availableCapacity;
  String fee;
  int minAgeLimit;
  String vaccine;
  List<String> slots;

  Tracker(
      {this.centerId,
        this.name,
        this.address,
        this.stateName,
        this.districtName,
        this.blockName,
        this.pincode,
        this.from,
        this.to,
        this.lat,
        this.long,
        this.feeType,
        this.sessionId,
        this.date,
        this.availableCapacityDose1,
        this.availableCapacityDose2,
        this.availableCapacity,
        this.fee,
        this.minAgeLimit,
        this.vaccine,
        this.slots});

  Tracker.fromJson(Map<String, dynamic> json) {
    centerId = json['center_id'];
    name = json['name'];
    address = json['address'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    blockName = json['block_name'];
    pincode = json['pincode'];
    from = json['from'];
    to = json['to'];
    lat = json['lat'];
    long = json['long'];
    feeType = json['fee_type'];
    sessionId = json['session_id'];
    date = json['date'];
    availableCapacityDose1 = json['available_capacity_dose1'];
    availableCapacityDose2 = json['available_capacity_dose2'];
    availableCapacity = json['available_capacity'];
    fee = json['fee'];
    minAgeLimit = json['min_age_limit'];
    vaccine = json['vaccine'];
    slots = json['slots'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['center_id'] = this.centerId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['block_name'] = this.blockName;
    data['pincode'] = this.pincode;
    data['from'] = this.from;
    data['to'] = this.to;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['fee_type'] = this.feeType;
    data['session_id'] = this.sessionId;
    data['date'] = this.date;
    data['available_capacity_dose1'] = this.availableCapacityDose1;
    data['available_capacity_dose2'] = this.availableCapacityDose2;
    data['available_capacity'] = this.availableCapacity;
    data['fee'] = this.fee;
    data['min_age_limit'] = this.minAgeLimit;
    data['vaccine'] = this.vaccine;
    data['slots'] = this.slots;
    return data;
  }
}

