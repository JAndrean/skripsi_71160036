import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

import 'berita.dart';
import 'daftarGereja.dart';
import 'daftarKlasis.dart';
import 'post_detail_page.dart';

final _root = 'https://sinodegkj.or.id';
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);

Widget passTitle, passDate, postContent, passImage;

bool isLoading = false;
bool isConnected = false;

List<int> includedTag = [4];
List<int> excludedTag = [0];
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/berita': (context) => BeritaPage(),
        '/postDetail': (context) => PostDetailPage(),
        '/klasis' : (context) => KlasisPage(),
        '/gereja' : (context) => GerejaPage(),
      },
    )
  );
} //App Entry Point

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//Beranda
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    if(isConnected == true){
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
                title: Text('Beranda', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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
                title: Text('Daftar Klasis & Gereja'),
                children: <Widget>[
                  ListTile(
                    onTap: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => KlasisPage())
                      );
                    },
                  subtitle: Text("Daftar Klasis"),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => GerejaPage())
                      );
                    },
                    subtitle: Text("Daftar Gereja"),
                  ),
                ],
              ),
            ],
        )
      ),
      appBar: AppBar(
        title: Text('Sinode GKJ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :
      ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (context, int index){
          return buildPost(index);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          setState(() {
            getPosts();
            getTags();
            checkConnection();
          });
        },
        label: Text('Muat Ulang', style: TextStyle(fontSize: 10)),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.blueAccent,
        ),
      );
    }
    else{
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
                title: Text('Beranda', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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
                    onTap: (){resetTags();
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
                title: Text('Daftar Klasis & Gereja'),
                children: <Widget>[
                  ListTile(
                    onTap: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => KlasisPage())
                      );
                    },
                  subtitle: Text("Daftar Klasis"),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => GerejaPage())
                      );
                    },
                    subtitle: Text("Daftar Gereja"),
                  ),
                ],
              ),
            ],
        )
      ),
      appBar: AppBar(
        title: Text('Sinode GKJ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text("Perangkat Tidak Terhubung ke Internet"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          setState(() {
            getPosts();
            getTags();
            checkConnection();
          });
        },
        label: Text('Muat Ulang', style: TextStyle(fontSize: 10)),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    this.checkConnection();
    this.getTags();
    this.getPosts();
  }

  void checkConnection() async {
    var connection = await (Connectivity().checkConnectivity());
    if(connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi)
      isConnected = true;
    else
      isConnected = false;
  }

  void resetTags(){
    if(includedTag.isNotEmpty && excludedTag.isNotEmpty)
    includedTag.clear();
    excludedTag.clear();
  }

  Widget buildPost(index) {
  return Container(
    child: ListTile(
            title: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(filterHtml(posts[index].title.rendered), style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              )
            ),
            subtitle: Column(
              children: <Widget>[
                buildImage(index),
                Divider(thickness: 0, height: 5.0, color: Colors.transparent),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(posts[index].date.substring(0,10)),
                  ),
                Divider(thickness: 0, height: 5.0, color: Colors.transparent,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(filterHtml(posts[index].excerpt.rendered))
                )
            ],
          ),
          onTap: (){
            passTitle = Text(posts[index].title.rendered, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),);
            passDate = Text(posts[index].date.substring(0,10));
            postContent = Text(filterHtml(posts[index].content.rendered.toString()));
            passImage = buildImage(index);
            Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => PostDetailPage()),
          );
        },
      )
    );
  }

  Widget buildImage(int index) {
    if (posts[index].featuredMedia == null) {
      return Image.asset("images/placeholder.png");
    }else{
    return Image.network(
      posts[index].featuredMedia.mediaDetails.sizes.thumbnail.sourceUrl);
    }
  }

  String filterHtml(String inputText) {

    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );
    return inputText.replaceAll(exp, '');
  }

  Future<String> getPosts() async {
    setState((){
      isLoading = true;
    });

    var res = await fetchPosts();

    if(res.isNotEmpty){
    isLoading = false;
    setState(() {
      posts = res;
    });
    }else if (res.isEmpty){
      isLoading = false;
      Center(
        child: Text("Gagal mendapatkan Posts"),
      );
    }
    return "Success!";
  } 

  List<wp.Post> posts;

  Future<List<wp.Post>> fetchPosts() async {
    var posts = wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        postStatus: wp.PostPageStatus.publish,
        orderBy: wp.PostOrderBy.date,
        order: wp.Order.desc,
        includeCategories: includedTag,
      ),
      fetchAuthor: true,
      fetchFeaturedMedia: true,
      fetchCategories: true,
      fetchAttachments: true,
    );
    return posts;
  }

  List<wp.Category> postTags;
  Future<List<wp.Category>> fetchCategories() async {
    var postTags = wordPress.fetchCategories(
        params: wp.ParamsCategoryList(
      hideEmpty: true,
    ));
    return postTags;
  }

  Future<String> getTags() async {
    var res = await fetchCategories();
    setState(() {
      postTags = res;
    });
    return "Success!";
  }
}
