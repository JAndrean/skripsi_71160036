import 'package:anekozawa/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'main.dart';

final _root = 'http://localhost/sinode'; //replace with your site url
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);

List<int> includedTag = [0];
List<int> excludedTag = [0];
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/beranda': (context) => HomePage(),
      'beritaTagged': (context) => BeritaTagPage(),
      'postDetail': (context) => PostDetailPage()
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
    if(selectedCategory == 1){
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
                    subtitle: Text('Uncategorized', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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
                        MaterialPageRoute(builder: (context) => BeritaTagPage())
                      );
                    }
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
                        MaterialPageRoute(builder: (context) => BeritaTagPage())
                      );
                    }
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
      body: isLoading ? 
      Center(
        child: CircularProgressIndicator()
      ):
      ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPost(index); //Building the posts list view
        },
      ),
    );
    }else if(selectedCategory == 2){
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
                        MaterialPageRoute(builder: (context) => BeritaTagPage())
                      );
                    }
                  ),
                  ListTile(
                    subtitle: Text('Category 1', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))
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
                        MaterialPageRoute(builder: (context) => BeritaTagPage())
                      );
                    }
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
      body: isLoading ? 
      Center(
        child: CircularProgressIndicator()
      ):
      ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPost(index); //Building the posts list view
        },
      ),
    );
    }else if(selectedCategory == 3){
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
                        MaterialPageRoute(builder: (context) => BeritaTagPage())
                      );
                    }
                  ),
                  ListTile(
                    subtitle: Text('Category 1'),
                    onTap: (){
                      selectedCategory = 1;
                      resetTags();
                      includedTag.add(2);
                      excludedTag.add(1);
                      excludedTag.add(3);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => BeritaTagPage())
                      );
                    }
                  ),
                  ListTile(
                    subtitle: Text('Category 2', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))
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
      body: isLoading ? 
      Center(
        child: CircularProgressIndicator()
      ):
      ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return buildPost(index); //Building the posts list view
        },
      ),
    );
    }
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
    this.getTags();
  }

  Widget buildPost(int index) {
    return InkWell(
    splashColor: Colors.blue.withAlpha(60),
    child: ListTile(
            title: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(posts[index].title.rendered, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  child: Text(filterHtml(posts[index].excerpt.rendered)),
                )
            ],
          ),
          onTap: (){
            checkSelectedIndex(index);
            passTitle = Text(posts[_selectedIndex.first].title.rendered, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),);
            passDate = Text(posts[_selectedIndex.first].date.substring(0,10));
            passExcerpt = Text(filterHtml(posts[_selectedIndex.first].content.rendered));
            passImage = buildImage(_selectedIndex.first);
            Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => PostDetailPage()),
          );
        },
      )
    );
  }

  void resetTags(){
    if(includedTag.isNotEmpty && excludedTag.isNotEmpty)
    includedTag.clear();
    excludedTag.clear();
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
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );

    return inputText.replaceAll(exp, '');
  }

  List<int> _selectedIndex = [];

  void checkSelectedIndex(int index){
    if (_selectedIndex.isNotEmpty){
      setState(() => _selectedIndex.clear());
      setState(() => _selectedIndex.add(index));
    }
    else{
      setState(() => _selectedIndex.add(index));
    }
  }

  Future<String> getPosts() async {
    setState((){
      isLoading = true;
    });

    var res = await fetchPosts();
    setState(() {
      posts = res;
      isLoading = false;
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
