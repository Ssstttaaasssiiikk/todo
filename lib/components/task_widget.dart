import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskWidget({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: isCompleted
                        ? const Color.fromARGB(255, 0, 255, 8)
                        : Colors.grey,
                  ),
                  onPressed: onToggle,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}