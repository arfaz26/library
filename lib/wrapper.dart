import 'package:flutter/material.dart';
import 'package:library_app/Authentication/login.dart';
import 'package:library_app/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:library_app/models/users.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user =Provider.of<User>(context);
    //print(user.uid);
    if(user==null){
      return LoginScreen();
    }
    else{
      return HomeScreen();
    }
  }
}