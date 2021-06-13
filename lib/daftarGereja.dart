import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'berita.dart';
import 'daftarKlasis.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';


final _root = 'https://www.sinodegkj.or.id/';
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);

class Gereja {
  String nama;
  String url;
  String klasis;

  Gereja(this.nama, this.url, this.klasis);

  static Gereja parseJson(dynamic json){
    String nama = json['nama'];
    String url = json['url'];
    String klasis = json['klasis'];

    return new Gereja(nama ,url, klasis);
  }
}
  
class GerejaPage extends StatefulWidget{
    @override
    _GerejaPageState createState() => _GerejaPageState() ;
}
  
class _GerejaPageState extends State<GerejaPage> {
  //daftar untuk menyimpan hasil parseJson
  List<Gereja> listGereja = [];
  //daftar yang akan ditampilkan dalam listview
  var items = [];

  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
            children: <Widget>[
              Container(
                height: 80.0,
                child: DrawerHeader(
                  child: Text('Sinode GKJ', style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent
                  ),
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                title: Text('Beranda',),
              ),
              Divider(thickness: 2.0,),
              ExpansionTile(
                title: Text('Berita'),
               children: <Widget>[
                  ListTile(
                    subtitle: Text('Sinode'),
                    onTap: (){
                      resetTags();
                      includedTag.add(1);
                      excludedTag.add(2);
                      excludedTag.add(3);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => BeritaPage())
                      );
                    }
                  ),
                  ListTile(
                    subtitle: Text('Klasis'),
                    onTap: (){
                      resetTags();
                      includedTag.add(2);
                      excludedTag.add(1);
                      excludedTag.add(3);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BeritaPage()),
                      );
                    },
                  ),
                  ListTile(
                    subtitle: Text('Gereja'),
                    onTap: (){
                      resetTags();
                      includedTag.add(3);
                      excludedTag.add(1);
                      excludedTag.add(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BeritaPage())
                      );
                    }
                  ),
                  ListTile(
                    subtitle: Text('Lembaga'),
                    onTap: (){
                      resetTags();
                      includedTag.add(3);
                      excludedTag.add(1);
                      excludedTag.add(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BeritaPage())
                      );
                    }
                  ),
                ],
              ),
              Divider(thickness: 2.0, indent: 5.0,),
              ExpansionTile(
                title: Text("Daftar Klasis & Gereja"),
                children: <Widget>[
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> KlasisPage())
                        );
                    },
                    subtitle: Text("Daftar Klasis"),
                  ),
                  ListTile(
                    subtitle: Text("Daftar Gereja", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  )
                ],
              ),
            ],
        )
      ),
      appBar: AppBar(
        title: Text('Sinode GKJ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(
            child: CircularProgressIndicator(),
          ):
        Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (value){
                  searchGereja(value);
                },
                  decoration: InputDecoration(
                  labelText: "Cari Gereja",
                  hintText: "Nama Gereja",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                ),
              ),
            ),
            Expanded(
              child: DraggableScrollbar.rrect(
                      controller: _scrollController,
                      backgroundColor: Colors.blueAccent,
                      child: ListView.builder(
                            controller: _scrollController,
                            itemCount: items.length,
                            itemBuilder: (context, int index){
                              return buildList(index);
                            }
                          )
                        )
                      ),
          ],
        ),
      ),
    );
  }

Widget buildList(index){
  return Container(
      child: ListTile(
          title: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(items[index].nama,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
                ],
               ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {  
                          openUrl(index);
                          },
                          child: Text("Kunjungi"),
                           )
                        ),
                      )
                    ],
                   ),
                    subtitle: Divider(thickness: 1.2, height: 5.0, color: Colors.black),
                )
              );
}


  @override
  void initState(){
    super.initState();
    this.getGereja();
  }

  //pengambilan data dari file json lokal yang kemudian diisi ke dalam list
  Future<List<Gereja>> fetchGereja () async {
    return await rootBundle.loadString('assets/gereja.json')
    .then((String data) => json.decode(data) as List)
    .then((List value) {
      setState(() {
        value.forEach((index) => listGereja.add(Gereja.parseJson(index)));
        listGereja.sort((a,b){
          return a.nama.toLowerCase().compareTo(b.nama.toLowerCase());
        });
      });
        return listGereja;
    });

    
  }

  Future<String> getGereja() async{
   await Future.delayed(Duration(milliseconds: 500));
    setState((){
      isLoading = true;
    });

    var res = await fetchGereja();
    setState(() {
      items = res;
    });
    isLoading = false;
    return "Success!";
  }

  void openUrl(index) async {
    if(await canLaunch(items[index].url))
      await launch(items[index].url);
    else throw "Terjadi kesalahan silahkan coba kembali";
  }


  void resetTags(){
    if(includedTag.isNotEmpty && excludedTag.isNotEmpty)
    includedTag.clear();
    excludedTag.clear();
  }

  void searchGereja(String query) {
    var dummyList = [];
    dummyList.addAll(listGereja);
    if(query.isNotEmpty){
      //list hasil pencarian
      List<Gereja> resultList = [];
      dummyList.forEach((item) {
        //pencarian tidak case sensitive
        if(item.nama.toLowerCase().contains(query.toLowerCase())) {
          resultList.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(resultList);
      });
    } else if (query.isEmpty || query == ""){
      setState(() {
        items.clear();
        getGereja();
      });
    }
  }
}    