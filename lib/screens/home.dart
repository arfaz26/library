import 'package:flutter/material.dart';
import 'package:library_app/screens/boks.dart';
import 'package:library_app/screens/notification.dart';
import 'package:library_app/screens/profile.dart';
import 'package:library_app/screens/transaction.dart';
import 'package:library_app/services/auth.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:library_app/screens/books.dart';
import 'package:library_app/main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();
  final _formkey = GlobalKey<FormState>();
  String email = "";
  TextEditingController _controller = TextEditingController();

  AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Library'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Arfaz"),
              accountEmail: Text("chougulearfaz@gmail.com"),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Home"),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                }));
              },
            ),
            Divider(),
            ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Books"),
                ),
                onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.pushNamed(context, '/books');
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BookFind(
                      search: lastWords,
                    );
                  }));
                }),
            Divider(),
            ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Transaction"),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TransactionScreen();
                  }));
                }),
            Divider(),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Notification"),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NotificationScreen();
                }));
              },
            ),
            Divider(),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Profile"),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileScreen();
                }));
              },
            ),
            Divider(),
            FlatButton(
              //icon: Icon(Icons.cloud_off),
              child: Text(
                "Logout",
              ),
              onPressed: () {
                _auth.signOut();
              },
            )
          ],
        ),
      ),
      body: _hasSpeech
          ? Column(children: [
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          //initialValue: 'hello world',
                          controller: _controller,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          readOnly: false,
                          decoration: InputDecoration(
                            hintText: 'Search Book',
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.mic),
                              onTap: () {
                                startListening();
                                _controller.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                        child: Text("Search"),
                        onPressed: () {
                          if (_controller.text.length < 1) {
                            null;
                            // print(1);
                          } else {
                            // print(2);
                            try {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BookFind(
                                  search: _controller.text,
                                );
                              }));
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                        }),
                    Text(lastWords),
                    FlatButton(
                      child: Text("stop"),
                      onPressed: (){
                        stopListening();
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: speech.isListening
                      ? Text("I'm listening...")
                      : Text('Not listening'),
                ),
              ),
            ])
          : Center(
              child: Text('Speech recognition unavailable',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}"; // - ${result.finalResult}";
      _controller.text = lastWords;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
