import 'package:cepu/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false
    );
  }

  String? _idToken = '';
  String? _uid = '';
  String? _email = '';
  Future<void> getFirebaseAuthUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null){
      _uid = user.uid;
      _email = user.email;
      await user
        .getIdToken(true).
        then(
          (v) => {
            setState(() {
              _idToken = v;
            }),
          }
        );
    }
  }

  @override
  void initState(){
    super.initState();
    getFirebaseAuthUser();
  }

  String generateAvatarUrl(String? fullname){
    final FormattedName = fullname!.trim().replaceAll(" ", "+");
    return 'https://ui-avatars.com/api/?name=$FormattedName&color=ffffff&background=000000';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: (){
              signOut(context);
            }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
          children: [
            Image.network(
              generateAvatarUrl(
                FirebaseAuth.instance.currentUser?.displayName.toString(),
              ),
              width: 100,
              height: 100,
            ),
            SizedBox(height: 6.0),
            Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0)
          ],
        )
      );
  }

}