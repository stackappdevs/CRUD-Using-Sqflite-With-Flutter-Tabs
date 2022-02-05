
import 'package:demoapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_model.dart';

class Registration extends StatefulWidget {

  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  GlobalKey <FormState>formKey = GlobalKey<FormState>();

  late String name,email,date,password;

  DateTime selectDate = DateTime.now();
  bool isPwdHide=true;
  bool isPwdHide1=true;
  bool isEmailExist = false;



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: width*0.03),
                  padding: EdgeInsets.all(width*0.055),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(height*0.02)
                  ),
                  child: Form(
                    key:  formKey,
                    child: Column(
                      children: [
                          TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Your Name',
                              ),
                              validator: (val){
                                  if(val!.isEmpty){
                                      return 'Please enter name';
                                  }
                                  else if (!RegExp('[a-zA-Z]').hasMatch(val)) {
                                    return 'Please enter character only';
                                  }
                                  return null;
                              },
                              onSaved: (val){
                                setState(() {
                                    name =val!;
                                });
                              },
                              controller: nameController,
                          ),
                          TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Your Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp('[ ]')),
                              ],
                              validator: (val){
                                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                                  if(val!.isEmpty){
                                      return 'Please enter email';
                                  }
                                  else if(!RegExp(pattern).hasMatch(val) ){
                                      return 'Invalid email address';
                                  }
                                  return null;
                              },
                              onSaved: (val){
                                 setState(() {
                                    email = val!;
                                 });
                              },
                              controller: emailController,
                          ),
                          TextFormField(
                             decoration: InputDecoration(
                               hintText: 'Date of Birth',
                             ),
                             onTap: ()async{
                                  DateTime? picked = await  showDatePicker(
                                      context: context,
                                      initialDate: selectDate,
                                      firstDate: DateTime(1950,1),
                                      lastDate: DateTime.now(),
                                  );
                                  if(picked != null && picked != selectDate){
                                      selectDate =picked;
                                      dateController.text = '${selectDate.day.toString()}/${selectDate.month.toString()}/${selectDate.year.toString()}';
                                      date=dateController.text;
                                  }
                                  setState(() {});
                             },
                              validator: (val){
                               late int dobYear;
                               if(dateController.text.isEmpty){
                                  return 'Please enter Date of birth';
                               }
                               else{
                                 if(selectDate.year==DateTime.now().year){
                                   int year = int.parse(dateController.text.split('/')[2]);
                                   dobYear = year;
                                   date=dateController.text;
                                   setState(() {});
                                 }
                                 else{
                                   dobYear=selectDate.year;
                                   setState(() {});
                                 }
                                 int age = DateTime.now().year - dobYear ;
                                 if(val!.isEmpty){
                                   return 'Please enter DOB';
                                 }
                                 else if(age<18){
                                   return 'Age must be above 18.';
                                 }
                               }

                               return null;
                              },
                             controller: dateController,
                          ),
                          TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    isPwdHide = !isPwdHide;
                                    setState(() {});
                                  },
                                  icon: Icon((isPwdHide) ? Icons.visibility : Icons.visibility_off,color: Colors.blue.shade300,),
                                )
                              ),
                              validator: (val){
                                if(val!.isEmpty){
                                    return 'Please enter password';
                                }
                                else if(val.length<6){
                                   return 'Password must be 6 digit long';
                                }
                                return null;
                              },
                              onSaved: (val){
                                password =val!;
                                setState(() {});
                              },
                              obscureText: isPwdHide,
                              controller: passwordController,
                          ),
                          TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    isPwdHide1 = !isPwdHide1;
                                    setState(() {});
                                  },
                                  icon: Icon((isPwdHide1) ? Icons.visibility : Icons.visibility_off,color: Colors.blue.shade300,),
                                )
                              ),
                              validator: (val){
                                if(val!.isEmpty){
                                    return 'Please enter confirm password';
                                }
                                if(val != passwordController.text){
                                    return 'Password not match!';
                                }
                                return null;
                              },
                              obscureText: isPwdHide1,
                              controller: confirmController,
                          ),
                          SizedBox(height: height*0.04,),
                          ElevatedButton(
                              onPressed: ()async{

                                    if(formKey.currentState!.validate()){
                                      formKey.currentState!.save();

                                        if(index>-1){

                                         await DBHelper.instance.updateData(name, email, date,password, userId);

                                          index=-1;
                                          selectDate=DateTime.now();

                                          nameController.clear();
                                          emailController.clear();
                                          dateController.clear();
                                          passwordController.clear();
                                          confirmController.clear();
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                          DefaultTabController.of(context)!.animateTo(2);
                                        }
                                        else{

                                          await checkEmail();
                                          if(!isEmailExist){

                                          await  DBHelper.instance.insertUser(name, email, date, password);


                                          nameController.clear();
                                          emailController.clear();
                                          dateController.clear();
                                          passwordController.clear();
                                          confirmController.clear();
                                          FocusScope.of(context).unfocus();


                                          setState(() {});
                                          DefaultTabController.of(context)!.animateTo(2);

                                        }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                duration: Duration(seconds: 5),
                                                content: Text('Email already exist!')));
                                        isEmailExist = false;
                                        FocusScope.of(context).unfocus();
                                        setState(() {});
                                      }

                                        }


                                      FocusScope.of(context).unfocus();
                                      setState(() {});

                                    }
                              },
                              child: Text((index>-1) ? 'Update' : 'Register'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width*0.04)),
                                textStyle: TextStyle(fontSize: height*0.030,fontFamily: 'app',fontWeight: FontWeight.w400),
                                primary: Colors.blue.shade600,
                                minimumSize: Size(width*0.35, height*0.065)
                              ),
                          ),
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future checkEmail()async{
      List res = await DBHelper.instance.selectData();

      if(res.isNotEmpty){
        res.forEach((i) {
          if(i.email == email){
            setState(() {
              print('data ==$isEmailExist');
              isEmailExist=true;
            });
          }
        });
      }
      else{
        isEmailExist=false;
        setState(() {});
      }
  }

}

