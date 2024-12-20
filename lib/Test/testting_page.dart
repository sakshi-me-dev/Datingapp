import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/cupertino.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  final ValueNotifier<bool> _isLiked = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isNoped = ValueNotifier<bool>(false);

  final List<Map<String, dynamic>> _data = [
    {"name": "Daisy", "age": "27", "image": "assets/images/girls.jpg"},
    {"name": "manas", "age": "21", "image": "assets/images/img_1.png"},
    {"name": "tushar", "age": "22", "image": "assets/images/img_2.png"},
    {"name": "aniket", "age": "25", "image": "assets/images/img_3.png"},
    {"name": "sakshi", "age": "27", "image": "assets/images/girls2.png"},
    {"name": "amrit", "age": "29", "image": "assets/images/cute-girl-pic45.jpg"},
  ];

  @override
  void initState() {
    super.initState();

    for (var item in _data) {
      _swipeItems.add(SwipeItem(
        content: item,
        likeAction: () {
          _isLiked.value = true;
          _isNoped.value = false;
          Future.delayed(const Duration(milliseconds: 500), () {
            _isLiked.value = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You liked ${item['name']}!"),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 500),
          ));
        },
        nopeAction: () {
          _isNoped.value = true;
          _isLiked.value = false;
          Future.delayed(const Duration(milliseconds: 500), () {
            _isNoped.value = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You noped ${item['name']}!"),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 500),
          ));
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/img.png",
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.bell,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                Image.asset(
                  "assets/images/filterIcon.png",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (BuildContext context, int index) {
                final item = _swipeItems[index].content;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          item['image'],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item['name']}, ${item['age']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Swipe left to Nope, Swipe right to Like",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("No more profiles to show!"),
                  duration: Duration(seconds: 1),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                print("Item changed: ${item.content['name']}, index: $index");
              },
              upSwipeAllowed: false,
              fillSpace: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isNoped,
                  builder: (context, isNopedValue, child) {
                    return AnimatedScale(
                      scale: isNopedValue ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          iconSize: 30,
                          onPressed: () {
                            _matchEngine.currentItem?.nope();
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 30),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLiked,
                  builder: (context, isLikedValue, child) {
                    return AnimatedScale(
                      scale: isLikedValue ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.white),
                          iconSize: 30,
                          onPressed: () {
                            _matchEngine.currentItem?.like();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
