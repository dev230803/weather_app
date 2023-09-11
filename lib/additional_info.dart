// ignore_for_file: camel_case_types

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
                      const SizedBox(height: 8,),
                      Text(label),
                      const SizedBox(height: 8,),
                      Text(value,style: const TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  );
  }
}