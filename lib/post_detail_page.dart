import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'main.dart';

final _root = 'https://sinodegkj.or.id';
final wp.WordPress wordPress = wp.WordPress(baseUrl: _root);

class PostDetailPage extends StatefulWidget {
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

//Beranda
class _PostDetailPageState extends State<PostDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: postContent,
                )
              ],
            ),
          )
        ],
      ),
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

    //mengambil list tag dan memunculkannya ke konsol debugging
    Future<String> getTags() async {
    var res = await fetchCategories();
    setState(() {
      postTags = res;
      postTags.forEach((element) {
        print(element.toJson());
      });
    });
    return "Success!";
  }
}
