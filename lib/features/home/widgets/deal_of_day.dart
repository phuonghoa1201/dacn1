import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({Key? key}) : super(key: key);

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: const Text(
            'Deal of the day',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeaAD2BEH3HV9rnZ2rpuJoM0te_PCyoYLPXw&s',
          height: 235,
          fit: BoxFit.fitHeight,
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.topLeft,
          child: Text('\$100', style: const TextStyle(fontSize:18 ),)
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
          child: const Text(
            'MacBook3 Pro',
           maxLines: 2, overflow: TextOverflow.ellipsis,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaw2a__Zfif7x7NVkNm2meo3ZbG07cCWfxrA&s', fit: BoxFit.fitWidth, width: 100, height: 100,),
              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaw2a__Zfif7x7NVkNm2meo3ZbG07cCWfxrA&s', fit: BoxFit.fitWidth, width: 100, height: 100,),
              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaw2a__Zfif7x7NVkNm2meo3ZbG07cCWfxrA&s', fit: BoxFit.fitWidth, width: 100, height: 100,),
              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaw2a__Zfif7x7NVkNm2meo3ZbG07cCWfxrA&s', fit: BoxFit.fitWidth, width: 100, height: 100,),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ).copyWith(left: 15),
          alignment: Alignment.topLeft,
          child: Text('See all deals', style: TextStyle(color: Colors.cyan[800]),),
        ),
      ],
    );
  }
}
