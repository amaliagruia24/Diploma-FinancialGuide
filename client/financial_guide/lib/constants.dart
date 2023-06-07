import 'dart:ui';
import 'package:flutter/material.dart';
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16;

final List<String> categories = [
  'Clothing',
  'Education',
  'Electronics',
  'Health',
  'Home',
  'Leisure',
  'Restaurant',
  'Services',
  'Supermarket',
  'Transportation',
  'Travel',
  'Rent',
  'Invoices',
  'Other'
];

final List<IconData> categoryIcons = [
  Icons.local_mall,
  Icons.menu_book,
  Icons.devices_outlined,
  Icons.healing,
  Icons.home,
  Icons.beach_access,
  Icons.local_restaurant,
  Icons.imagesearch_roller_rounded,
  Icons.local_grocery_store,
  Icons.directions_car,
  Icons.airplane_ticket,
  Icons.real_estate_agent,
  Icons.receipt,
  Icons.playlist_add
];

final List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'];