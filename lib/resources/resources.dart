import 'package:flutter/material.dart';

/* APP_NAME */
const String appName = "Run Wheelz";

/* APP_URL */

const String APP_URL = "http://10.0.2.2:8081";
//const String APP_URL = "https://192.168.10.207:8081";
/* MENU_ITEMS*/
const List<String> menuItems = ["Home", "Vendor Staff", "Vendor Services", "New Requests", "Requests History"];


/* PAGE_TITLES */
const Map<String, String> pageTitles = {
    "Services": "Services",
    "Pending": "Pending Services"
};

/* APP_STYLES */

const double headerSize = 60;
const String fontStyle = "Rubik";
const Color appBarColor = Colors.purple;
Color bgColor = Color(0xff623791);
const int optExpiration = 60;