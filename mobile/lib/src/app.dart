
import 'package:challenge_flutter/src/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Challenge Flutter',
          home: HomeScreen()
        );
      },
    );
  }
}
