import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomuser/view_models/main_view_model.dart';
import 'package:randomuser/views/screens/profile_update_screen.dart';
import 'package:randomuser/views/screens/search_screen.dart';
import 'package:randomuser/views/widgets/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel = context.watch<MainViewModel>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("Profil aléatoire"),
                  onTap: () async {
                    await mainViewModel.getRandomUser();
                  },
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Mettre à jour le profil"),
                ),
                PopupMenuItem(
                  child: const Text("Utilisateurs aléatoires"),
                  onTap: () async {
                    await mainViewModel.fetchUsersFromAPI();
                  },
                ),
                PopupMenuItem(
                  child: const Text("Effacer la BD"),
                  onTap: () async {
                    await mainViewModel.clearDB();
                  },
                ),
              ];
            },
            onSelected: (value) {
              if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileUpdateScreen(),
                  ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
        child: const Icon(Icons.search_rounded),
      ),
      body: Column(
        children: [
          mainViewModel.profileLoading
              ? const SizedBox(
                  height: 161,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : // profile picture
              Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: CircleAvatar(
                        radius: 50 - 2,
                        backgroundColor: Colors.deepPurple[300],
                        child: ClipOval(
                          child: Image.network(
                            mainViewModel.profile.picture,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.deepPurple[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // personal info
                    Text(
                      "@${mainViewModel.profile.username}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "(${mainViewModel.profile.firstName} ${mainViewModel.profile.lastName})",
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),

          // following and followers tabs
          mainViewModel.loading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height - 260,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.deepPurple,
                        tabs: [
                          Tab(
                            text:
                                '${mainViewModel.following.length} Abonnements',
                          ),
                          Tab(
                            text: '${mainViewModel.followers.length} Abonnés',
                          )
                        ],
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 315,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                ...mainViewModel.following.map(
                                  (e) => UserCard(
                                    user: e,
                                  ),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                ...mainViewModel.followers.map(
                                  (e) => UserCard(
                                    user: e,
                                  ),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
