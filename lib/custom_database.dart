import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomData extends StatefulWidget {
  const CustomData({this.app});
  final FirebaseApp? app;
  // const CustomData({Key? key}) : super(key: key);

  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  final referenceDatabase = FirebaseDatabase.instance;
  final movieName = 'MovieTitle';
  final movieController = TextEditingController();

  late DatabaseReference _moviesRef;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _moviesRef = database.reference().child("Movies");

    super.initState();
  }
  AppBar initAppBar() => AppBar(
    title: const Text('Movie App'),
  );

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();

    return Scaffold(
      appBar: initAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                movieName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32),
                child: TextField(
                  controller: movieController,
                  decoration: const InputDecoration(
                    labelText: 'Input Movie Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Colors.lightBlue),
                  onPressed: () {
                    ref
                        .child('Movies')
                        .push()
                        .child(movieName)
                        .set(movieController.text)
                        .asStream();
                    movieController.clear();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Items:'),
              Flexible(
                child: FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: _moviesRef,
                  itemBuilder: (BuildContext context,
                      DataSnapshot snapshot,
                      Animation<double> animation,
                      int index) {
                    String? x;
                    if (snapshot.key != null) {
                      x = snapshot.key;
                    }
                    return ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _moviesRef.child(x!).remove(),
                      ),
                      title: Text(snapshot.value['MovieTitle']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
