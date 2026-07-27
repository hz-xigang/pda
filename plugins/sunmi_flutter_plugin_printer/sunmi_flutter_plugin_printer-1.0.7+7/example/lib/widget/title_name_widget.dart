import 'package:flutter/material.dart';

class TitleNameWidget extends StatelessWidget {
  final String? title;
  final String? name;

  const TitleNameWidget({Key? key, required this.title, required this.name})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(title ?? "error", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(name ?? "error", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 10), // 下划线与文本之间的间距
          height: 1,
          width: double.infinity, // 下划线填满宽度
          color: Colors.black,
        ),
      ],
    );
  }
}
