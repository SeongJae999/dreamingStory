import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void showFeedbackForm(BuildContext context) {
  double rating = 0;
  String? selectedError;
  List<String> possibleErrors = [
    '오디오가 재생되지 않음',
    '이미지가 로드되지 않음',
    '텍스트가 깨져 보임',
    '애니메이션이 부자연스러움',
    '앱이 느리게 동작함',
    '기타'
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              '동화가 마음에 드셨나요?',
              style: TextStyle(fontFamily: 'GodoB', fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (value) {
                      setState(() {
                        rating = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    '문제가 있었다면 선택해주세요:',
                    style: TextStyle(fontFamily: 'GodoB', fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedError,
                    hint: Text(selectedError ?? '문제 선택'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedError = newValue;
                      });
                    },
                    items: possibleErrors
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  '제출',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'GodoB',
                  ),
                ),
                onPressed: () {
                  // TODO: 피드백 저장 로직 구현
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('소중한 의견 감사합니다!',
                            style: TextStyle(
                              fontFamily: 'GodoM',
                              fontSize: 16,
                            ))),
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );
}
