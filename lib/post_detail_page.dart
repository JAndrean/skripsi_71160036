import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'berita_tag.dart';
import 'main.dart';

final _root = 'http://localhost/sinode'; //replace with your site url
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      //'berita0': (context) => Berita0Page(),
      'berita1': (context) => BeritaTagPage(),
      'postDetail': (context) => PostDetailPage(),
    },
    ));
} //App Entry Point

class PostDetailPage extends StatefulWidget {
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

//Beranda
class _PostDetailPageState extends State<PostDetailPage> {

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
                title: Text('Beranda'),
                onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
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
                      includedTag.clear();
                      excludedTag.clear();
                      includedTag.add(2);
                      excludedTag.addAll([1,3]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BeritaTagPage()),
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
      body: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(passTitle)
            ),
            subtitle: Column(
              children: <Widget>[
                passImage,
                Text(passDate),
                Text(passExcerpt),
            ],
          ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  /*Widget buildPost(index) {
    return Column(
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(posts[index].date.substring(0, 10),
                              style: TextStyle(fontSize: 12))),
                  subtitle:  Text(filterHtml(posts[index].excerpt.rendered),
                              style: TextStyle(fontSize: 16)),
                  )
              )
            ],
          ),
        )
      ],
    );
  }*/

  Widget buildImage(int index) {
    if (posts[index].featuredMedia == null) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text("Post has no Image"),
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
