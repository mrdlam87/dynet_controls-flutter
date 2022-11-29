import 'package:flutter/material.dart';

const kPresetButtonStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.white,
);

const kCardTitleStyle = TextStyle(
  fontSize: 22.0,
  // fontWeight: FontWeight.w100,
  color: Colors.white,
);

const kCategoryStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.white30,
);

const kCardSmallTitleStyle = TextStyle(
  fontSize: 15.0,
  // fontWeight: FontWeight.w100,
  color: Colors.white,
);

const kChannelTextStyle = TextStyle(
  color: Colors.white,
);

const kFolderNameTextStyle = TextStyle(
  color: Color.fromARGB(255, 104, 255, 255),
  fontSize: 27,
);

const kSearchBarDecoration = InputDecoration(
  fillColor: kCardColour,
  filled: true,
  hintStyle: TextStyle(color: kInactiveColour),
  prefixIcon: Icon(Icons.search, color: kInactiveColour),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
);

const kTextfieldDecoration = InputDecoration(
  fillColor: kCardColour,
  filled: true,
  hintStyle: TextStyle(color: kInactiveColour),
  labelStyle: TextStyle(color: kInactiveColour, fontSize: 15),
  floatingLabelStyle: TextStyle(color: kItemColour),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);

const kDropDownfieldDecoration = InputDecoration(
  fillColor: kCardColour,
  filled: true,
  hintStyle: TextStyle(color: kInactiveColour),
  labelStyle: TextStyle(color: kInactiveColour),
  floatingLabelStyle: TextStyle(color: kItemColour, fontSize: 15),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColour, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);
const kItemColour = Color.fromARGB(255, 104, 255, 255);

const kBackgroundColour = Color.fromARGB(255, 35, 35, 60);

const kOldBackgroundColour = Color(0xFF2A2B37);

const kMenuColour = Color.fromARGB(255, 50, 50, 77);

const kActiveButtonColour = Color(0xFF0DAAAA);

const kActiveColour = Colors.white;

const kInactiveColour = Colors.white30;

const kButtonRowPadding = 5.0;

const kNavigationBarColour = Color(0xE0000000);

const kCardColour = Color(0xff1f1f34);

const kShadowColour = Color.fromARGB(255, 119, 240, 208);

const kFadeDuration = Duration(milliseconds: 1000);
