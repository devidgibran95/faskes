import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//COLORS
var ancent = const Color(0xFF18A5FD);
var ancentlight = const Color(0xFF66ACE9);
var heading = const Color(0xFF0F1641);
var text = const Color(0xFFAAAAAA);
var icon = const Color(0xFF888CCB);
var background = const Color(0xFFF8FAFB);
var white = const Color(0xFFFFFFFF);
var black = const Color(0xFF000000);

//TEXTSTYLE
TextStyle welcome = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 30);
TextStyle heading1 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 20);
TextStyle heading2 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 18);
TextStyle heading3 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 16);
TextStyle heading4 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600, color: heading, fontSize: 14);

TextStyle pBold = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w700, color: white);

TextStyle link =
    GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: icon);
TextStyle rating = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w400, color: white);
TextStyle p1 =
    GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: text);
TextStyle p2 =
    GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: text);
TextStyle p3 =
    GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400, color: text);

TextStyle pLocation = GoogleFonts.poppins(
    fontSize: 10, fontWeight: FontWeight.w400, color: white);

//GAP
var medium = 30.0;
var small = 16.0;
var xsmall = 10.0;
