import 'package:flutter/cupertino.dart';
import 'package:minimo/models/comment_model.dart';
import 'package:minimo/models/like_model.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository postRepository;

  int? currentPostIdCache;
  List<PostModel> postsCache = [];
  PostModel? postCache;
  Map<int, LikeModel> commentLikeCache = {};

  bool postListScreenNewPostsSelectorTrigger = true;
  bool postListScreenPreviousPostsSelectorTrigger = true;
  bool postDetailScreenSelectorTrigger = true;
  bool postDetailScreenPostLikeSelectorTrigger = true;
  bool postDetailScreenCommentLikeSelectorTrigger = true;
  bool postDetailScreenBottomTextFormSelectorTrigger = true;

  PostProvider({
    required this.postRepository,
  })  : super();

  void exitPost() {
    currentPostIdCache = null;

    _refreshPostListScreenNewPostsSelector();
  }

  Future<void> createPost({
    required PostModel post,
  }) async {
    await postRepository.createPost(post: post);

    _refreshPostListScreenNewPostsSelector();
  }

  Future<void> deletePost({
    required int postId,
  }) async {
    await postRepository.deletePost(postId: postId);
  }

  Future<void> sendComment({
    required CommentModel comment,
  }) async {
    await postRepository.sendComment(comment: comment);

    _refreshPostDetailScreenSelector();
  }

  Future<void> deleteComment({
    required int commentId,
  }) async {
    await postRepository.deleteComment(commentId: commentId);

    _refreshPostDetailScreenSelector();
  }

  Future<List<PostModel>> getPostsWithPaging({
    required int userId,
    required int count,
    required bool isFirst,
    bool isPostMine = false,
    bool isCommentMine = false,
  }) async {
    DateTime? lastDate;
    if (isFirst) {
      lastDate = null;
    } else {
      if (postsCache.isEmpty) {
        lastDate = DateTime.now();
      } else {
        lastDate = postsCache.last.createdDate;
      }
    }

    final resp = await postRepository.getPostsWithPaging(userId: userId, count: 20, lastDate: lastDate, isPostMine: isPostMine, isCommentMine: isCommentMine);
    if (isFirst) {
      postsCache = resp;
    } else {
      postsCache.addAll(resp);
      _refreshPostListScreenPreviousPostsSelector();
    }

    return postsCache;
  }

  Future<PostModel> getPost({
    required int postId,
    required int userId
  }) async {
    currentPostIdCache = postId;

    final resp = await postRepository.getPost(postId: postId, userId: userId);
    commentLikeCache = {};
    postCache = resp;

    return postCache!;
  }

  Future<void> updatePostLikeNum({
    required int postId,
    required int userId,
  }) async {
    final resp = await postRepository.updatePostLikeNum(postId: postId, userId: userId);
    postCache = postCache!.copyWith(likeNum: resp.likeNum, isLikeSet: resp.isLikeSet);

    _refreshPostDetailScreenPostLikeSelector();
  }

  Future<void> updateCommentLikeNum({
    required int commentId,
    required int userId,
  }) async {
    final resp = await postRepository.updateCommentLikeNum(commentId: commentId, userId: userId);
    commentLikeCache[commentId] = resp;

    _refreshPostDetailScreenCommentLikeSelector();
  }

  void refreshPostDetailScreen() {
    _refreshPostDetailScreenSelector();
  }

  void refreshPostDetailScreenBottomTextForm() {
    _refreshPostDetailScreenBottomTextFormSelector();
  }

  void _refreshPostListScreenNewPostsSelector() {
    postListScreenNewPostsSelectorTrigger = !postListScreenNewPostsSelectorTrigger;
    notifyListeners();
  }

  void _refreshPostListScreenPreviousPostsSelector() {
    postListScreenPreviousPostsSelectorTrigger = !postListScreenPreviousPostsSelectorTrigger;
    notifyListeners();
  }

  void _refreshPostDetailScreenSelector() {
    postDetailScreenSelectorTrigger = !postDetailScreenSelectorTrigger;
    notifyListeners();
  }

  void _refreshPostDetailScreenPostLikeSelector() {
    postDetailScreenPostLikeSelectorTrigger = !postDetailScreenPostLikeSelectorTrigger;
    notifyListeners();
  }

  void _refreshPostDetailScreenCommentLikeSelector() {
    postDetailScreenCommentLikeSelectorTrigger = !postDetailScreenCommentLikeSelectorTrigger;
    notifyListeners();
  }

  void _refreshPostDetailScreenBottomTextFormSelector() {
    postDetailScreenBottomTextFormSelectorTrigger = !postDetailScreenBottomTextFormSelectorTrigger;
    notifyListeners();
  }

  void cleanCache() {
    postsCache = [];
    postCache = null;
    commentLikeCache = {};
  }
}