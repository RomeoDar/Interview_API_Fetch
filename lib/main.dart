import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _text = TextEditingController();
  String searchdata = "";

  Future<List<dynamic>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=25'));

    if (response.statusCode == 200) {
      //print(jsonDecode(response.body)['results'][0]['name']['title']);
      return jsonDecode(response.body)['results'];
      //return json.decoder(response.body)[''];
      //Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    //fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              enableSuggestions: true,
              controller: _text,
              decoration: InputDecoration(
                labelText: 'Enter the Value',
              ),
              onChanged: (value) {
                setState(() {
                  searchdata = value;
                });
              },
            ),
            Container(
              child: FutureBuilder<List>(
                future: fetchUsers(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('Waiting to start');
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      if (snapshot.hasError) {
                        return new Text('Error: ${snapshot.error}');
                      } else {
                        return new ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              //print(searchdata);
                              if (searchdata ==
                                      snapshot.data[index]['name']['title']
                                          .toString()) {
                                return ListTile(
                                  //leading: Icon(Icons.play_arrow,),
                                  title: Text(snapshot.data[index]['name']
                                              ['title']
                                          .toString() +
                                      ' ' +
                                      snapshot.data[index]['name']['first']
                                          .toString() +
                                      ' ' +
                                      snapshot.data[index]['name']['last']
                                          .toString()),
                                  subtitle: Text('Email: ' +
                                      snapshot.data[index]['email'] +
                                      '\n' +
                                      'Location: ' +
                                      snapshot.data[index]['location']['city'] +
                                      ' ' +
                                      snapshot.data[index]['location']
                                          ['state'] +
                                      ' ' +
                                      snapshot.data[index]['location']
                                          ['country']),
                                );
                              } else {
                                return Container();
                              }

                              /*return ListTile(
                                //leading: Icon(Icons.play_arrow,),
                                title: Text(snapshot.data[index]['name']
                                            ['title']
                                        .toString() +
                                    ' ' +
                                    snapshot.data[index]['name']['first']
                                        .toString() +
                                    ' ' +
                                    snapshot.data[index]['name']['last']
                                        .toString()),
                                subtitle: Text('Email: ' +
                                    snapshot.data[index]['email'] +
                                    '\n' +
                                    'Location: ' +
                                    snapshot.data[index]['location']['city'] +
                                    ' ' +
                                    snapshot.data[index]['location']['state'] +
                                    ' ' +
                                    snapshot.data[index]['location']
                                        ['country']),
                              );*/
                            });
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),

      /*TextField(
        controller: _text,
        decoration: InputDecoration(
          labelText: 'Enter the Value',
        ),
      ),*/ /*Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),*/
      /* floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    this.userId,
    this.id,
    this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
