import 'package:flutter/cupertino.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository postRepository;
  List<PostModel> postsCache = [];
  bool postListScreenSelectorTrigger = true;

  PostProvider({
    required this.postRepository,
  })  : super();

  Future<void> createPost({
    required PostModel post,
  }) async {
    await postRepository.createPost(post: post);

    _refreshPostListScreenSelector();
  }

  // FutureBuilder
  Future<List<PostModel>> getPosts() async {
    late final DateTime lastDate;
    if (postsCache.isEmpty) {
      lastDate = DateTime.now();
    } else {
      lastDate = postsCache.last.createdDate;
    }

    final resp = await postRepository.getPosts(lastDate: lastDate);
    postsCache.addAll(resp);

    return postsCache;
  }

  void _refreshPostListScreenSelector() {
    postListScreenSelectorTrigger = !postListScreenSelectorTrigger;
    notifyListeners();
  }

  void logout() {
    postsCache = [];
  }
}