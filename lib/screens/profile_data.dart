import 'package:flutter/material.dart';
import 'package:library_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileData extends StatefulWidget {
  @override
  _ProfileDataState createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  String arfz = 'XUxoS0gFlZgftr9lXq6j5kSwldv1';
  @override
  Widget build(BuildContext context) {
    //print(profiles);
    return StreamBuilder(
        stream:
            Firestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return Row(
                  textDirection: TextDirection.ltr,
                  children: <Widget>[
                    Expanded(child: Text(ds["name"])),
                    Expanded(child: Text(ds["field"])),
                    Expanded(child: Text(ds["email"])),
                    Expanded(child: Text(ds["class"])),
                  ],
                );
              },
            );
          }
        });
  }
}
