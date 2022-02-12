
import 'package:demoapp/constants/string_constrants.dart';
import 'package:demoapp/service/user_service.dart';
import 'package:demoapp/utills/validator.dart';
import 'package:demoapp/widget/common_elevated_button.dart';
import 'package:demoapp/widget/common_icon_button.dart';
import 'package:demoapp/widget/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey <FormState>loginFormKey = GlobalKey<FormState>();
  Validation validation = Validation();
  DBHelper dbHelper = DBHelper();


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
                  key:  loginFormKey,
                  child: Column(
                    children: [

                      emailTextField(),
                      passwordTextField(),


                      SizedBox(height: height*0.04,),

                      loginButton(),
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

  emailTextField() {
    return CommonTextFormField(
      hintText: enterEmail,
      controller: loginEmailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (val) {
        return validation.validateEmail(val);
      },
      onSaved: (val) {
        setState(() {
          email = val!;
        });
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[ ]')),
      ],
    );
  }

  passwordTextField() {
    return CommonTextFormField(
      hintText: enterPassword,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      controller: loginPasswordController,
      isObscureText: isPwdHide,
      suffix: CommonIconButton(
        onPressed: () {
          isPwdHide = !isPwdHide;
          setState(() {});
        },
        isPwdHide: isPwdHide,
      ),
      onSaved: (val) {
        setState(() {
          password = val!;
        });
      },
      validator: (val) {
        return validation.validatePassword(val);
      },
    );
  }

  loginButton() {
    return CommonElevatedButton(
      child: Text('Login'),
      onPressed: () async {
        if(loginFormKey.currentState!.validate()){
          loginFormKey.currentState!.save();

          List res = await dbHelper.selectEmail(email, password);


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
            List res = await dbHelper.checkLogin(email);

            if(res.isNotEmpty){
              res.forEach((e) {
                if(e.email == email && e.password!=password){
                  loginPasswordController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(invalidPassword),
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
                    content: Text(invalidAccount),
                    duration: Duration(seconds: 3),
                  )
              );
              DefaultTabController.of(context)!.animateTo(1);
            }

          }

          FocusScope.of(context).unfocus();

        }

      },
    );
  }

}
