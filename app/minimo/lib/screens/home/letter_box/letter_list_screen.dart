import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/letter_element_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LetterListScreen extends StatelessWidget {
  final String title;
  final String helpText;
  final LetterState letterState;
  final UserRole userRole;

  const LetterListScreen({
    required this.title,
    required this.helpText,
    required this.letterState,
    required this.userRole,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    LetterProvider letterProvider = context.read<LetterProvider>();
    final userId = context.read<UserProvider>().userCache!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('편지 목록'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent) {
              letterProvider.getLettersByUserWithPaging(userId: userId, userRole: userRole, letterState: letterState, count: 20, isFirst: false);
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TitleComponent(
                  title: title,
                  helpText: helpText,
                ),
              ),
              const SizedBox(height: 8),
              BannerAdComponent(
                padding: 16,
              ),
              const SizedBox(height: 16),
              Selector<LetterProvider, bool>(
                selector: (context, letterProvider) => letterProvider.letterListScreenNewLettersSelectorTrigger,
                builder: (context, _, child) {
                  return FutureBuilder<List<LetterModel>>(
                    future: letterProvider.getLettersByUserWithPaging(userId: userId, userRole: userRole, letterState: letterState, count: 20, isFirst: true),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      } else if (snapshot.data!.isEmpty) {
                        return Text(
                          '아직 편지가 없습니다.',
                          style: Theme.of(context).textTheme.titleSmall,
                        );
                      } else {
                        return Selector<LetterProvider, bool>(
                          selector: (context, letterProvider) => letterProvider.letterListScreenPreviousLettersSelectorTrigger,
                          builder: (context, _, child) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return LetterElementComponent(
                                  letter: snapshot.data![index],
                                  userRole: userRole,
                                );
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
    );
  }
}
