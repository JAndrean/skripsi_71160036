import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'main.dart';
import 'post_detail_page.dart';

final _root = 'https://sinodegkj.or.id';
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);


//Page Class
class BeritaPage extends StatefulWidget {
  @override
  _BeritaPageState createState() => _BeritaPageState();
}

//Beranda
class _BeritaPageState extends State<BeritaPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
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
      ),floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          setState(() {
            getPosts();
            getTags();
          });
        },
        label: Text('Muat Ulang', style: TextStyle(fontSize: 10)),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.blueAccent,
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
    return Container(
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
