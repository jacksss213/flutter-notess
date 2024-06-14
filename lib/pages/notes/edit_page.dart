// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/bloc/users/users_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:interview_test/models/notes.dart';
import 'package:interview_test/pages/home_page.dart';

import '../../bloc/notes/notes_bloc.dart';
import '../../template/theme.dart';

class editPage extends StatefulWidget {
  final int id;
  final Notes notes;
  const editPage({
    Key? key,
    required this.id,
    required this.notes,
  }) : super(key: key);

  @override
  State<editPage> createState() => _editPageState(id, notes);
}

class _editPageState extends State<editPage> {
  final int id;
  final Notes notes;
  _editPageState(this.id, this.notes); //constructor

  final edtTitle = TextEditingController();
  ZefyrController edtDescription = ZefyrController();
  TimeOfDay? selectedTime;
  String? selectedDate;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  String timePickerHour = '-';
  var timePickerMinutes = "-";
  var timePicker = "-";

  Future<NotusDocument> _loadDocument() async {
    return NotusDocument.fromJson(jsonDecode(notes.description));
  }

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(OnInitialUsers());
    _loadDocument().then((document) {
      setState(() {
        edtDescription = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    edtTitle.text = notes.title;

    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(children: [
          Container(
            height: 35,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    child: TextField(
                        autofocus: false,
                        controller: edtTitle,
                        style:
                            mulishFont(20, Color(0xff252525), FontWeight.w700),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Judul Catatan",
                          labelStyle: mulishFont(
                              20, Color(0xff252525), FontWeight.w700),
                        )),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          DatePicker(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 46, 138, 219),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Icon(
                              Icons.access_time_sharp,
                              size: 22,
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<UsersBloc, UsersState>(
                        builder: (context, state) {
                          if (state is UsersInitial) {
                            return GestureDetector(
                              onTap: () {
                                DInfo.dialogConfirmation(
                                        context, 'Hapus', 'Apakah Anda Yakin?')
                                    .then((bool? yes) {
                                  if (yes ?? false) {
                                    context
                                        .read<NotesBloc>()
                                        .add(OnRemoveNotes(id));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return homePage();
                                      }),
                                    );
                                  }
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFF3951),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Image(
                                    image: AssetImage('assets/icon/trash.png'),
                                    height: 22,
                                  )),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<UsersBloc, UsersState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              Notes newNotes = Notes(
                                  0,
                                  edtTitle.text,
                                  jsonEncode(edtDescription.document),
                                  edtDescription.plainTextEditingValue.text,
                                  timePicker,
                                  selectedDate == null ? '-' : selectedDate!,
                                  state.message,
                                  '');
                              context
                                  .read<NotesBloc>()
                                  .add(OnUpdateNotes(newNotes, id));

                              // final prefs = await SharedPreferences.getInstance();
                              // await prefs.setInt('counter', edtTitle.text);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return homePage();
                                }),
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Color(0xff2EDB35),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 25,
                                  color: Colors.white,
                                )),
                          );
                        },
                      ),
                    ],
                  )
                ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Row(children: [
              Icon(
                Icons.access_time_sharp,
                size: 22,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                selectedDate != null ? '${selectedDate!} ${timePicker}' : "-",
                style: mulishFont(14, Color(0xff252525), FontWeight.w400),
              ),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 70),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                ZefyrToolbar.basic(controller: edtDescription),
                Expanded(
                  child: ZefyrEditor(
                    controller: edtDescription,
                  ),
                ),
              ],
            ),
          )
        ]),
      )),
    );
  }

  Future<dynamic> DatePicker(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: isPortrait
                  ? MediaQuery.of(context).size.height * 0.55
                  : MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                children: [
                  DaysPicker(
                    centerLeadingDate: true,
                    minDate: DateTime(1900, 1, 1),
                    maxDate: DateTime(2100, 1, 1),
                    leadingDateTextStyle:
                        mulishFont(15, Color(0xff000000), FontWeight.bold),
                    currentDateTextStyle:
                        mulishFont(13, Color(0xff000000), FontWeight.bold),
                    enabledCellsTextStyle:
                        mulishFont(13, Color(0xff000000), FontWeight.bold),
                    selectedCellTextStyle:
                        mulishFont(13, Color(0xff000000), FontWeight.bold),
                    daysOfTheWeekTextStyle:
                        mulishFont(13, Color(0xff000000), FontWeight.bold),
                    disabledCellsTextStyle:
                        mulishFont(13, Color(0xff000000), FontWeight.bold),
                    onDateSelected: (value) {
                      // print('${value.year}/${value.month}/${value.day}');
                      setState(() {
                        selectedDate =
                            '${value.year}-${value.month}-${value.day}';
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TimePicker(context),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  TextButton TimePicker(BuildContext context) {
    return TextButton(
        onPressed: () async {
          Navigator.pop(context);
          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: selectedTime ?? TimeOfDay.now(),
            initialEntryMode: entryMode,
            orientation: orientation,
            builder: (BuildContext context, Widget? child) {
              // We just wrap these environmental changes around the
              // child in this builder so that we can apply the
              // options selected above. In regular usage, this is
              // rarely necessary, because the default values are
              // usually used as-is.
              return Theme(
                data: Theme.of(context).copyWith(
                  materialTapTargetSize: tapTargetSize,
                ),
                child: Directionality(
                  textDirection: textDirection,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: use24HourTime,
                    ),
                    child: child!,
                  ),
                ),
              );
            },
          );
          setState(() {
            // print(selectedTime);
            selectedTime = time;

            if (selectedTime != null) {
              if (selectedTime!.hour < 10) {
                timePickerHour = '0' + selectedTime!.hour.toString();
              } else {
                timePickerHour = selectedTime!.hour.toString();
              }

              if (selectedTime!.minute < 10) {
                timePickerMinutes = '0' + selectedTime!.minute.toString();
              } else {
                timePickerMinutes = selectedTime!.minute.toString();
              }

              timePicker = '${timePickerHour}:${timePickerMinutes}';
            }
          });
        },
        child: Text("Next"));
  }
}
