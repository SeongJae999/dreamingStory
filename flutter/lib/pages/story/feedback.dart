import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dreamingstory/component/auth_service.dart';

class FeedbackForm {
  static Future<void> submitFeedback(
    double rating,
    String? selectedError,
    String otherErrorDetail,
    BuildContext context,
  ) async {
    final baseUrl = dotenv.env['NGROK_URL'];
    final String apiUrl = '$baseUrl/stories/submit-feedback';
    final AuthService _authService = AuthService();
    final Map<String, dynamic> feedbackData = {
      'rating': rating,
      'error': selectedError,
      'errorDetail': selectedError == '기타' ? otherErrorDetail : null,
    };

    String? idToken = await _authService.getFirebaseIdToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
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
    final TextEditingController otherErrorController = TextEditingController();

    List<String> possibleErrors = [
      '오디오가 재생되지 않음',
      '이미지가 로드되지 않음',
      '앱이 느리게 동작함',
      '기타',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 300, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 제목 영역
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '동화가 마음에 드셨나요?',
                          style: TextStyle(fontFamily: 'GodoB', fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // 평점 영역
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
                    SizedBox(height: 24),

                    // 문제 선택
                    Text(
                      '문제가 있었다면 선택해주세요:',
                      style: TextStyle(fontFamily: 'GodoB', fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedError,
                      hint: Text('문제 선택'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedError = newValue;
                          if (newValue != '기타') {
                            otherErrorController.clear();
                          }
                        });
                      },
                      items: possibleErrors
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 14, fontFamily: 'GodoM'),
                          ),
                        );
                      }).toList(),
                    ),

                    // '기타' 선택 시 나타나는 오류 상세 입력란
                    if (selectedError == '기타') ...[
                      SizedBox(height: 16),
                      Text(
                        '어떤 오류인지 더 자세히 알려주세요!',
                        style: TextStyle(fontFamily: 'GodoB', fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: otherErrorController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: '오류 내용을 상세히 입력해주세요.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],

                    SizedBox(height: 24),

                    // 제출 버튼
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          submitFeedback(
                            rating,
                            selectedError,
                            otherErrorController.text,
                            context,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          '제출',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'GodoB',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
