import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:tinderapp/SwipeScreen/swipe_btn_screen.dart';
import 'cardscreen.dart';


class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  List<SwipeItem> swipeItems = [];
  late MatchEngine matchItem;
  final ValueNotifier<bool> isLiked = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isNoped = ValueNotifier<bool>(false);

  final List<Map<String, dynamic>> data = [
    {"name": "Daisy", "age": "27", "image": "assets/images/girls.jpg"},
    {"name": "Manas", "age": "21", "image": "assets/images/img_1.png"},
    {"name": "Tushar", "age": "22", "image": "assets/images/img_2.png"},
    {"name": "Aniket", "age": "25", "image": "assets/images/img_3.png"},
    {"name": "Sakshi", "age": "27", "image": "assets/images/girls2.png"},
    {"name": "Amrit", "age": "29", "image": "assets/images/cute-girl-pic45.jpg"},
  ];

  @override
  void initState() {
    super.initState();

    for (var item in data) {
      swipeItems.add(SwipeItem(
        content: item,
        likeAction: () {
          isLiked.value = true;
          isNoped.value = false;
          Future.delayed(const Duration(milliseconds: 500), () {
            isLiked.value = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You liked ${item['name']}!"),
            backgroundColor: Colors.green,
            duration: const Duration(milliseconds: 500),
          ));
        },
        nopeAction: () {
          isNoped.value = true;
          isLiked.value = false;
          Future.delayed(const Duration(milliseconds: 500), () {
            isNoped.value = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You noped ${item['name']}!"),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 500),
          ));
        },
      ));
    }

    matchItem = MatchEngine(swipeItems: swipeItems);
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
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
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
              matchEngine: matchItem,
              itemBuilder: (BuildContext context, int index) {
                final item = swipeItems[index].content;
                return ProfileCard(data: item);
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
          SwipeActionButtons(
            isLiked: isLiked,
            isNoped: isNoped,
            matchItem: matchItem,
          ),
        ],
      ),
    );
  }
}
