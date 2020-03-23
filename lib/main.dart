import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';

class Gallery {
  final String id;
  final String name, imageUrl, description;

  Gallery({
  this.id,
  this.name,
  this.imageUrl,
  this.description,
});

  factory Gallery.fromJson(Map<String, dynamic> jsonData){
    var descriptionJSON = jsonData['alt_description'] ?? 'without description :(';
    return Gallery(
      id: jsonData['id'],
      name: jsonData['user']['username'],
      imageUrl: jsonData['urls']['small'],
      description: descriptionJSON,
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Gallery> gallery;

  CustomListView(this.gallery);

  Widget build(context){
    return ListView.builder(
        itemCount: gallery.length,
        itemBuilder: (context, int currentIndex) {
          return createViewItem(gallery[currentIndex], context);
        },
    );
  }

  Widget createViewItem(Gallery gallery, BuildContext context){
     return new ListTile(
       title: new Card(
         elevation: 5.0,
         child: new Container(
           decoration: BoxDecoration(border: Border.all(color: Colors.lightBlueAccent)),
           padding: EdgeInsets.all(20.0),
           margin: EdgeInsets.all(20.0),
           child: Column(
             children: <Widget>[
               Padding(
                 child: Image.network(gallery.imageUrl),
                 padding: EdgeInsets.only(bottom: 8.0),
               ),
               Row(children: <Widget>[
                 Flexible(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         Text("Author: ",
                           style: new TextStyle(fontWeight: FontWeight.bold),),
                      Padding(
                        child: Text(
                       gallery.name,
                       textAlign: TextAlign.right,
                     ),
                      padding: EdgeInsets.all(1.0)),
                      Text("description: ",
                       style: new TextStyle(fontWeight: FontWeight.bold),),
                      Padding(
                       child: new Text(
                         gallery.description,
                         style: new TextStyle(fontStyle: FontStyle.italic),
                         textAlign: TextAlign.right,
                       ),
                       padding: EdgeInsets.all(1.0)),
                    ],),
                 ),
               ]),
         ],
        ),
       ),
     ),
     onTap: (){
         var route = new MaterialPageRoute(
             builder: (BuildContext context) =>
                new SecondScreen(value: gallery),
         );
         Navigator.of(context).push(route);
     });
  }
}

Future<List<Gallery>> downloadJSON() async{
  final jsonEndpoint =
      "https://api.unsplash.com/photos/?client_id=ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9";
  final response = await get(jsonEndpoint);

  if(response.statusCode == 200){
    List galleryURL = json.decode(response.body);
    return galleryURL
        .map((gallery) => new Gallery.fromJson(gallery))
        .toList();
  } else
    throw Exception('fail in load data');
}

class SecondScreen extends StatefulWidget{
  final Gallery value;

  SecondScreen({Key key, this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>{
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Picture')),
      body: new Container(
        child: new Center(
          child: Column(
            children: <Widget>[
              Padding(
                child: new Text(
                  'Gallery',
                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              Padding(
                child: Image.network('${widget.value.imageUrl}'),
                padding: EdgeInsets.only(bottom: 8.0),
              ),
            ],
          ),
        ),
      ),
     );
  }
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: new Scaffold(
        appBar: new AppBar(title: const Text('Image text')),
        body: new Center(
          child: new FutureBuilder<List<Gallery>>(
            future: downloadJSON(),
            builder: (context, snapshot) {
              if (snapshot.hasData ){
                List<Gallery> gallerys = snapshot.data;
                return new CustomListView(gallerys);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return new CircularProgressIndicator();
            },
          ),
        ),
      )
    );
  }
}

void main() {
  runApp(MyApp());
}
