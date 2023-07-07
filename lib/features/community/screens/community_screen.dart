import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(BuildContext context, WidgetRef ref, Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('r/$name'),
        // ),
        body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
                  headerSliverBuilder: ((context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                          leading: IconButton(
                            onPressed: () =>
                                Routemaster.of(context).history.back(),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          expandedHeight: 150,
                          floating: true,
                          snap: true,
                          flexibleSpace: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  community.banner,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          )),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'r/${community.name}',
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              community.mods.contains(user!.uid)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        navigateToModTools(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: const Text('Mod Tools'),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        joinCommunity(context, ref, community);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? "Joined"
                                              : "Join")),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                                '${community.members.length.toString()} members'),
                          )
                        ])),
                      )
                    ];
                  }),
                  body: ListView(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                        ),
                        title: Text(community.name),
                      )
                    ],
                  ),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()));
  }
}
