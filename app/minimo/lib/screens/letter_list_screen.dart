import 'package:flutter/material.dart';
import 'package:minimo/components/letter_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/consts/letter_state.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/user_role_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LetterListScreen extends StatefulWidget {
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
  State<LetterListScreen> createState() => _LetterListScreenState();
}

class _LetterListScreenState extends State<LetterListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편지 목록'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TitleComponent(
                title: widget.title,
                helpText: widget.helpText,
              ),
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
            Consumer<LetterProvider>(
              builder: (context, letterProvider, child) {
                UserProvider userProvider = context.read<UserProvider>();
                return FutureBuilder(
                  future: letterProvider.getLetters(userRoleModel: UserRoleModel(id: userProvider.userCache!.id, userRole: widget.userRole), letterState: widget.letterState),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.data!.isEmpty) {
                      return Text(
                        '아직 편지가 없습니다.',
                        style: Theme.of(context).textTheme.titleSmall,
                      );
                    } else {
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return LetterComponent(
                            letter: snapshot.data![index],
                            userRole: widget.userRole,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            indent: 16,
                            endIndent: 16,
                          );
                        },
                      );
                    }
                  },
                );
              }
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
      ),
    );
  }
}