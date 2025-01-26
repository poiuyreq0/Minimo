import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/post_element_component.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = context.read<PostProvider>();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 8),
            BannerAdComponent(
              padding: 16,
            ),
            const SizedBox(height: 16),
            Selector<PostProvider, bool>(
              selector: (context, postProvider) => postProvider.postListScreenSelectorTrigger,
              builder: (context, _, child) {
                return FutureBuilder<List<PostModel>>(
                  future: postProvider.getPosts(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.data!.isEmpty) {
                      return Text(
                        '아직 게시글이 없습니다.',
                        style: Theme.of(context).textTheme.titleSmall,
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return PostElementComponent(post: snapshot.data![index]);
                        },
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
