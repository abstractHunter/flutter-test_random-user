import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomuser/view_models/main_view_model.dart';
import 'package:randomuser/views/widgets/custom_text_field.dart';
import 'package:randomuser/views/widgets/user_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel = context.watch<MainViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                hintText: "Search",
                suffixIcon: const Icon(Icons.search),
                onChanged: (value) {
                  mainViewModel.searchUsers(value);
                },
              ),
            ),
            const SizedBox(height: 10),

            // search results
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...mainViewModel.filteredUsers.map((user) {
                      return UserCard(
                        user: user,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
