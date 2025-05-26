import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'FamilyPuzzle.dart';

class Familyphoto extends StatefulWidget {
  const Familyphoto({super.key});

  @override
  State<Familyphoto> createState() => _FamilyphotoState();
}

class _FamilyphotoState extends State<Familyphoto> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image; // Variable to store selected image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _continue() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _image != null) {
      // Pass the image, title, and description to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextPage(
            title: _titleController.text,
            description: _descriptionController.text,
            image: _image!,
          ),
        ),
      );
    } else {
      // Show a message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields and select an image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Photo Puzzle',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Title Input
              Text('Photo Title', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter photo title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 20),

              // Description Input
              Text('Description', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                maxLines: 4, // Allow multiple lines for the description
              ),
              SizedBox(height: 20),

              // Image Picker
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image, size: 18),
                    label: Text('Select Image', style: GoogleFonts.poppins(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  SizedBox(width: 10),
                  if (_image != null)
                    Text(
                      'Image Selected',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              SizedBox(height: 20),

              // Display selected image preview if any
              if (_image != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _continue,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Continue',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
