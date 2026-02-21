import 'package:flutter/material.dart';
import 'package:responsive_design/login_screen.dart';
import 'auth_service.dart'; // authentication service to handle login logic

// Text input, password visibility toggle, form validation, and form state (all change states when user interacts with the form, so we need a StatefulWidget)
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

// a) This is whats created before the widget is built. It holds the mutable state for the SignupScreen widget.
class _SignupScreenState extends State<SignupScreen> {

  bool _passHidden = true; // password visibility toggle (true means password is hidden initially)

  // there could be multiple forms in a screen, this assigns a unique key each form.
  // It calls the validator functions for all the fields in the form.
  final _formKey = GlobalKey<FormState>(); // key to identify the form

  // an object used for extracting data from text fields (ready to capture user input)
  final  _usernameController = TextEditingController(); // _usernameController.text will store and give the current value of the username field.
  final  _passwordController = TextEditingController(); // _passwordController.text will store and give the current value of the password field.

  bool _isLoading = false; // loading state to show a loading circle indicator when the login process is happening
  final _authService = AuthService(); // instance of the authentication service to handle login logic (not implemented yet)

  // b) This is what first gets rendered on the screen when the SignupScreen widget is created. It describes the UI of the signup screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form( // form widget that holds the state of the form fields
            key: _formKey, // ID for a particular form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // center vertically
              crossAxisAlignment: CrossAxisAlignment.stretch, // stretch to fill width
              children: [
                _header(),
                const SizedBox(height: 40),
                _username(),
                const SizedBox(height: 20),
                _password(),
                const SizedBox(height: 40),
                // if _isLoading is true, show a loading (spinning circle) indicator, otherwise show the login button
                _isLoading ? const Center(child: CircularProgressIndicator()) : _signUpButton(),
                TextButton( // button to navigate to the sign up screen 
                  onPressed: () {
                    Navigator.of(context).push( // navigate to the sign up screen
                      MaterialPageRoute(builder: (context) => const LoginScreen()), 
                    );
                  },
                  child: const Text("Already have an account? Log In"),
                ),
              ],
              ),
          ),
        ),
      ),
    );
  } // build

  // _ for private methods
  Widget _header() {
    return const Text('Welcome! \n Please sign up to continue...',
      style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _username() {
    return TextFormField(
      controller: _usernameController, // Text input is captured by usernameController)
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) { // check for null or empty string
          return 'Please enter your username';
        }
        return null; // input is valid
      }, 
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _passwordController, // Text input is captured by passwordController)
      obscureText: _passHidden, // hide the text being entered
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton( 
          icon: Icon(
            _passHidden ? Icons.visibility_off : Icons.visibility), // if hidden show off icon
          onPressed: () {
            setState(() { // If user taps the icon, call setState totoggle the boolean value and rebuild the widget to reflect the change
              _passHidden = !_passHidden;
            });
          }, // toggle password visibility
        ),
      ),
      // The validator function is called when the form is submitted. It checks if the password is valid and returns an error message if not. If the password is valid, it returns null.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }

        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Must contain at least one uppercase letter';
        }

        if (!RegExp(r'[a-z]').hasMatch(value)) {
          return 'Must contain at least one lowercase letter';
        }

        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Must contain at least one digit';
        }

        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
          return 'Must contain at least one symbol';
        }

        return null;
      },

    );
  }

  Widget _signUpButton() {
    return ElevatedButton(
      onPressed: _submitSignUp, // If user taps the button, call the _submitSignUp function to validate the form and proceed with sign up if valid
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Sign Up'),
    );
  }

  void _submitSignUp() async {
    // call all validator functions of the form fields
    // ! means: I'm certain currentState is not going to be null because the button is inside the form
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true); // set loading state to true to show the progress indicator

    { // Flutter find the form using the key and calls the validator functions (_username and _password). If any validator returns a string, the form is not valid and the error message is displayed. If all validators return null, the form is valid and we can proceed with login.
      final username = _usernameController.text;
      final password = _passwordController.text;

    try {
      await _authService.signUp(email: username, password: password);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    finally {
      if (!mounted) { // stop the spinning widget if the user navigates away from the login screen before the login process completes
      setState(() => _isLoading = false); // set loading state to false to hide the progress indicator
      }
    }
    } // submitSignUp

  } 
}