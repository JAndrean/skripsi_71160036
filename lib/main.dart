import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

import 'berita_tag_1.dart';
import 'post_detail_page.dart';

final _root = 'http://localhost/anekozawa'; //replace with your site url
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);
int selectedIndex;
String passTitle, passDate, passExcerpt;
Widget passImage;

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
        '/': (context) => HomePage(),
        //'berita0': (context) => Berita0Page(),
        'berita1': (context) => Berita1Page(),
        'postDetail': (context) => PostDetailPage(),
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
  String title, date, excerpt;
  Widget image;

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
                title: Text('Beranda', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              ),
              Divider(thickness: 2.0,),
              ExpansionTile(
                title: Text('Berita'),
                children: <Widget>[
                  ListTile(
                    subtitle: Text('Uncategorized'),
                    /*onTap: (){
                      Navigator.pushNamed(context, 'berita0');
                    }*/
                  ),
                  ListTile(
                    subtitle: Text('Tag 1'),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Berita1Page()),
                      );
                    },
                  ),
                  ListTile(
                    subtitle: Text('Tag 2')
                    ),
                ],
              ),
              Divider(thickness: 2.0, indent: 5.0,),
              ListTile(
                title: Text('Profil Klasis dan Jemaat')
              ),
            ],
        )
      ),
      appBar: AppBar(
        title: Text('Sinode GKJ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPost(index); //Building the posts list view
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  List<int> _selectedIndex = [];

  void checkSelectedIndex(int index){
    if (_selectedIndex.contains(index))
      setState(() => _selectedIndex.remove(index));
    else
      setState(() => _selectedIndex.add(index));
  }

  Widget buildPost(int index) {
  return InkWell(
    splashColor: Colors.blue.withAlpha(60),
    child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(posts[index].title.rendered,)
            ),
            subtitle: Column(
              children: <Widget>[
                buildImage(index),
                Text(posts[index].date.substring(0,10)),
                Text(filterHtml(posts[index].excerpt.rendered)),
            ],
          ),
          onTap: (){
            checkSelectedIndex(index);
            passTitle = posts[_selectedIndex.first].title.rendered;
            passDate = posts[_selectedIndex.first].date.substring(0,10);
            passExcerpt = filterHtml(posts[_selectedIndex.first].excerpt.rendered);
            passImage = buildImage(_selectedIndex.first);
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
      return Image.network(
        "Post has no Image",
      );
    }
    return Image.network(
      posts[index].featuredMedia.mediaDetails.sizes.thumbnail.sourceUrl, 
    );
  }

  String filterHtml(String inputText) {
    return inputText.substring(3, inputText.length-5);
  }

  Future<String> getPosts() async {
    var res = await fetchPosts();
    setState(() {
      posts = res;
    });
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
      ),
      fetchAuthor: true,
      fetchFeaturedMedia: true,
      fetchCategories: true,
    );
    return posts;
  }
}
