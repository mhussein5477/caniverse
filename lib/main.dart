import 'package:flutter/material.dart';
import 'package:carrental/views/navigation_view.dart';
import 'views/first_view.dart';
import 'views/sign_up_view.dart';
import 'widgets/provider_widget.dart';
import 'services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Tracker",
        theme: ThemeData(

        ),
        home: FirstView(),
        routes: <String, WidgetBuilder>{
          '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn),
          '/firstview': (BuildContext context) => FirstView(),
          '/home': (BuildContext context) => Home(),

        },
      ),
    );
  }
}



