import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    dynamic userDetail = ModalRoute.of(context)!.settings.arguments;

    print(userDetail.user.email);
    return Scaffold(
       appBar: AppBar(
         title: Text('Dashboard'),
         backgroundColor: Colors.blue.shade700,
         actions: [
           IconButton(
               icon: Icon(Icons.power_settings_new_outlined),
               onPressed: (){
                    // FirebaseHelper.instance.logOut();
                    print('user sign out');
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
               }
           )
         ],
       ),
       body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade200
                ),
                padding: EdgeInsets.all(width*0.05),
                margin: EdgeInsets.all(width*0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Welcome ${userDetail.user.email.toString().split('@')[0]}\n',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                    getRow('Email : ', '${userDetail.user.email}'),
                    getRow('Create date : ', '${userDetail.user.metadata.creationTime.toString().split(' ')[0]}'),
                    getRow('last seen : ', '${userDetail.user.metadata.lastSignInTime.toString().split(' '[0])}'),
                    getRow('User Id  : ', '${userDetail.user.uid}'),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

Widget getRow(String name,String value){
    return Row(
        children: [
            Text(name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            Expanded(child: Text(value)),
        ],
    );
}
