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
      'beritaTagged': (context) => BeritaTagPage(),
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
                    onTap: (){
                      selectedCategory = 1;
                      resetTags();
                      includedTag.add(1);
                      excludedTag.add(2);
                      excludedTag.add(3);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BeritaTagPage()),
                      );
                    },
                  ),
                  ListTile(
                    subtitle: Text('Category 1'),
                     onTap: (){
                      selectedCategory = 2;
                       resetTags();
                       includedTag.add(2);
                       excludedTag.add(1);
                       excludedTag.add(3);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BeritaTagPage()),
                      );
                    },
                  ),
                  ListTile(
                    subtitle: Text('Category 2'),
                    onTap: (){
                      selectedCategory = 3;
                      resetTags();
                       includedTag.add(3);
                       excludedTag.add(1);
                       excludedTag.add(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BeritaTagPage()),
                      );
                    },
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
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: passTitle,
              )
            ),
            subtitle: Column(
              children: <Widget>[
                passImage,
                Divider(thickness: 0, height: 5.0, color: Colors.transparent),
                Align(
                  alignment: Alignment.centerLeft,
                  child: passDate,
                  ),
                Divider(thickness: 0, height: 5.0, color: Colors.transparent),
                Align(
                  alignment: Alignment.centerLeft,
                  child: passExcerpt,
                )
              ],
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
    this.getTags();
  }

  void resetTags(){
    if(includedTag.isNotEmpty && excludedTag.isNotEmpty)
    includedTag.clear();
    excludedTag.clear();
  }

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
