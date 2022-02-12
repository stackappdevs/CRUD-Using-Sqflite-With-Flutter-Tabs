

import 'package:demoapp/pages/login/login_page.dart';
import 'package:demoapp/pages/sign_up/sign_up_page.dart';
import 'package:demoapp/pages/user_list/user_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Builder(builder: (BuildContext context){

          final TabController tabController = DefaultTabController.of(context)!;

          tabController.addListener(() {
            if(!tabController.indexIsChanging){
              setState(() {
              });
            }
          });
          return  Scaffold(
            appBar: AppBar(
              title: Text('User Integration',style: TextStyle(color: Colors.blue.shade100),),
              backgroundColor: Colors.blue.shade700,
              bottom: TabBar(
                controller: tabController,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: Icon(Icons.verified_user_rounded,),),
                  Tab(icon: Icon(Icons.person),),
                  Tab(icon: Icon(Icons.group),),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Login(),
                Registration(),
                UserList(),
              ],
              controller: tabController,
            ),
          );
        })
    );
  }
}
