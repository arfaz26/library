import 'package:flutter/material.dart';

class NavigationModel{
  String title;

  NavigationModel({this.title});
}

List<NavigationModel> navigationItems=[
  NavigationModel(title: "Home"),
  NavigationModel(title: "Transaction"),
  NavigationModel(title: "Book"),
  NavigationModel(title: "Notification"),
  NavigationModel(title: "Profile"),
];