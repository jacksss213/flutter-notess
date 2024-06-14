import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/bloc/formValidation/form_validation_bloc.dart';
import 'package:interview_test/bloc/users/users_bloc.dart';
import 'package:interview_test/pages/home_page.dart';
import 'package:interview_test/pages/authentication/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../template/theme.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final edtUsername = TextEditingController();
  final edtPassword = TextEditingController();

  @override
  void initState() {
    context.read<FormValidationBloc>().add(OnFormValidationInitial());
    context.read<UsersBloc>().add(OnFetchUsers());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state.message == '' && state is UsersAuthentication) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return homePage();
            }),
          );
        }

        if (state.message == 'LoggedIn' && state is UsersAdded) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return homePage();
            }),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(scrollDirection: Axis.vertical, children: [
                  isPortrait
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        )
                      : SizedBox(
                          height: 30,
                        ),
                  Center(
                    child: Text(
                      "Selamat Datang",
                      style: mulishFont(25, Color(0xff252525), FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Masuk untuk mengakses akun Anda",
                      style: mulishFont(15, Color(0xff252525), FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(51, 196, 196, 196),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: TextField(
                            autofocus: false,
                            controller: edtUsername,
                            style: mulishFont(15, Color.fromARGB(127, 0, 0, 0),
                                FontWeight.w400),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Username",
                              labelStyle: mulishFont(
                                  15,
                                  Color.fromARGB(126, 0, 0, 0),
                                  FontWeight.w400),
                              suffixIconConstraints:
                                  BoxConstraints(minHeight: 30, minWidth: 30),
                              suffixIcon: const Image(
                                image: AssetImage("assets/icon/user.png"),
                                width: 30,
                                fit: BoxFit.fitWidth,
                              ),
                            )),
                      ),
                      BlocBuilder<FormValidationBloc, FormValidationState>(
                        builder: (context, state) {
                          if (state.username != '' &&
                              state is FormValidationLogin) {
                            return Text(
                              state.username,
                              style: mulishFont(
                                  13, Color(0xffFF3951), FontWeight.w400),
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(51, 196, 196, 196),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                            autofocus: false,
                            obscureText: true,
                            controller: edtPassword,
                            style: mulishFont(15, Color.fromARGB(127, 0, 0, 0),
                                FontWeight.w400),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Kata Sandi",
                              labelStyle: mulishFont(
                                  15,
                                  Color.fromARGB(126, 0, 0, 0),
                                  FontWeight.w400),
                              suffixIconConstraints:
                                  BoxConstraints(minHeight: 30, minWidth: 30),
                              suffixIcon: const Image(
                                image: AssetImage("assets/icon/lock.png"),
                                width: 30,
                                fit: BoxFit.fitWidth,
                              ),
                            )),
                      ),
                      BlocBuilder<FormValidationBloc, FormValidationState>(
                        builder: (context, state) {
                          if (state.password != '' &&
                              state is FormValidationLogin) {
                            return Text(
                              state.password,
                              style: mulishFont(
                                  13, Color(0xffFF3951), FontWeight.w400),
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                  BlocBuilder<UsersBloc, UsersState>(
                    builder: (context, state) {
                      if (state.message != '' && state is UsersAuthentication) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              state.message,
                              style: mulishFont(
                                  13, Color(0xffFF3951), FontWeight.w400),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<FormValidationBloc>().add(
                                OnFormValidationLogin(
                                    edtUsername.text, edtPassword.text));

                            if (edtUsername.text != '' &&
                                edtPassword.text != '') {
                              context.read<UsersBloc>().add(OnAuthentication(
                                  edtUsername.text, edtPassword.text));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFF3951),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Masuk",
                                  style: mulishFont(
                                      22, Color(0xffFCFCFC), FontWeight.w600)),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Anggota Baru? ",
                            style: mulishFont(
                                13, Color(0xff252525), FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return registerPage();
                                }),
                              );
                            },
                            child: Text("Daftar sekarang",
                                style: mulishFont(
                                    13, Color(0xffFF3951), FontWeight.w700)),
                          )
                        ],
                      )
                    ],
                  ),
                  isPortrait
                      ? SizedBox(
                          height: 30,
                        )
                      : SizedBox(
                          height: 150,
                        ),
                ]),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
