import 'package:bluetooth/tela-principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class TelaLoguin extends StatefulWidget{
  @override
  _TelaLoguinState createState() => _TelaLoguinState();
}

class _TelaLoguinState extends State<TelaLoguin> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FlutterBluetoothSerial.instance.requestEnable(),
      builder: (context, future) {
        if (future.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: SizedBox(
              height: double.infinity,
              child: Center(
                child: Icon(
                  Icons.bluetooth_disabled,
                  size: 200.0,
                  color: Colors.black12,
                ),
              ),
            ),
          );
        } else {
          return TelaPrincipal();
        }
      },
    );
  }
}

/*
Codigo arduino

#include <SoftwareSerial.h>

SoftwareSerial BTSerial(10, 11); // RX | TX

void setup() {
  Serial.begin(9600);
  BTSerial.begin(9600);
}

void loop() {
  if (BTSerial.available()) {
    char receivedChar = BTSerial.read();
    Serial.print(receivedChar);
  }
}

 */