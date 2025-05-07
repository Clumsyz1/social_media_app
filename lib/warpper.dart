import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/homepage.dart';
import 'package:social_media_app/login.dart';
import 'package:social_media_app/vertifyemail.dart';

/// Warpper เป็น widget ที่คอยตรวจสอบสถานะของผู้ใช้
/// ว่า login แล้วหรือยัง และ email ได้รับการยืนยันแล้วหรือไม่
class Warpper extends StatefulWidget {
  const Warpper({super.key});

  @override
  State<Warpper> createState() => _WarpperState();
}

class _WarpperState extends State<Warpper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);

            if (snapshot.data!.emailVerified) {
              return Homepage();
            } else {
              return Vertify();
            }
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
