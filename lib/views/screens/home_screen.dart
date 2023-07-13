import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomuser/view_models/main_view_model.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // profile picture
              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              const SizedBox(height: 12),

              // personal info
              const Text(
                "@john_doe",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "(John Doe)",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),

              // following and followers tabs
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
                height: MediaQuery.of(context).size.height - 270,
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
        ),
      ),
    );
  }
}
