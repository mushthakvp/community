import 'package:flutter/material.dart';

class CookSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final String searchQuery;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const CookSearchBarWidget({
    super.key,
    required this.controller,
    required this.onClear,
    required this.searchQuery,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              const Color(0xffdadada).withOpacity(0.12),
              const Color(0xff999795).withOpacity(0.12),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.search, color: Colors.white70, size: 20),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                readOnly: onTap != null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search challenges, recipes',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Visibility(
              visible: searchQuery.isNotEmpty,
              child: GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.6),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
