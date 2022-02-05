
import 'package:demoapp/screen/data_model.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../helper.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  late Future getAllData;


  @override
  void initState() {
    getAllData = DBHelper.instance.selectData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
        body: Container(
          height: height,
          width: width,
          margin: EdgeInsets.all(height*0.02),
          padding: EdgeInsets.all(height*0.025).copyWith(right: 0),
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
            borderRadius: BorderRadius.circular(height*0.02),
          ),
          child: FutureBuilder(
              future: getAllData ,
              builder: (context,snapshot){
                  if(snapshot.hasError){
                        return Center(child: Text("error =  ${snapshot.error}"),);
                  }
                  if(snapshot.hasData){

                    dynamic data = snapshot.data;

                    return ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (context,i){
                        return SizedBox(height: height*0.035,);
                      },
                      itemBuilder: (context,i){
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(height*0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(height*0.02),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getRow('Name :', data[i].name),
                                    getRow('Email :', data[i].email),
                                    getRow('DOB :', data[i].dob),
                                    getRow('Password :', data[i].password),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.edit),
                                    onPressed: (){
                                      index=i;
                                      userId=data[i].id;
                                      nameController.text = data[i].name;
                                      emailController.text = data[i].email;
                                      dateController.text = data[i].dob;
                                      passwordController.text = data[i].password;
                                      confirmController.text = data[i].password;


                                      DefaultTabController.of(context)!.animateTo(1);
                                      setState(() {});
                                    }
                                ),
                                IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.delete),
                                    onPressed: (){
                                      Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: "Delete Record",
                                          style: AlertStyle(
                                              titleStyle: TextStyle(fontWeight: FontWeight.w700)
                                          ),
                                          content: Text('Are you sure you want to delete ${data[i].name}?',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                          buttons: [
                                            DialogButton(
                                              child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold),),
                                              onPressed: () => Navigator.pop(context),
                                              color: Colors.blue.shade200,
                                            ),
                                            DialogButton(
                                              child: Text('Delete',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                              color: Colors.blue.shade200,
                                              onPressed: () async{
                                                int res = await DBHelper.instance.deleteData(data[i].id);
                                                print(res);
                                                refresh();
                                                Navigator.of(context).pop();
                                                nameController.clear();
                                                emailController.clear();
                                                dateController.clear();
                                                passwordController.clear();
                                                confirmController.clear();


                                                setState(() {});

                                              },
                                            ),
                                          ]

                                      ).show();
                                    }
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  }
                  return  Center(child: CircularProgressIndicator());
              }
          ),
        ),
    );
  }

  void refresh(){
      setState(() {
          getAllData = DBHelper.instance.selectData();
      });
  }
}


Widget getRow(String name,String value){
     return Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(name,style: TextStyle(fontSize: 16),),
          )),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(value,style: TextStyle(fontSize: 16),),
          )),
       ],
     );
}


