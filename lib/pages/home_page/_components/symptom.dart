import 'package:flutter/material.dart';
import 'symptom_selector.dart';
import 'package:material_symbols_icons/symbols.dart';

class Symptoms extends StatelessWidget {
  const Symptoms({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(13.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Symbols.earthquake_rounded, color: Colors.purple,),
              SizedBox(width: 10,),
              Text("Symptoms", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
              ),)
            ],
          ),
          SizedBox(height: 15,),
          SymptomSelector()
        ],
      ),
    );
  }
}