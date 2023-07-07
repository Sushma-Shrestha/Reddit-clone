import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        // title to center
        centerTitle: true,
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        actions: [TextButton(onPressed: () {}, child: Text("Skip"))],
      ),
      body: isLoading
          ? const Loader()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(height: 30),
                Image.asset(
                  Constants.loginEmotePath,
                  height: 200,
                ),
                const SizedBox(height: 30),
                Text(
                  "Welcome to Reddit",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 30),
                Text(
                  "By continuing, you agree to our User Agreement and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 30),
                const SignInButton(),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {},
                  child: Text("Log in or sign up with email"),
                ),
              ]),
            ),
    );
  }
}
