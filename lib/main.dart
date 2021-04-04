import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maymay/screens/splash.dart';

import 'blocs/home_page_bloc/home_page_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HomePageBloc>(create: (_) => HomePageBloc()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
