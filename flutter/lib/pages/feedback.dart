import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dreamingstory/component/user.dart';

class FeedbackForm {
  static Future<void> submitFeedback(
      double rating, String? selectedError, BuildContext context) async {
    final baseUrl = dotenv.env['NGROK_URL'];
    final String apiUrl = '$baseUrl/stories/submit-feedback';

    final Map<String, dynamic> feedbackData = {
      'rating': rating,
      'error': selectedError,
    };

    String? idToken = AuthService().idToken;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        },
        body: jsonEncode(feedbackData),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('소중한 의견 감사합니다!')),
        );
      } else {
        print('Error: ${response.body}');
        throw Exception('피드백 제출에 실패했습니다.');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('피드백 제출에 실패했습니다: $error')),
      );
    }
  }

  static void showFeedbackForm(BuildContext context) {
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
                    submitFeedback(rating, selectedError, context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
