// import 'package:demoapp/screen/data_model.dart';
// import 'package:demoapp/screen/login.dart';
// import 'package:demoapp/screen/registration.dart';
// import 'package:demoapp/screen/userlist.dart';
// import 'package:flutter/material.dart';
//
// void main(){
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//         fontFamily: 'app'
//     ),
//     home: HomePage(),
//   ));
// }
//
//
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
//
//
//   @override
//   void initState() {
//
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         initialIndex: 1,
//         length: 3,
//         child: StreamBuilder(
//             stream: stream,
//             builder: (context,snapshot){
//               final TabController tabController = DefaultTabController.of(context)!;
//
//               if(snapshot.hasData){
//                 return  Scaffold(
//                   appBar: AppBar(
//                     title: Text('User Integration',style: TextStyle(color: Colors.blue.shade100),),
//                     brightness: Brightness.dark,
//                     backgroundColor: Colors.blue.shade700,
//                     actions: [
//                       (length > 0) ?
//                       CircleAvatar(
//                         backgroundColor: Colors.blue.shade300,
//                         child: Text('${snapshot.data}',style: TextStyle(fontWeight: FontWeight.bold),),
//                       ) : Container(),
//                       SizedBox(width: 15,)
//                     ],
//                     bottom: TabBar(
//                       controller: tabController,
//                       indicatorColor: Colors.white,
//                       tabs: [
//                         Tab(icon: Icon(Icons.verified_user_rounded,),),
//                         Tab(icon: Icon(Icons.person),),
//                         Tab(icon: Icon(Icons.group),),
//                       ],
//                     ),
//                   ),
//                   body: TabBarView(
//                     children: [
//                       Login(),
//                       Registration(),
//                       UserList(),
//                     ],
//                     controller: tabController,
//                   ),
//                 );
//               }
//               return Text('1');
//             }
//         )
//     );
//   }
// }
