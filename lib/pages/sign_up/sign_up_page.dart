
import 'package:demoapp/constants/string_constrants.dart';
import 'package:demoapp/service/user_service.dart';
import 'package:demoapp/utills/validator.dart';
import 'package:demoapp/widget/common_elevated_button.dart';
import 'package:demoapp/widget/common_icon_button.dart';
import 'package:demoapp/widget/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/user_item.dart';

class Registration extends StatefulWidget {

  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  GlobalKey <FormState>formKey = GlobalKey<FormState>();
  Validation validation = Validation();
  DBHelper dbHelper = DBHelper();

  late String name,email,date,password;

  DateTime selectDate = DateTime.now();
  bool isPasswordHide=true;
  bool isConfirmPasswordHide=true;
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

                        nameTextField(),
                        emailTextField(),
                        dateOfBirthTextField(),
                        passwordTextField(),
                        confirmPasswordTextField(),

                        SizedBox(height: height*0.04,),

                        registrationButton(),
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
      List res = await dbHelper.selectData();

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

  nameTextField(){
    return CommonTextFormField(
      hintText: enterName,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      controller: nameController,
      onSaved: (val) {
        setState(() {
          name = val!;
        });
      },
      validator: (val){
        return validation.validateName(val);
      },
    );
  }

  emailTextField() {
    return CommonTextFormField(
      hintText:  enterEmail,
      controller: emailController,
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

  dateOfBirthTextField(){
    return CommonTextFormField(
      hintText: enterDOB,
      controller: dateController,
      keyboardType: TextInputType.none,
      textInputAction: TextInputAction.next,
      onTap:  () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectDate,
          firstDate: DateTime(1950, 1),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != selectDate) {
          selectDate = picked;
          dateController.text =
          '${selectDate.day.toString()}/${selectDate.month.toString()}/${selectDate.year.toString()}';
          date = dateController.text;
        }
        setState(() {});
      },

      validator: (val) {
        late int dobYear;
        if (dateController.text.isEmpty) {
          return errorDOB;
        } else {
          if (selectDate.year == DateTime.now().year) {
            int year =
            int.parse(dateController.text.split('/')[2]);
            dobYear = year;
            date = dateController.text;

          } else {
            dobYear = selectDate.year;
          }
          setState(() {});
          int age = DateTime.now().year - dobYear;
          if (val!.isEmpty) {
            return errorDOB;
          } else if (age < 18) {
            return errorAge;
          }
          return null;
        }
      },
    );
  }

  passwordTextField() {
    return CommonTextFormField(
      hintText: enterPassword,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: passwordController,
      isObscureText: isPasswordHide,
      suffix:CommonIconButton(
        onPressed: () {
          isPasswordHide = !isPasswordHide;
          setState(() {});
        },
        isPwdHide: isPasswordHide,
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

  confirmPasswordTextField(){
    return CommonTextFormField(
      hintText: enterConfirmPassword,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      controller: confirmController,
      isObscureText: isConfirmPasswordHide,
      suffix:CommonIconButton(
        onPressed: () {
          isConfirmPasswordHide = !isConfirmPasswordHide;
          setState(() {});
        },
        isPwdHide: isConfirmPasswordHide,
      ),
      validator: (val){
        return validation.validateConfirmPassword(val, passwordController.text);
      },
    );
  }

  registrationButton(){
    return CommonElevatedButton(
      child:  Text((index>-1) ? 'Update' : 'Register'),
      onPressed: ()async{

        if(formKey.currentState!.validate()){
          formKey.currentState!.save();

          if(index>-1){
            await checkEmail();
            if(!isEmailExist || updateEmail == email){

              await dbHelper.updateData(name, email, date,password, userId);

              index=-1;
              selectDate=DateTime.now();

              nameController.clear();
              emailController.clear();
              dateController.clear();
              passwordController.clear();
              confirmController.clear();
              DefaultTabController.of(context)!.animateTo(2);
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(emailExist)));
              isEmailExist = false;
            }

          }
          else{

            await checkEmail();
            if(!isEmailExist){

              await  dbHelper.insertUser(name, email, date, password);


              nameController.clear();
              emailController.clear();
              dateController.clear();
              passwordController.clear();
              confirmController.clear();


              DefaultTabController.of(context)!.animateTo(2);

            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(emailExist)));
              isEmailExist = false;
            }

          }


          FocusScope.of(context).unfocus();
          setState(() {});

        }
      },
    );
  }
}

