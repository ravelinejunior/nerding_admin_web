import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ApproveAdsScreen extends StatefulWidget {
  const ApproveAdsScreen({Key? key}) : super(key: key);

  @override
  _ApproveAdsScreenState createState() => _ApproveAdsScreenState();
}

class _ApproveAdsScreenState extends State<ApproveAdsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  String? userNumber;
  String? itemPrice;
  String? itemModel;
  String? itemColor;
  String? description;
  String? urlImage;
  String? itemLocation;
  QuerySnapshot? ads;
  CollectionReference itensRef = FirebaseFirestore.instance.collection('Items');

  @override
  void initState() {
    super.initState();
    itensRef.where('status', isEqualTo: 'not approved').get().then(
      (results) {
        ads = results;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
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
      ),
      body: Center(
        child: Container(
          width: _screenWidth * 0.5,
          child: _showAdsList(),
        ),
      ),
    );
  }

  Widget _showAdsList() {
    if (ads != null) {
      return Container();
    } else {
      return Center(
        child: Text('Loading...'),
      );
    }
  }
}
