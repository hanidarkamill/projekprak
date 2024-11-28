import 'package:flutter/material.dart';
import 'package:projek3/model/cake_model.dart';
import 'package:projek3/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cake_detail_screen.dart';
import 'login_screen.dart';
import 'add_cake_screen.dart'; // Ensure you have an AddCakeScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<CakeModel> _cakeData;
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  List<Cakes> _filteredCakes = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _cakeData = ApiService().fetchCakeData(query: '');
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _searchCakes(String query) async {
    final cakeModel = await ApiService().fetchCakeData(query: query);
    final cakes = cakeModel.cakes ?? [];
    setState(() {
      _filteredCakes = cakes
          .where((cake) => cake.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

Widget _buildHomePage() {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xFFF8C9D5), // Very light pink color (almost white)
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: _searchCakes,
            decoration: InputDecoration(
              labelText: 'Search Cake',
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true, // Set filled to true
              fillColor: Colors.white, // Set the background color to white
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        FutureBuilder<CakeModel>(
          future: _cakeData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data?.cakes == null) {
              return const Center(child: Text('No data available'));
            } else {
              List<Cakes> cakes = _filteredCakes.isEmpty
                  ? snapshot.data!.cakes!
                  : _filteredCakes;
              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cakes.length,
                  itemBuilder: (context, index) {
                    final cake = cakes[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 8,
                      shadowColor: const Color.fromARGB(255, 251, 68, 129).withOpacity(0.3),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CakeDetailScreen(cake: cake),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white, // White background for cards
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  cake.image ?? '',
                                  fit: BoxFit.cover,
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cake.title ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cake.previewDescription ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 244, 50, 114)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}

  Widget _buildProfileAndFeedbackPage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD81B60), // Main Red Color
            Colors.white, // White
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 1.0], // Adjust the stops for a smoother transition
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile 1
          _buildProfileCard(
            'Tari Azari',
            '124220001',
            '124220001@student.upnyk.ac.id',
            'assets/tari.jpg',
          ),
          const SizedBox(height: 18),
          // Profile 2
          _buildProfileCard(
            'Hanidar Raffilia Kamil',
            '124220019',
            '124220019@student.upnyk.ac.id',
            'assets/kamil.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String name, String nim, String email, String imagePath) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 237, 57, 117),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'NIM: $nim',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            Text(
              'Email: $email',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      _buildProfileAndFeedbackPage(),
      AddCakeScreen(), // Ensure there's an AddCakeScreen for adding cakes
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: const Color(0xFFD81B60), // Main Red Color
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Cake',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 250, 74, 133),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
