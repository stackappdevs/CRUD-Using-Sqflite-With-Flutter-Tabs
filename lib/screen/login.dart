
import 'package:demoapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey <FormState>formKey1 = GlobalKey<FormState>();

  late String email,password;

  bool isPwdHide=true;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

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
                  key:  formKey1,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val){
                          String pettern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                          if(val!.isEmpty){
                            return 'Please enter email';
                          }
                          else if(!RegExp(pettern).hasMatch(val) ){
                            return 'Invalid email address';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        onSaved: (val){
                          setState(() {
                            email = val!;
                          });
                        },
                        controller: loginEmailController,
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
                          return null;
                        },
                        onSaved: (val){
                          password =val!;
                          setState(() {});
                        },
                        obscureText: isPwdHide,
                        controller: loginPasswordController,
                      ),

                      SizedBox(height: height*0.04,),
                      ElevatedButton(
                        onPressed: ()async{
                          if(formKey1.currentState!.validate()){
                            formKey1.currentState!.save();

                             List res = await DBHelper.instance.selectEmail(email, password);


                              if(res.isNotEmpty){
                                  res.forEach((e) {
                                        showDialog(
                                            context: context,
                                            builder: (context){
                                              return AlertDialog(
                                                title: Text('Welcome!'),
                                                content: Text('Hello ${e.name}.'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('OK'))
                                                ],
                                              );
                                            }
                                        );
                                        loginEmailController.clear();
                                        loginPasswordController.clear();
                                  });
                              }

                          else {
                                List res = await DBHelper.instance.checkLogin(email);

                               if(res.isNotEmpty){
                                 res.forEach((e) {
                                   if(e.email == email && e.password!=password){
                                     ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(
                                           content: Text('Password is invalid'),
                                           duration: Duration(seconds: 3),
                                         )
                                     );
                                     DefaultTabController.of(context)!.animateTo(0);
                                   }

                                 });
                               }
                               else{
                                 ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                       content: Text('Account not exist.'),
                                       duration: Duration(seconds: 3),
                                     )
                                 );
                                 DefaultTabController.of(context)!.animateTo(1);
                               }

                          }


                            FocusScope.of(context).unfocus();

                          }
                        },
                        child: Text('Login'),
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



}
