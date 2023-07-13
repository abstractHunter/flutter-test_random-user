import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomuser/view_models/main_view_model.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),

              // profile picture
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/1.jpg"),
                radius: 70,
              ),

              const SizedBox(height: 12),

              // personal info
              const Text(
                "@john_doe",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "(John Doe)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),

              // stats
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "435",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Abonnements",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "1,950",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Abonnés",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // following and followers tabs
              const SizedBox(height: 12),

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
                height: MediaQuery.of(context).size.height - 90,
                child: Expanded(
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
                          ],
                        ),
                      ),
                      const Text('Person'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
