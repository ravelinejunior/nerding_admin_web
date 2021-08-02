import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nerding_admin_web/screen/home_screen/home_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ApproveAdsScreen extends StatefulWidget {
  const ApproveAdsScreen({Key? key}) : super(key: key);

  @override
  _ApproveAdsScreenState createState() => _ApproveAdsScreenState();
}

class _ApproveAdsScreenState extends State<ApproveAdsScreen> {
  QuerySnapshot? ads;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference itensRef =
      FirebaseFirestore.instance.collection('Items');

  String? userName;
  String? userNumber;
  String? itemPrice;
  String? itemModel;
  String? itemColor;
  String? description;
  String? urlImage;
  String? itemLocation;

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
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ApproveAdsScreen(),
                  ),
                );
              },
              icon: Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
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

  Future<dynamic> showDialogForApprovingAds(selectedDoc) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_context) {
        return AlertDialog(
          title: Text(
            'Aprovar Item',
            style: TextStyle(color: Colors.black54),
          ),
          titleTextStyle: TextStyle(
            fontSize: 24,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Deseja aprovar este item?',
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                Map<String, dynamic> adsData = {'status': 'approved'};
                itensRef.doc(selectedDoc).update(adsData).then(
                  (value) {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: "Aprovado com sucesso!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      webShowClose: true,
                      webPosition: 'center',
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    ).then(
                      (value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ApproveAdsScreen(),
                        ));
                      },
                    );
                  },
                );
              },
              child: Text(
                'Aprovar',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _showAdsList() {
    if (ads!.docs.isNotEmpty) {
      return ListView.builder(
        itemCount: ads!.docs.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) => Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              //ListTile
              Padding(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          ads!.docs[index].get('imagePro'),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Expanded(
                    child: Text(
                      ads!.docs[index].get('userName'),
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      showDialogForApprovingAds(ads!.docs[index].id);
                    },
                    splashColor: Colors.amber,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fact_check_rounded),
                        const SizedBox(width: 20),
                        Text(
                          'Aprovar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //Add Image
              InkWell(
                onDoubleTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.network(
                    ads!.docs[index].get('urlImage')[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'R\$ ${ads!.docs[index].get('itemPrice')}',
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //Model and Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //itemModel
                    Row(
                      children: [
                        Icon(Icons.image_sharp),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Align(
                            child: Text(
                              ads!.docs[index].get('itemModel'),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                      ],
                    ),

                    //TimeAgo
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Align(
                            child: Text(
                              timeago.format(
                                (ads!.docs[index].get('time')).toDate(),
                                locale: 'pt',
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    } else if (ads!.docs.isEmpty) {
      return Center(
        child: Text('Não existem itens pendentes para aprovação.'),
      );
    } else {
      return Center(
        child: Text('Loading...'),
      );
    }
  }
}
