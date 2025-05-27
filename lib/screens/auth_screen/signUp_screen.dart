import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication/screens/auth_screen/signIn_screen.dart';
import 'package:medication/screens/main_screen.dart';
import 'package:medication/screens/widgets/custom_text.dart';
import 'package:medication/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLicenseAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
        centerTitle: true,
        leading: GestureDetector(onTap:() {
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,)
        ),
      ),
      body: Consumer<UserAuthProvider>(
        builder: (BuildContext context, authProvider, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 30),
            child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(hintText: "Enter your Name", prefixIcon: Icons.people_alt_rounded, textController: nameController),
                    SizedBox(height: 20,),
                    CustomText(hintText: "Enter your email", prefixIcon: Icons.email_rounded, textController: emailController),
                    SizedBox(height: 20,),
                    CustomText(hintText: "Enter your password", prefixIcon: Icons.lock_rounded, textController: passwordController,isPassword: true),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Checkbox(value: isLicenseAccepted, onChanged: (value){
                            setState(() {
                              isLicenseAccepted = value??false;
                            });
                          },),
                        ),
                        Flexible(child: Text("I agree to the healthcare Term of Service and privacy Policy"))
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () async {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          String name = nameController.text.trim();

                          if(email.isNotEmpty && password.isNotEmpty && name.isNotEmpty && isLicenseAccepted){
                            bool responce = await  Provider.of<UserAuthProvider>(context,listen: false).signup(email, password, name);

                            if(responce){
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(),), (Route<dynamic> route) => false);
                            }
                            else{
                              print("object");
                            }
                          }
                          else if(!isLicenseAccepted){
                            print("Please accept the lisence");
                          }
                          else{
                            print("All field must be filed");
                          }

                        },
                        child: createButton(isShowboarder: true, buttonText: "Sign Up",isLoading: authProvider.isLoading)),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have an account? "),
                        GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SigninScreen()));
                            },
                            child: Text("Sign In",style: TextStyle(color:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w600 ),)),
                      ],
                    )
                  ],
                )
            ),
          );
        },
      ),
    );
  }

  Widget createButton({required bool isShowboarder, required String buttonText, bool? isLoading}){
    return Container(
      width: 300,
      height: 56,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: isShowboarder?Color.fromRGBO(64, 124, 226, 1):Colors.transparent,
          border: Border.all(width: 1,color: Color.fromRGBO(64, 124, 226, 1))
      ),
      child: Center(child:(isLoading??false)?CircularProgressIndicator(color: Colors.white,):Text(buttonText??"",style: TextStyle(fontSize: 16,color: isShowboarder?Colors.white:Color.fromRGBO(64, 124, 226, 1),fontWeight: FontWeight.w500),)),
    );
  }
}
