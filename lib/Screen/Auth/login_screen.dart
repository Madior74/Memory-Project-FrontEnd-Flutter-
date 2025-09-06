import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_management_system/Screen/Admin/nouveau_admin.dart';
import 'package:school_management_system/Screen/Auth/auth_service.dart';
import 'package:school_management_system/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isVisible = true;

  bool _isLoading = false;
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = AuthService();
        final data = await authService.login(
          context,
          _emailController.text,
          _passwordController.text,
        );
        final role = data['user']['role'];
        // final user = data['user'];
        print("le role est de :$role");

        // Redirigez l'utilisateur en fonction de son rôle
        if (role == "ROLE_ETUDIANT") {
          Navigator.pushReplacementNamed(context, '/home-etudiant');
        } else if (role == "ROLE_PROFESSEUR") {
          Navigator.pushReplacementNamed(context, '/home-professeur');
        } else if (role == "ROLE_ADMIN") {
          Navigator.pushReplacementNamed(context, '/home-admin');
        } else {
          throw Exception('Rôle inconnu');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print("Erreur $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Connectez-Vous Pour Continuer",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 70.0, left: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/amico.svg",
                      height: MediaQuery.sizeOf(context).height / 1.3,
                      width: MediaQuery.sizeOf(context).width / 1.8,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),

              //Card Pour  le Login
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 70, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: MediaQuery.sizeOf(context).width / 3,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: const Icon(Icons.email),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      labelText: 'Mot de Passe',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isVisible = !isVisible;
                                          });
                                        },
                                        icon: Icon(isVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      prefixIcon: const Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  obscureText: isVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre mot de passe';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: myDrawerColol),
                                  onPressed: _isLoading ? null : _login,
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Se connecter',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Vous n'avez pas de compte ?",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterAdminScreen()),
                                        );
                                      },
                                      child: const Text("Créer un Admin"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
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
