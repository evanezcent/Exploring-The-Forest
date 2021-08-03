import 'package:flutter/material.dart';
import 'package:register/ui/components/circle-timeline.dart';
import 'package:register/ui/components/long_button.dart';
import 'package:register/ui/components/password-requirement.dart';
import 'package:register/ui/components/timeline.dart';
import 'package:register/utils/constants.dart';

class CreatePaswordScreen extends StatefulWidget {
  const CreatePaswordScreen({Key? key}) : super(key: key);

  @override
  _CreatePaswordScreenState createState() => _CreatePaswordScreenState();
}

class _CreatePaswordScreenState extends State<CreatePaswordScreen> {
  TextEditingController passwordController = TextEditingController();
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: custom_blue,
        centerTitle: false,
        title: Text(
          "Create Password",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      backgroundColor: custom_blue,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Timeline(
              index: 2,
            ),
            SizedBox(height: 30),
            Text("Create Password", style: white_800_20),
            SizedBox(height: 6),
            Text("Password will be used to login account",
                style: white_normal_14),
            SizedBox(height: 30),
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: hide,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hide = !hide;
                          });
                        },
                        icon: Icon(
                          hide ? Icons.remove_red_eye : Icons.remove_red_eye,
                          color: hide ? Colors.grey : custom_blue,
                        )),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            SizedBox(height: 15),
            RichText(
                text: TextSpan(
                    text: "Complexity : ",
                    style: white_normal_14,
                    children: [
                  TextSpan(text: "Very Weak", style: orange_600_14)
                ])),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PasswordRequirement(
                  complete: false,
                  text: "a",
                  name: "Lowercase",
                ),
                PasswordRequirement(
                  complete: false,
                  text: "A",
                  name: "Uppercase",
                ),
                PasswordRequirement(
                  complete: false,
                  text: "123",
                  name: "Numeric",
                ),
                PasswordRequirement(
                  complete: false,
                  text: "9+",
                  name: "Characters",
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: LongButton(
                    bgColor: custom_blue_disable,
                    textColor: Colors.white,
                    loading: false,
                    width: size.width,
                    title: "Next",
                    onClick: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreatePaswordScreen()));
                    })),
          ],
        ),
      ),
    );
  }
}
