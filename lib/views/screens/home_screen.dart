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
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 50,
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
                        tabs: const [
                          Tab(
                            text: '435 Abonnements',
                          ),
                          Tab(
                            text: '1950 Abonnés',
                          )
                        ],
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 310,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                ...mainViewModel.users.map(
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
                          const Text('Person'),
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
