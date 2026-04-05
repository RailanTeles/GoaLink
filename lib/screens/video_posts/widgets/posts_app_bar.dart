import 'package:flutter/material.dart';

class PostsAppBar extends StatelessWidget {
  const PostsAppBar({
    super.key,
    required this.onBack,
    required this.onAdd,
    this.backToHome = false,
  });

  final VoidCallback onBack;
  final VoidCallback onAdd;
  final bool backToHome;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1E6B47);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 74,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onBack,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                  ),
                  iconSize: 28,
                  icon: const Icon(Icons.arrow_back),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: onAdd,
                    padding: EdgeInsets.zero,
                    iconSize: 28,
                    color: green,
                    icon: const Icon(Icons.add_rounded),
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
