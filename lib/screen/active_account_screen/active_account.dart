import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nerding_admin_web/screen/home_screen/home_screen.dart';

class ActiveAccountScreen extends StatefulWidget {
  const ActiveAccountScreen({Key? key}) : super(key: key);

  @override
  _ActiveAccountScreenState createState() => _ActiveAccountScreenState();
}

class _ActiveAccountScreenState extends State<ActiveAccountScreen> {
  QuerySnapshot? usersSnapshot;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('Users');

//setar o valor do userSnapshot
  @override
  void initState() {
    super.initState();
    usersRef.where('status', isEqualTo: 'approved').get().then(
      (usersFound) {
        setState(() {
          usersSnapshot = usersFound;
        });
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
                    builder: (context) => ActiveAccountScreen(),
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
        title: const Text('Contas Ativas'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: _screenWidth * 0.5,
          child: _showBlockedAccounts(),
        ),
      ),
    );
  }

  _showBlockedAccounts() {
    if (usersSnapshot != null && usersSnapshot!.docs.length > 0) {
      return ListView.builder(
        itemCount: usersSnapshot!.docs.length,
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
                          usersSnapshot!.docs[index].get('imagePro'),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Expanded(
                    child: Text(
                      usersSnapshot!.docs[index].get('userName'),
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () {},
                    splashColor: Colors.red,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone_android),
                        const SizedBox(width: 20),
                        Text(
                          usersSnapshot!.docs[index].get('userNumber'),
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialogForActivatingAccount(
                        usersSnapshot!.docs[index].id);
                  },
                  icon: Icon(
                    Icons.person_pin_sharp,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Bloquear essa conta'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Varela',
                      letterSpacing: 1.5,
                    ),
                  ),
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[700]!),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    } else if (usersSnapshot == null || usersSnapshot!.size == 0) {
      return Center(
        child: Text('Nenhum usuário ativo!'),
      );
    } else {
      return Center(
        child: Text('Loading...'),
      );
    }
  }

  Future<dynamic> showDialogForActivatingAccount(selectedDoc) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_context) {
        return AlertDialog(
          title: Text(
            'Bloquear conta',
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
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
                'Deseja bloquear esta conta?',
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green[700]!),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                Map<String, dynamic> userData = {
                  'status': 'not approved',
                };
                usersRef.doc(selectedDoc).update(userData).then(
                  (value) {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: "Conta bloqueada com sucesso".toUpperCase(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      webShowClose: true,
                      webPosition: 'center',
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    ).then(
                      (value) => {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ActiveAccountScreen(),
                          ),
                        ),
                      },
                    );
                  },
                );
              },
              child: Text(
                'Bloquear',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
