import 'package:flutter/material.dart';

class KennelGrid extends StatelessWidget {
  final List<bool> occupiedKennels;
  final String hallwayName;
  final int startNumber;
  final int columns;
  final Function(int) onKennelTap;

  const KennelGrid({
    Key? key,
    required this.occupiedKennels,
    required this.hallwayName,
    required this.startNumber,
    this.columns = 5,
    required this.onKennelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                'caniles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF202020),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hallwayName,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF202020),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'H${startNumber ~/ 50 + 1}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
          ),
          itemCount: occupiedKennels.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onKennelTap(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: occupiedKennels[index] ? Color(0xFFFF0000) : Color(0xFF202020),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${(startNumber + index).toString().padLeft(3, '0')}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

