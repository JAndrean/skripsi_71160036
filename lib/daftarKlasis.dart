import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'berita.dart';
import "daftarGereja.dart";

class Klasis {
  String nama;
  String url;

  Klasis(this.nama, this.url);

  static Klasis parseJson(dynamic json){
   String nama = json['nama'];
   String url = json['url'];

   return new Klasis(nama, url);
  }
}

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
  
class KlasisPage extends StatefulWidget{
    @override
    _KlasisPageState createState() => _KlasisPageState() ;
}
  
class _KlasisPageState extends State<KlasisPage> {
  List<Klasis> listKlasis = [];
  List<Gereja> listGereja = [];

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
                    subtitle: Text("Daftar Klasis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> GerejaPage())
                        );
                    },
                    subtitle: Text("Daftar Gereja"),
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
      body: Container(
      child: new ListView.builder(
                itemCount: listKlasis.length,
                itemBuilder: (BuildContext context, int index){
                  return buildList(index);
                },
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
                          Text(listKlasis[index].nama, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
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
    this.getKlasis();
  }

  Future<List<Klasis>> fetchKlasis () async {
    return await rootBundle.loadString('assets/klasis.json')
    .then((String data) => json.decode(data) as List)
    .then((List value) {
      setState(() {
        value.forEach((index) => listKlasis.add(Klasis.parseJson(index)));
        listKlasis.sort((a,b) {
          return a.nama.toLowerCase().compareTo(b.nama.toLowerCase());
        });
      });
        return listKlasis;
    });
  }

  Future<String> getKlasis() async{
   await Future.delayed(Duration(milliseconds: 500));
    setState((){
      isLoading = true;
    });

    var res = await fetchKlasis();
    setState(() {
      listKlasis = res;
    });
    isLoading = false;
    return "Success!";
  }

  void openUrl(index) async {
    if(await canLaunch(listKlasis[index].url))
      await launch(listKlasis[index].url);
    else throw "Terjadi kesalahan silahkan coba kembali";
  }

  void resetTags(){
    if(includedTag.isNotEmpty && excludedTag.isNotEmpty)
    includedTag.clear();
    excludedTag.clear();
  }
}    