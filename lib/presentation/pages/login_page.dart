import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_example/core/utils/screen_utils.dart';
import 'package:flutter_firebase_example/presentation/core/themes/app_colors.dart';
import 'package:flutter_firebase_example/presentation/core/constants/app_images.dart';
import 'package:flutter_firebase_example/presentation/core/utils/textfield_styles.dart';
import 'package:flutter_firebase_example/domain/entities/user_entity.dart';
import 'package:flutter_firebase_example/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase_example/presentation/blocs/user/user_bloc.dart';
import 'package:flutter_firebase_example/presentation/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is Authenticated) {
            // Check if the user is new before adding
            if (state.isNewUser) {
              final userEntity = UserEntity(
                id: state.user.uid,
                name: state.user.displayName ?? "",
                age: 0,
                address: "100 Mountain View",
              );

              context.read<UserBloc>().add(AddUserEvent(userEntity));
            }

            // Navigate to HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          ImagePaths.logo,
                          height: ScreenUtils.height(percentage: 20, context:context),
                        ),
                        Flexible(
                          child: Text(
                            "SkillMentor Flutter Assistant",
                            style: TextStyle(
                                color: AppColors.darkPurpleBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: textfiledBackground(),
                      child: TextField(
                        controller: _emailController,
                        decoration:
                            customInputDecoration(hintText: "Enter email"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: textfiledBackground(),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: customInputDecoration(hintText: "Password"),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.2,
                          backgroundColor: AppColors.darkBluishPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                        ),
                        onPressed: () {
                          if (state is AuthInitial) {
                            if (state.isNewUser) {
                              context.read<AuthBloc>().add(
                                    SignupEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            } else {
                              context.read<AuthBloc>().add(
                                    LoginEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }
                          }
                        },
                        child: state is AuthLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : state is AuthInitial
                                ? Text(
                                    state.isNewUser ? 'SignUp' : 'SignIn',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox.shrink(),
                      ),
                    ),
                    SizedBox(
                      height:ScreenUtils.height(percentage: 10, context: context),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(ToggleAuthModeEvent());
                      },
                      child: state is AuthInitial
                          ? Text(
                              !state.isNewUser
                                  ? 'Don\'t have an account? Register'
                                  : 'Already have an account? Login',
                              style: TextStyle(
                                  color: AppColors.darkBluishPurple,
                                  fontSize: 13),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
