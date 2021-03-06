
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class PageHomeGaleri extends StatefulWidget {
  @override
  _PageHomeGaleriState createState() => _PageHomeGaleriState();
}

class _PageHomeGaleriState extends State<PageHomeGaleri> {
  Future<List> getData() async {
    final response =
        await http.get("http://apiternak.000webhostapp.com/get_galeri.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Apps Galeri'),
          backgroundColor: Colors.brown,
        ),
        body: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ItemList(list: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ));
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailBerita(list, index);
              }));
            },
            child: Card(
              child: ListTile(
                title: Text(
                  list[index]['judul'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                // subtitle: Text("Tanggal :${list[index]['tgl_berita']}"),
                trailing: Image.network(
                  'http://apiternak.000webhostapp.com/' + list[index]['gambar'],
                  fit: BoxFit.cover,
                  width: 60.0,
                  height: 60.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class DetailBerita extends StatelessWidget {
  List list;
  int index;
  DetailBerita(this.list, this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(list[index]['judul']),
      //   backgroundColor: Colors.brown,
      // ),
      body: ListView(
        children: <Widget>[
          Image.network(
              'http://apiternak.000webhostapp.com/' + list[index]['gambar']),
          Container(
            padding: EdgeInsets.all(32.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          list[index]['judul'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                      ),
                      // Text(list[index]['tgl_berita'])
                    ],
                  ),
                ),
                Icon(
                  Icons.star,
                  color: Colors.brown,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(32.0),
            child: Text(
              list[index]['isi'],
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
