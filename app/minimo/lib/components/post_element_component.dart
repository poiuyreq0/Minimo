import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/screens/post/post_detail_screen.dart';
import 'package:minimo/styles/app_style.dart';
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
              style: AppStyle.getLargeTextStyle(context, 16),
            ),
            const SizedBox(height: 5),
            Text(
              post.postContent.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.getMediumTextStyle(context, 14),
            ),
            const SizedBox(height: 5),
            IntrinsicHeight(
              child: Row(
                children: [
                  const SizedBox(width: 2),
                  FaIcon(
                    FontAwesomeIcons.thumbsUp,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.likeNum}',
                    style:AppStyle.getSmallTextStyle(context, 12),
                  ),
                  const VerticalDivider(
                    thickness: 1.2,
                    indent: 3,
                    endIndent: 3,
                  ),
                  FaIcon(
                    FontAwesomeIcons.comment,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentNum}',
                    style:AppStyle.getSmallTextStyle(context, 12),
                  ),
                  const VerticalDivider(
                    thickness: 1.2,
                    indent: 3,
                    endIndent: 3,
                  ),
                  Text(
                    '${post.writerNickname}',
                    style:AppStyle.getSmallTextStyle(context, 12),
                  ),
                  const VerticalDivider(
                    thickness: 1.2,
                    indent: 3,
                    endIndent: 3,
                  ),
                  Text(
                    TimeStampUtil.getElementTimeStamp(post.createdDate),
                    style:AppStyle.getSmallTextStyle(context, 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
