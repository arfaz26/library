import 'package:flutter/material.dart';
// import 'package:library_app/Authentication/login.dart';
import 'package:library_app/models/users.dart';
// import 'package:library_app/screens/books.dart';
// import 'package:library_app/screens/home.dart';
// import 'package:library_app/screens/notification.dart';
// import 'package:library_app/screens/profile.dart';
// import 'package:library_app/screens/transaction.dart';
import 'package:library_app/services/auth.dart';
import 'package:library_app/wrapper.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
          value: AuthService().user,
      
        child: MaterialApp(
          // initialRoute: '/',
          // routes: {
          //   '/home': (context) => HomeScreen(),
          //   '/profile': (context) => ProfileScreen(),
          //   '/books': (context) => BookScreen(),
          //   '/transaction': (context) => TransactionScreen(),
          //   '/notification': (context) => NotificationScreen(),
          //},
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        ),
      
    );
  }
}
