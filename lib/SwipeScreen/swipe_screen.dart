import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/cupertino.dart';

class SwipeImageScreen extends StatefulWidget {
  const SwipeImageScreen({Key? key}) : super(key: key);

  @override
  State<SwipeImageScreen> createState() => _SwipeImageScreenState();
}

class _SwipeImageScreenState extends State<SwipeImageScreen> {
  late MatchEngine _matchEngine;
  bool _isLiked = false;
  bool _isNoped = false;
  final List<SwipeItem> _swipeItems = [];
  final List<Map<String, dynamic>> _profiles = [
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
    _initializeSwipeItems();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  void _initializeSwipeItems() {
    for (var profile in _profiles) {
      _swipeItems.add(SwipeItem(
        content: profile,
        likeAction: () => _onLike(profile),
        nopeAction: () => _onNope(profile),
      ));
    }
  }

  void _onLike(Map<String, dynamic> profile) {
    setState(() {
      _isLiked = true;
      _isNoped = false;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isLiked = false);
    });
    _showSnackbar("You liked ${profile['name']}!", Colors.green);
  }

  void _onNope(Map<String, dynamic> profile) {
    setState(() {
      _isNoped = true;
      _isLiked = false;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isNoped = false);
    });
    _showSnackbar("You noped ${profile['name']}!", Colors.red);
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSwipeCards(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildSwipeCards() {
    return Expanded(
      child: SwipeCards(
        matchEngine: _matchEngine,
        itemBuilder: (BuildContext context, int index) {
          final profile = _swipeItems[index].content;
          return _buildProfileCard(profile);
        },
        onStackFinished: () {
          _showSnackbar("No more profiles to show!", Colors.blue);
        },
        itemChanged: (SwipeItem item, int index) {
          print("Profile changed: ${item.content['name']}, index: $index");
        },
        upSwipeAllowed: false,
        fillSpace: true,
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
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
              profile['image'],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildProfileDetails(profile),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(Map<String, dynamic> profile) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${profile['name']}, ${profile['age']}",
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
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            isActive: _isNoped,
            onPressed: () => _matchEngine.currentItem?.nope(),
          ),
          const SizedBox(width: 30),
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.green,
            isActive: _isLiked,
            onPressed: () => _matchEngine.currentItem?.like(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return AnimatedScale(
      scale: isActive ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: CircleAvatar(
        radius: 35,
        backgroundColor: color,
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          iconSize: 30,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
