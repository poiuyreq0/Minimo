import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/post_element_component.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = context.read<PostProvider>();
    final userId = context.read<UserProvider>().userCache!.id;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
              postProvider.getPostsWithPaging(userId: userId, count: 20, isFirst: false);
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                BannerAdComponent(
                  padding: 16,
                ),
                const SizedBox(height: 16),
                Selector<PostProvider, bool>(
                  selector: (context, postProvider) => postProvider.postListScreenNewPostsSelectorTrigger,
                    builder: (context, _, child) {
                    return FutureBuilder<List<PostModel>>(
                      future: postProvider.getPostsWithPaging(userId: userId, count: 20, isFirst: true),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        } else if (snapshot.data!.isEmpty) {
                          return Text(
                            '아직 게시글이 없습니다.',
                            style: AppStyle.getHintTextStyle(context),
                          );
                        } else {
                          return Selector<PostProvider, bool>(
                            selector: (context, postProvider) => postProvider.postListScreenPreviousPostsSelectorTrigger,
                            builder: (context, _, child) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return PostElementComponent(post: snapshot.data![index]);
                                },
                              );
                            }
                          );
                        }
                      },
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
