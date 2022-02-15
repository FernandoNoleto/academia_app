import 'package:flutter/material.dart';

/*Paginas*/
import 'detailed_exercise_page.dart';

/*Providers*/
import 'package:academiaapp/common/providers/card_provider.dart';
import 'package:academiaapp/common/providers/container_provider.dart';

/*Plugins*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:academiaapp/firebase_options.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bem vindo de volta 'user'"),
      ),
      body: ContainerProvider(
        horizontal: 10,
        vertical: 10,
        child: Center(
          child: ListView(
            children: <Widget>[
              CardProvider(
                title: const Text("Nome exercício"),
                subtitle: const Text("Repetições: 10"),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const DetailedExercisePage();
                    }),
                  );
                },
              ),
              StreamBuilder(
                  // stream: Firestore.instance.collection('users').snapshots,
                stream: FirebaseFirestore.instance.snapshotsInSync(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    else {
                      switch(snapshot.connectionState){
                        case ConnectionState.waiting:
                          return const LinearProgressIndicator();
                          break;
                        default: return Center(
                          child: ListView(
                              children: snapshot.data.documents.map((DocumentSnapshot doc){
                                return ListTile(
                                  leading: const Icon(
                                    Icons.people,
                                    size: 52,
                                  ),
                                  title: Text("teste"),
                                  // title: Text("Nome: ${doc.data['name']}"),
                                );
                              }).toList(),
                          ),
                        );
                      }
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
