import 'package:demoapp/pages/home/home_page.dart';
import 'package:flutter/material.dart';

void main()async{
    WidgetsFlutterBinding.ensureInitialized();


    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'app'
        ),
        routes: {
            '/' : (context) => HomePage(),
        },
    ));
}

