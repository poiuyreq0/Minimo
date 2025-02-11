import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/screens/post/post_detail_screen.dart';
import 'package:minimo/utils/time_stamp_util.dart';

class PostElementComponent extends StatelessWidget {
  final PostModel post;

  const PostElementComponent({
    required this.post,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PostDetailScreen(post: post),)
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              post.postContent.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 5),
            Text(
              post.postContent.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.thumbsUp,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 12,
                ),
                Text(
                  ' ${post.likeNum}  |  ',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                FaIcon(
                  FontAwesomeIcons.comment,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 12,
                ),
                Text(
                  ' ${post.commentNum}  |  ',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  '${post.writerNickname}  |  ',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  TimeStampUtil.getElementTimeStamp(post.createdDate),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
