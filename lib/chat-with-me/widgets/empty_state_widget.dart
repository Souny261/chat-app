import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "How can I help you today?",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
