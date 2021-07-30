import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nerding_admin_web/screen/approved_ads_screen/approved_ads.dart';

import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String timeString = "";
  String dateString = "";
  CollectionReference itensRef = FirebaseFirestore.instance.collection('Items');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange,
                  Colors.green,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            'Admin Home Page',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '$timeString\n\n$dateString',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ApproveAdsScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.check_box,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Aprovar Novos Itens'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(48)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.deepOrange),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.person_pin_sharp, color: Colors.white),
                    label: Text(
                      'Contas'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(48)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.block_flipped,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Contas Bloqueadas'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(48)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.person_pin_sharp, color: Colors.white),
                    label: Text(
                      'Logout'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(48)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepOrange),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd MMMM, yyyy').format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss a').format(dateTime);
  }

  getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = formatTime(now);
    final String formattedDate = formatDate(now);

    if (this.mounted) {
      setState(() {
        timeString = formattedTime;
        dateString = formattedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    itensRef.where('status', isEqualTo: 'not approved').get().then(
      (results) {
        ads = results;
      },
    );

    dateString = formatDate(DateTime.now());
    timeString = formatTime(DateTime.now());

    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => getTime(),
    );
  }
}
