import 'dart:ffi';
import 'dart:math';

import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/bloc/users/users_bloc.dart';
import 'package:interview_test/models/notes.dart';
import 'package:interview_test/pages/notes/create_page.dart';
import 'package:interview_test/pages/notes/edit_page.dart';
import 'package:interview_test/pages/authentication/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/notes/notes_bloc.dart';
import '../template/theme.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    context.read<UsersBloc>().add(OnInitialUsers());
    context.read<NotesBloc>().add(OnFetchNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Catatan",
                  style: mulishFont(25, Color(0xff252525), FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    AccountDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xffF1F1F1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Image(
                      image: AssetImage("assets/icon/user_2.png"),
                      width: 25,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 60),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return createPage();
                    }),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  backgroundColor: Color(0xffFF3951),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Buat Catatan",
                        style:
                            mulishFont(14, Color(0xffFCFCFC), FontWeight.w600)),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              )
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 120),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.77,
            child:
                BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
              if (state is NotesInitial) {
                return SizedBox.shrink();
              }

              // if (state is NotesLoading) {
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }

              List<Notes> list = state.notes;

              return ListView.builder(
                  itemCount: list.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Notes notes = list[index];
                    List<int> colorList = [
                      0xffFF3951,
                      0xff9039FF,
                      0xff9039FF,
                      0xffFF9839,
                    ];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return editPage(id: index, notes: notes);
                          }),
                        );
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(colorList[Random().nextInt(4)]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notes.title,
                                  style: mulishFont(
                                      17, Color(0xffFCFCFC), FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 63,
                                  child: Text(
                                    notes.descriptionConvert,
                                    overflow: TextOverflow.ellipsis,
                                    style: mulishFont(
                                        14, Color(0xffFCFCFC), FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Icon(
                                        Icons.access_time_sharp,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${notes.date} ${notes.time}',
                                        style: mulishFont(13, Color(0xffFCFCFC),
                                            FontWeight.w400),
                                      ),
                                    ]),
                                    Text(
                                      "${notes.created_at}",
                                      style: mulishFont(13, Color(0xffFCFCFC),
                                          FontWeight.w400),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    );
                  });
            }),
          )
        ]),
      )),
    );
  }

  Future<dynamic> AccountDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersInitial) {
                  return Container(
                    height: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(51, 196, 196, 196),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.message,
                                    style: mulishFont(
                                        15,
                                        Color.fromARGB(127, 0, 0, 0),
                                        FontWeight.w700),
                                  ),
                                  Image(
                                    image: AssetImage("assets/icon/user.png"),
                                    width: 30,
                                    height: 30,
                                  )
                                ]),
                          ),
                          GestureDetector(
                            onTap: () async {
                              DInfo.dialogConfirmation(
                                      context, 'Keluar', 'Apakah Anda Yakin?')
                                  .then((bool? yes) async {
                                if (yes ?? false) {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('username');

                                  context
                                      .read<NotesBloc>()
                                      .add(OnLogoutNotes());

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return loginPage();
                                    }),
                                  );
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(51, 196, 196, 196),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Keluar",
                                      style: mulishFont(
                                          15,
                                          Color.fromARGB(127, 0, 0, 0),
                                          FontWeight.w700),
                                    ),
                                    Image(
                                      image:
                                          AssetImage("assets/icon/logout.png"),
                                      width: 25,
                                      height: 25,
                                    )
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                {
                  return Container();
                }
              },
            ),
          );
        });
  }
}
