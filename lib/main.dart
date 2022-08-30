import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/view/login_view.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

/*class Cat extends Object{
 final String name;
 Cat(this.name);
}

extension Run on Cat{
  void run(){
    print("Cat $name is runing");
  }
}
Future<int> heavyFutureThatMultipliesByTwo(int a){
 return Future.delayed(Duration(seconds: 3),(){return a * 2;} );
}
/*Stream<String>getName(){
  return Stream.periodic(const Duration(seconds: 1),(value){
    return 'foo';
  });
}*/
Iterable<int>getOneTwoThree() sync* {
  yield 1;
  yield 2;
  yield 3;
}

void test( ) async {
final result = await heavyFutureThatMultipliesByTwo(10);
print(result);
}
void test2()async{
  await for (final value in getName()){
    print(value);
  }
  print('Stream finished working');
}*/
/*class PairOfString{
  final String value1;
  final String value2;
  PairOfString( this.value1,this.value2);
}
class PairOfIntegers{
  final int value1;
  final int value2;
  PairOfIntegers( this.value1,this.value2);}

class Pair<A,B>{
final A value1;
final B value2;
Pair(this.value1,this.value2);
}

void test2( )  {
  for(final value in getOneTwoThree()){
    print(value);
  }
  final names = Pair<String,int>("foo",20);
  print(names);
}*/

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Homepsge"),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if(user?.emailVerified??false){
                  print("you are a varified user....");
                }else{print("you need to varify");}

                return const Text("Done");
              default:
                return const Text('loading you have to wait');
            }
          },
        ));
  }
}
