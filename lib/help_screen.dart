import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/global_controller.dart';
import 'screens/home_page.dart';
class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LocationForm()));
    });
  }
  Widget build(BuildContext context) {
    return  Scaffold(
        body:Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/new.png'),
                  fit:BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top:100,
              left: 40,
              child: Text('We show weather for you',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            ),
            //skip button
            Positioned(
              top: 150,
              right: 40,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LocationForm()));
                },
                child: Container(
                  height: 50,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade300,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                        )
                      ]
                  ),
                  child: Center(child: Text('skip',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),)),
                ),
              ),

            )

          ],
        )

    );

  }
}
