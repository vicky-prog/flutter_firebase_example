
import 'package:flutter_firebase_example/main.dart';
import 'package:patrol/patrol.dart';
//  flutter pub global activate patrol_cli

void main(){
   patrolTest("description", ($)async{
     await $.pumpWidgetAndSettle(const MyApp());
   });
}