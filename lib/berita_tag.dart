import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'main.dart';

final _root = 'http://localhost/sinode'; //replace with your site url
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/beranda': (context) => HomePage(),
      'beritaTagged': (context) => BeritaTagPage(),
    },
    ));
} //App Entry Point

//Page Class
class BeritaTagPage extends StatefulWidget {
  @override
  _BeritaTagPageState createState() => _BeritaTagPageState();
}

//Beranda
class _BeritaTagPageState extends State<BeritaTagPage> {
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
                    subtitle: Text('Tag 1', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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
    this.getTags();
  }

  Widget buildPost(int index) {
    return Column(
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              Text(posts[index].title.rendered,
              style: TextStyle(fontWeight: FontWeight.bold,
               fontSize: 20, 
               fontFamily: 'Arial')),
              buildImage(index),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(posts[index].date.substring(0, 10),
                              style: TextStyle(fontSize: 12))),
                  subtitle:  Text(filterHtml(posts[index].excerpt.rendered),
                              style: TextStyle(fontSize: 16))
                  )
              )
            ],
          ),
        )
      ],
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
        includeCategories: includedTag,
        excludeCategories: excludedTag
      ),
      fetchAuthor: true,
      fetchFeaturedMedia: true,
      fetchCategories: true,
    );
    return posts;
  }

  List<wp.Category> postTags;
  Future<List<wp.Category>> fetchCategories() async {
    var tags = wordPress.fetchCategories(
        params: wp.ParamsCategoryList(
      hideEmpty: true,
    ));
    return tags;
  }

    Future<String> getTags() async {
    var res = await fetchCategories();
    setState(() {
      postTags = res;
      // Just to confirm that we are getting the categories form the server
      postTags.forEach((element) {
        print(element.toJson());
      });
    });
    return "Success!";
  }
}
