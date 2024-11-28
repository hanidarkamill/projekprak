import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCakeScreen extends StatefulWidget {
  const AddCakeScreen({Key? key}) : super(key: key);

  @override
  _AddCakeScreenState createState() => _AddCakeScreenState();
}

class _AddCakeScreenState extends State<AddCakeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  List<String> _cakeTitles = [];
  List<String> _cakeDescriptions = [];
  List<String> _cakeImages = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadCakes();
  }

  Future<void> _loadCakes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cakeTitles = prefs.getStringList('cakeTitles') ?? [];
      _cakeDescriptions = prefs.getStringList('cakeDescriptions') ?? [];
      _cakeImages = prefs.getStringList('cakeImages') ?? [];
    });
  }

  Future<void> _addCake() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final imageUrl = _imageController.text;

    if (title.isNotEmpty && description.isNotEmpty && imageUrl.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();

      if (_editingIndex != null) {
        _cakeTitles[_editingIndex!] = title;
        _cakeDescriptions[_editingIndex!] = description;
        _cakeImages[_editingIndex!] = imageUrl;
        _editingIndex = null;
      } else {
        _cakeTitles.add(title);
        _cakeDescriptions.add(description);
        _cakeImages.add(imageUrl);
      }

      await prefs.setStringList('cakeTitles', _cakeTitles);
      await prefs.setStringList('cakeDescriptions', _cakeDescriptions);
      await prefs.setStringList('cakeImages', _cakeImages);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editingIndex != null ? 'Cake Edited: $title' : 'Cake Added: $title')),
      );

      _titleController.clear();
      _descriptionController.clear();
      _imageController.clear();
      _loadCakes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  Future<void> _deleteCake(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cakeTitles.removeAt(index);
      _cakeDescriptions.removeAt(index);
      _cakeImages.removeAt(index);
    });
    await prefs.setStringList('cakeTitles', _cakeTitles);
    await prefs.setStringList('cakeDescriptions', _cakeDescriptions);
    await prefs.setStringList('cakeImages', _cakeImages);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cake Deleted')),
    );
  }

  void _editCake(int index) {
    setState(() {
      _titleController.text = _cakeTitles[index];
      _descriptionController.text = _cakeDescriptions[index];
      _imageController.text = _cakeImages[index];
      _editingIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Cake'),
        backgroundColor: const Color(0xFFD32F2F), // main color
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFFFFEBEE), // Light pink background for the whole screen
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Cake Title Field
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Cake Title',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.pink.shade100, // Light pink for the form field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Cake Description Field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Cake Description',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.pink.shade100, // Light pink for the form field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Image URL Field
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.pink.shade100, // Light pink for the form field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Add/Edit Cake Button
                  ElevatedButton(
                    onPressed: _addCake,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFd32f2f), // Button color
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Add Cake', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cake List
            Expanded(
              child: _cakeTitles.isEmpty
                  ? const Center(
                      child: Text(
                        'No cakes added yet!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _cakeTitles.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 6,
                          color: const Color(0xFFFFEBEE), // Light pink for the list card
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _cakeImages[index],
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            title: Text(
                              _cakeTitles[index],
                              style: const TextStyle(
                                color: Color(0xFFD32F2F), // Title color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _cakeDescriptions[index],
                              style: const TextStyle(color: Colors.black87),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editCake(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCake(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}