import 'dart:async';

import 'package:demoapp/constants/string_constrants.dart';
import 'package:demoapp/model/user_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class DBHelper{

    Database? db;

    String? name,email,password,dob;
    

    Future<Database?> initDB()async{
          if(db != null){

              return db;
          }
          else{

              final dbPath = await getDatabasesPath();
              final path =  join(dbPath,dbName);
              db = await openDatabase(
                  path,
                  version: databaseVersion,
                  onCreate: onCreate
              );
              return db;
          }
    }


    Future<void> onCreate(Database db, int version) async{

      String query = "create table $table ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colName TEXT ,$colEmail TEXT ,$colBirthday TEXT ,$colPassword TEXT )";

      await db.execute(query);
    }
    


    Future<int?> insertUser(String name,String email,String dob,String pwd)async{
         await initDB();


        int? res = await db?.insert(table,toLocalJson(name,email,dob,pwd));
        return res;

    }


    Map<String, dynamic> toLocalJson(name,email,dob,pwd) {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data['name'] = name;
      data['email'] = email;
      data['birthDate'] = dob;
      data['password'] = pwd;

      return data;
    }


    Future selectData()async{
        await initDB();

        // String query = 'SELECT * FROM $table';

        List<Map<String,dynamic>> res = await db!.query(table);


        return List.generate(res.length, (i){
          return UserData(
              id: res[i]['id'],
              name: res[i]['name'],
              email: res[i]['email'],
              dob: res[i]['birthDate'],
              password: res[i]['password']
          );
        });


    }
    
    
    Future<int> deleteData(int id)async{
            await initDB();

         // int  res =  await db!.rawDelete('delete from $table where id= ?',[id]);

          int res =   await db!.delete(table,where: "id=?",whereArgs: [id]);

            return res;
    }


    Future<int> updateData(String name,String email,String dob,String pwd,int id)async{
        await initDB();


      int res = await db!.update(table,rowData(name,email,dob,pwd), where: "$colId=?",whereArgs: [id]);
      return res;
    }

        Map <String,dynamic> rowData(name,email,dob,pwd){
          final Map <String,dynamic>data = Map<String,dynamic>();
          data['name'] = name;
          data['email'] = email;
          data['birthDate'] = dob;
          data['password'] = pwd;

          return data;
        }

        Future<List> selectEmail(String email,String password)async{

         await initDB();

         List res = await db!.rawQuery('select * from $table where $colEmail=? and $colPassword=?',[email,password]);


        return List.generate(res.length, (i){
            return UserData(
                name: res[i]['name'],
                email: res[i]['email'],
                password: res[i]['password']
            );
        });
    }

    Future<List> checkLogin(String email)async{

         await initDB();

         List res = await db!.rawQuery('select * from $table where $colEmail=?' ,[email]);


        return List.generate(res.length, (i){
            return UserData(
                email: res[i]['email'],
                password: res[i]['password'],
            );
        });
    }



}


