import 'package:flutter/material.dart';

// Text input, password visibility toggle, form validation, and form state (all change states when user interacts with the form, so we need a StatefulWidget)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// a) This is whats created before the widget is built. It holds the mutable state for the LoginScreen widget.
class _LoginScreenState extends State<LoginScreen> {

  bool _passHidden = true; // password visibility toggle (true means password is hidden initially)

  // there could be multiple forms in a screen, this assigns a unique key each form.
  // It calls the validator functions for all the fields in the form.
  final _formKey = GlobalKey<FormState>(); // key to identify the form

  // an object used for extracting data from text fields (ready to capture user input)
  final  _usernameController = TextEditingController(); // _usernameController.text will store and give the current value of the username field.
  final  _passwordController = TextEditingController(); // _passwordController.text will store and give the current value of the password field.

  // b) This is what first gets rendered on the screen when the LoginScreen widget is created. It describes the UI of the login screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                _loginButton(),
              ],
              ),
          ),
        ),
      ),
    );
  } // build

  // _ for private methods
  Widget _header() {
    return const Text('Welcome back',
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _username() {
    return TextFormField(
      controller: _usernameController, // TODO: add controller (Text input is captured by usernameController)
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
      }, // TODO: add validation logic
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _passwordController, // TODO: add controller (Text input is captured by passwordController)
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
        return null;
      },
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: _submitLogin, // If user taps the button, call the _submitLogin function to validate the form and proceed with login if valid
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Log In'),
    );
  }

  void _submitLogin() {
    // call all validator functions of the form fields
    // I'm certain currentState is not going to be null because the button is inside the form
    if (_formKey.currentState!.validate()) { // Flutter find the form using the key and calls the validator functions (_username and _password). If any validator returns a string, the form is not valid and the error message is displayed. If all validators return null, the form is valid and we can proceed with login.
      final username = _usernameController.text;
      final password = _passwordController.text;

      // If the form is valid, we can proceed with login. For now, we'll just show a snackbar and a dialog with the username and password length (not secure to show password, so we just show the length for demonstration purposes).
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in as $username')), // finds the nearest Scaffold widget and displays a snackbar at the bottom of the screen (temporary message that disappears after a few seconds)
      );

      // String password = _passwordController.text;

      // this just shows a dialog with the username after successful login for now.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Successful'),
          content: Text('Welcome, $username!\nPassword length: ${password.length}'), // display username and password length (not password itself for debugging) in the dialog
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // close the dialog when user taps OK
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

} 