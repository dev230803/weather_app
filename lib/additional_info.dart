import 'package:flutter/material.dart';

class additional_info extends StatelessWidget {
  const additional_info({
    super.key,
    required this.icon,
    required this.label,
    required this.value,  
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon,size: 45,),
                      SizedBox(height: 8,),
                      Text(label),
                      SizedBox(height: 8,),
                      Text(value,style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  );
  }
}