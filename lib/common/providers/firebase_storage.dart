import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart' as firebase_core;


class FirebaseStorageProvider{



  void upload (String PATH){

  }

  Future<String> readData(String PATH) async{

    String data = "string padrao";
    final _dataBaseRef = FirebaseDatabase.instance.reference();

    _dataBaseRef.child(PATH).onValue.listen((event) {
      final Object? obj = event.snapshot.value;
      data = "Dado $obj";
    });

    print("data: $data");
    return data;
  }
}