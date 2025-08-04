import 'package:flutter/material.dart';
import 'dart:math';

class MemoryImageData {
  final String path;
  double top;
  double left;
  final double angle;
  final double scale;
  final int zIndex; // For stacking order

  MemoryImageData({
    required this.path,
    required this.angle,
    required this.left,
    required this.top,
    required this.scale,
    required this.zIndex,
  });
}

class TravelDiaries extends StatefulWidget {
  const TravelDiaries({super.key});

  @override
  State<TravelDiaries> createState() => _TravelDiariesState();
}

class _TravelDiariesState extends State<TravelDiaries> {
  final List<MemoryImageData> memories = [];
  final List<String> paths = [];
  final Random random = Random();
  int currentZIndex = 0; // Track stacking order
  double? _initialScale; // Track initial scale for pinch gesture

  @override
  void initState() {
    addPaths();
    super.initState();
  }

  void addPaths() {
    for (var i = 1; i < 10; i++) {
      paths.add('assets/images/$i.webp');
    }
  }

  void _addMemoryToScreen(String path, Offset globalPosition) {
    // Convert global position to local coordinates
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(globalPosition);

    // Generate random properties for natural look
    final angle = (random.nextDouble() * 0.6 - 0.3); // More rotation variety
    final scale =
        0.7 + random.nextDouble() * 0.6; // Random scale between 0.7-1.3

    // Allow positioning anywhere on screen, including partial off-screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Center the image on drop position but add some randomness
    final imageSize = 120 * scale;
    double left =
        localPosition.dx - imageSize / 2 + (random.nextDouble() * 40 - 20);
    double top =
        localPosition.dy - imageSize / 2 + (random.nextDouble() * 40 - 20);

    // Allow images to go partially off-screen but not completely
    left = left.clamp(-imageSize * 0.7, screenWidth - imageSize * 0.3);
    top = top.clamp(-imageSize * 0.7, screenHeight - imageSize * 0.3);

    setState(() {
      memories.add(
        MemoryImageData(
          path: path,
          angle: angle,
          left: left,
          top: top,
          scale: scale,
          zIndex: currentZIndex++,
        ),
      );
    });
  }

  void _moveMemoryToTop(int index) {
    setState(() {
      final memory = memories[index];
      memories[index] = MemoryImageData(
        path: memory.path,
        angle: memory.angle,
        left: memory.left,
        top: memory.top,
        scale: memory.scale,
        zIndex: currentZIndex++,
      );
      // Sort memories by zIndex to maintain proper stacking
      memories.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  void _moveMemoryToPosition(int index, Offset globalPosition) {
    // Convert global position to local coordinates
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(globalPosition);

    final memory = memories[index];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Center the image on drop position
    final imageSize = 120 * memory.scale;
    double left = localPosition.dx - imageSize / 2;
    double top = localPosition.dy - imageSize / 2;

    // Allow images to go partially off-screen but not completely
    left = left.clamp(-imageSize * 0.7, screenWidth - imageSize * 0.3);
    top = top.clamp(-imageSize * 0.7, screenHeight - imageSize * 0.3);

    setState(() {
      memories[index] = MemoryImageData(
        path: memory.path,
        angle: memory.angle,
        left: left,
        top: top,
        scale: memory.scale,
        zIndex: currentZIndex++,
      );
      memories.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(79, 135, 171, 1),
            Color.fromRGBO(230, 218, 193, 1),
            Color.fromRGBO(218, 206, 183, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('Travel Diaries'),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(189, 189, 189, 0.7),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                // Main drop area covering the entire screen
                Positioned.fill(
                  child: DragTarget<Object>(
                    // onAccept: (data) {
                    //   // This won't be called since we handle it in onAcceptWithDetails
                    // },
                    onAcceptWithDetails: (details) {
                      if (details.data is String) {
                        // Adding new image from palette
                        _addMemoryToScreen(
                          details.data as String,
                          details.offset,
                        );
                      } else if (details.data is int) {
                        // Moving existing image
                        _moveMemoryToPosition(
                          details.data as int,
                          details.offset,
                        );
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        color: Colors.transparent,
                        child: candidateData.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),

                // Stacked memories
                ...memories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final memory = entry.value;

                  return Positioned(
                    top: memory.top,
                    left: memory.left,
                    child: LongPressDraggable<int>(
                      data: index,
                      feedback: Transform.rotate(
                        angle: memory.angle,
                        child: Transform.scale(
                          scale: memory.scale,
                          child: Opacity(
                            opacity: 0.8,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: Offset(3, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  memory.path,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: 120 * memory.scale,
                        height: 120 * memory.scale,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => _moveMemoryToTop(index),
                        onScaleStart: (details) {
                          _initialScale = memory.scale;
                        },
                        onScaleUpdate: (details) {
                          if (_initialScale != null) {
                            final newScale = (_initialScale! * details.scale)
                                .clamp(0.3, 3.0);
                            setState(() {
                              memories[index] = MemoryImageData(
                                path: memory.path,
                                angle: memory.angle,
                                left: memory.left,
                                top: memory.top,
                                scale: newScale,
                                zIndex: memory.zIndex,
                              );
                            });
                          }
                        },
                        onScaleEnd: (details) {
                          _initialScale = null;
                          // Bring to front when resized
                          _moveMemoryToTop(index);
                        },
                        child: Transform.rotate(
                          angle: memory.angle,
                          child: Transform.scale(
                            scale: memory.scale,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  memory.path,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 7,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: paths.map((path) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                left: 8,
                                right: 8,
                              ),
                              child: Draggable<String>(
                                data: path,
                                feedback: Transform.scale(
                                  scale: 1.1,
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 8,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          path,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      path,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    path,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
