import 'package:flutter/material.dart';
import 'signin.dart';

void main(){
  runApp(Dummy());
}


class Dummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute:'/signin',
      routes: {
        '/signin': (context)=>Signin(),

      },
    );
  }
}
