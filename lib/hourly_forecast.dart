import 'package:flutter/material.dart';

class HorlyForecast extends StatelessWidget {
  const HorlyForecast({super.key, required this.time, required this.icon, required this.temp});
  final String time;
  final IconData icon;
  final dynamic temp;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
        ),
        padding: const EdgeInsets.all(20.0),
        child:  Column(
          children: [
            Text(
              time,
              maxLines: 1,

              style: const TextStyle(fontSize: 16
              ,fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text('${(temp-273.15).toStringAsFixed(2)} °C')
          ],
        ),
      ),
    );
  }
}
