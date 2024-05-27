import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          gradient: const LinearGradient(
            colors: [
              // Color.fromARGB(158, 105, 240, 175),

              Color.fromARGB(127, 5, 37, 73),
              Color.fromARGB(129, 64, 195, 255),
            ], // Adjust colors as needed
            begin: Alignment.topLeft,
            end: Alignment.bottomRight, // Adjust gradient direction as needed
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            // Add logic to handle search button tap
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 30.0),
            backgroundColor: Colors.transparent,
            foregroundColor: const Color.fromARGB(118, 255, 255, 255),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.search,
                size: 20,
              ),
              SizedBox(width: 10.0),
              Text('Search Music'),
            ],
          ),
        ),
      ),
    );
  }
}
