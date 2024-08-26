import 'package:OpenForge/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'OpenForge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: checkNavigation(),
        builder: (context, snapshot) {
          if(snapshot.data!=null){
 return snapshot.data!?const LoginScreen(): const HomeScreen();
          }
          return  Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Image.asset('assets/openforge_logo.png'),
             const   SizedBox(height: 50,),
             const   CircularProgressIndicator()
              ],),
            ),
          );
        }
      ),
    );
  }
Future<bool>  checkNavigation()async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('username');
  if(username!=null){
    return false;
  }else{
    return true;
  }
  }
}


