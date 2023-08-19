import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to Smart Irrigation System ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              Text(
                ' where technology meets sustainability to redefine agricultural practices. We are a passionate team of engineers, environmentalists, and forward-thinkers dedicated to revolutionizing the way irrigation is approached with our Smart Irrigation System powered by Solar Water Desalination.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'At Smart Irrigation System,we envision a world where agricultural endeavors thrive in harmony with nature. We believe that harnessing the power of cutting-edge technology and renewable energy sources can pave the way for a sustainable future, ensuring abundant crop yields while minimizing the environmental impact',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Who We Are',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'We are a multidisciplinary team of experts who share a common goal: to address the pressing challenges faced by farmers and agricultural communities worldwide. Our team comprises engineers with a deep understanding of automation, solar energy, and water treatment technologies, as well as ecologists and agronomists who comprehend the intricate relationships between agriculture and the ecosystem.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Repeat the structure for other sections

              // Contact Information
              SizedBox(height: 20),
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '+967xxxxxxxxxx',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
