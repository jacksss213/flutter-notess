import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_test/bloc/formValidation/form_validation_bloc.dart';
import 'package:interview_test/bloc/users/users_bloc.dart';
import 'package:interview_test/pages/home_page.dart';
import 'package:interview_test/pages/authentication/login_page.dart';
import 'package:interview_test/pages/notes/create_page.dart';
import 'package:interview_test/pages/authentication/register_page.dart';

import 'bloc/notes/notes_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesBloc()),
        BlocProvider(create: (context) => UsersBloc()),
        BlocProvider(create: (context) => FormValidationBloc()),
      ],
      child: MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: const [
            Locale('en', 'GB'),
            Locale('en', 'US'),
            Locale('ar'),
            Locale('zh'),
          ],
          debugShowCheckedModeBanner: false,
          home: loginPage()),
    );
  }
}
