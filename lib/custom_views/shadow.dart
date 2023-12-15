import 'package:flutter/material.dart';

List<BoxShadow> cardShadow() {
  return [
    BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: 2,
      blurRadius: 4,
      offset: const Offset(0, 1), // changes position of shadow
    )
  ];
}
