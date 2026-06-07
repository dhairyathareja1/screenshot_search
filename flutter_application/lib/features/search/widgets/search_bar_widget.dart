import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

/// The search input bar at the top of the Search screen
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final VoidCallback onCleared;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: false,
      decoration: InputDecoration(
        hintText: AppStrings.searchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onCleared,
              )
            : null,
      ),
      onChanged: onChanged,
    );
  }
}
