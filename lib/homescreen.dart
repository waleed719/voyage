import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:voyage/planner.dart';
import 'package:voyage/travel_diaries.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  int i = 0;
  late AnimationController animationController;
  late Animation<double> animation;
  final CardSwiperController controller = CardSwiperController();
  final List<Map<String, String>> places = [
    {
      'title': "Garden City",
      'location': 'Singapore',
      'imgUrl':
          'https://images.unsplash.com/photo-1555912881-1ecd82307e0e?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'title': "Santorini",
      'location': 'Greece',
      'imgUrl':
          'https://images.unsplash.com/photo-1688664562000-4c1f7cdb48f8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'title': "Banff National Park",
      'location': 'Canada',
      'imgUrl':
          'https://images.unsplash.com/photo-1639436330343-e7b8a310f19a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'title': "Kyoto Temples",
      'location': 'Japan',
      'imgUrl':
          'https://images.unsplash.com/photo-1692721944777-70e39eb57623?w=400&auto=format&fit=q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fEt5b3RvJTIwVGVtcGxlc3xlbnwwfHwwfHx8MA%3D%3D',
    },
    {
      'title': "Machu Picchu",
      'location': 'Peru',
      'imgUrl':
          'https://images.unsplash.com/photo-1526392060635-9d6019884377?w=400&auto=format&fit=q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8TWFjaHUlMjBQaWNjaHV8ZW58MHx8MHx8fDA%3D',
    },
    {
      'title': "Neuschwanstein",
      'location': 'Germany',
      'imgUrl':
          'https://images.unsplash.com/photo-1495316364083-b5916626072e?w=400&auto=format&fit=q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8TmV1c2Nod2Fuc3RlaW4lMjBDYXN0bGV8ZW58MHx8MHx8fDA%3D',
    },
    {
      'title': "Amalfi Coast",
      'location': 'Italy',
      'imgUrl':
          'https://images.unsplash.com/photo-1561956021-947f09ae0101?w=400&auto=format&fit=q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8QW1hbGZpJTIwQ29hc3R8ZW58MHx8MHx8fDA%3D',
    },
    {
      'title': "Bora Bora",
      'location': 'French Polynesia',
      'imgUrl':
          'https://images.unsplash.com/photo-1532408840957-031d8034aeef?w=400&auto=format&fit=q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Qm9yYSUyMEJvcmF8ZW58MHx8MHx8fDA%3D',
    },
    {
      'title': "Hallstatt",
      'location': 'Austria',
      'imgUrl':
          'https://images.unsplash.com/photo-1605853010259-412015b0ab6a?w=400&auto=format&fit=q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8SGFsbHN0YXR0fGVufDB8fDB8fHww',
    },
    {
      'title': "Great Barrier Reef",
      'location': 'Australia',
      'imgUrl':
          'https://images.unsplash.com/photo-1587139223877-04cb899fa3e8?w=400&auto=format&fit=q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8R3JlYXQlMjBCYXJyaWVyJTIwUmVlZnxlbnwwfHwwfHx8MA%3D%3D',
    },
  ];

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    super.initState();
  }

  void ontappedItem(int index) {
    setState(() {
      i = index;
    });
    animationController.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  final List<String> ls = ["All", "Tour Package", "Hotel", "Sights"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://media.vanityfair.com/photos/59300c94cd4080273f3dce99/master/w_960,c_limit/alexandra-daddario-in-the-limelight.jpg',
              ),
              radius: 25, // Adjusted for responsiveness
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'Hey! Alexandra',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04, // Responsive font size
              ),
            ),
            const Spacer(),
            // Search and notification buttons
            _buildAppBarIcon(Icons.search, Colors.white),
            SizedBox(width: screenWidth * 0.02),
            _buildAppBarIcon(Icons.notifications_outlined, Colors.white),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wander ✈️',
                        style: TextStyle(
                          fontSize: screenWidth * 0.12, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Without Limits.',
                        style: TextStyle(
                          fontSize: screenWidth * 0.1, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Category chips
                  SizedBox(
                    height: screenHeight * 0.06, // Responsive height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ls.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Chip(
                              label: Text(ls[index]),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.035, // Responsive font size
                              ),
                              backgroundColor: isSelected
                                  ? const Color.fromRGBO(202, 228, 83, 1)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                  width: 1.5,
                                  color: isSelected
                                      ? const Color.fromRGBO(202, 228, 83, 1)
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: CardSwiper(
                      backCardOffset: const Offset(0, -25),
                      cardsCount: places.length,
                      numberOfCardsDisplayed: 5,
                      cardBuilder:
                          (
                            context,
                            index,
                            percentThresholdX,
                            percentThresholdY,
                          ) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(
                                      0,
                                      screenHeight * 0.01,
                                    ), // Responsive shadow offset
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      places[index]['imgUrl']!,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black54,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top:
                                          screenHeight *
                                          0.02, // Responsive position
                                      left:
                                          screenWidth *
                                          0.04, // Responsive position
                                      right:
                                          screenWidth *
                                          0.04, // Responsive position
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Chip for title
                                          Chip(
                                            label: Text(
                                              places[index]['title']!,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    screenWidth *
                                                    0.04, // Responsive font size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          // Chip for location
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 5,
                                                sigmaY: 5,
                                              ),
                                              child: Chip(
                                                label: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.02,
                                                    vertical:
                                                        screenHeight * 0.01,
                                                  ),
                                                  child: Text(
                                                    places[index]['location']!,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          screenWidth *
                                                          0.035, // Responsive font size
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor: Colors.black
                                                    .withValues(alpha: 0.3),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                      onSwipe: (previousIndex, currentIndex, direction) {
                        if (previousIndex == places.length - 1) {
                          setState(() {
                            final card = places.removeAt(previousIndex);
                            places.insert(0, card);
                          });
                          controller.moveTo(0);
                        }
                        return true;
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Positioned navigation bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _navBar(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromRGBO(189, 189, 189, 1),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: color),
      ),
    );
  }

  Widget _navBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navIcons = [Icons.home, Icons.flight_takeoff, Icons.event];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
      ), // Responsive padding
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: screenWidth > 600 ? 90 : 80, // Responsive height
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.2,
              ), // Use opacity for clarity
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(navIcons.length, (index) {
                final isSelected = i == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      i = index;
                    });

                    _handleNavigation(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color.fromRGBO(202, 228, 83, 1)
                          : Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        navIcons[index],
                        color: isSelected ? Colors.black : Colors.white70,
                        size: isSelected ? 28 : 24,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Planner()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TravelDiaries()),
        );
        break;
    }
  }
}
