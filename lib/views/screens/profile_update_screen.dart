import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomuser/view_models/main_view_model.dart';
import 'package:randomuser/views/widgets/custom_text_field.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  void initialize() {
    MainViewModel mainViewModel = context.read<MainViewModel>();
    usernameController.text = mainViewModel.profile.username;
    firstNameController.text = mainViewModel.profile.firstName;
    lastNameController.text = mainViewModel.profile.lastName;
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const CircleAvatar(
                    radius: 50,
                    child: Text("Photo"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: usernameController,
                    hintText: "Nom",
                    labelText: "Nom",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: firstNameController,
                    hintText: "Prénom",
                    labelText: "Prénom",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: lastNameController,
                    hintText: "Nom de famille",
                    labelText: "Nom de famille",
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          MainViewModel mainViewModel =
                              context.read<MainViewModel>();
                          mainViewModel.profile.username =
                              usernameController.text;
                          mainViewModel.profile.firstName =
                              firstNameController.text;
                          mainViewModel.profile.lastName =
                              lastNameController.text;
                          await mainViewModel
                              .saveUserProfile(mainViewModel.profile);
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 44,
                        width: 80,
                        child: const Text("Enregistrer"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
