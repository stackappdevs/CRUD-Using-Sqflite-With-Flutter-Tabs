
import 'package:flutter/cupertino.dart';

class UserData{
     String? name,email,password,dob;
     int? id;

     UserData({this.id,this.name,this.email,this.password,this.dob});


     Map<String,dynamic> toMap(){
             var map = {
                  'id' : id,
                  'name' : name,
                  'email' : email,
                  'dob' : dob,
                  'password' : password
              };
              return map;
     }


     UserData.fromMap(Map<String,dynamic> map){
          id = map['id'];
          name = map['name'];
          dob = map['dob'];
          password = map['password'];
     }

}


List userList = [];


int index=-1;
int userId=0;

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmController = TextEditingController();


