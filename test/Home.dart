import 'package:app/pages/DrawingActivity.dart';
import 'package:app/pages/FamilyPhoto.dart';
import 'package:app/pages/PerformanceChart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cognitive Activities',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Drawingactivity()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.draw,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Drawing Activity",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black.withAlpha(30),
              width: MediaQuery.of(context).size.width / 1.2,
              height: 1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Familyphoto()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Family Photo Puzzle",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black.withAlpha(30),
              width: MediaQuery.of(context).size.width / 1.2,
              height: 1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PerformanceCharts()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.show_chart,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Improvement",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black.withAlpha(30),
              width: MediaQuery.of(context).size.width / 1.2,
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
