import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;


class FirebaseStorageProvider{
  // firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  void upload (){
    Future<void> uploadString() async {
      String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';

      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('uploads/hello-world.text')
            .putString(dataUrl, format: firebase_storage.PutStringFormat.dataUrl);
        print("fez upload");
      } on firebase_core.FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }
    }

  }
}