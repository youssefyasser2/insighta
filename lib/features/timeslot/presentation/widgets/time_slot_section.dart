import 'package:flutter/material.dart';

class TimeSlotSection extends StatelessWidget {
  final String title;
  final List<String> timeSlots;
  final Function(String) onTimeSelected; // 🆕 معامل جديد

  const TimeSlotSection({
    super.key,
    required this.title,
    required this.timeSlots,
    required this.onTimeSelected, // ✅ إضافة المعامل هنا
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.teal[700],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              timeSlots.map((timeSlot) {
                return GestureDetector(
                  onTap: () => onTimeSelected(timeSlot), // ✅ استدعاء الدالة
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal[200]!, width: 1),
                    ),
                    child: Text(
                      timeSlot,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
