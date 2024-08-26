import 'package:OpenForge/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedLocation;
    bool _obscureText = true;
      void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  final List<String> _locations = ['Bangalore', 'Delhi'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _selectedLocation = prefs.getString('location');
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setString('location', _selectedLocation ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'OpenForge Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
             const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration:const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
            const  SizedBox(height: 16.0),
       TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        border:const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    ),
            const  SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                hint:const Text('Select Location'),
                items: _locations.map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
                decoration:const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 85, 3),
                    padding:const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await _savePreferences();

                      final username = _usernameController.text;
                      final password = _passwordController.text;
                      final location = _selectedLocation;

                      print('Username: $username');
                      print('Password: $password');
                      print('Location: $location');

                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                      
                    }
                  },
                  child:const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
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
