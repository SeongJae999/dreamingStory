import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamingstory/pages/account/login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String childName = '김민규';
  DateTime childBirthday = DateTime(1999, 8, 1);
  String childGender = '남';
  List<String> childInterests = ['코딩', '캠핑', '스시 먹고 싶다'];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final (age, months) = calculateAge(childBirthday);

    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '계정 정보',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('아이 정보'),
              subtitle: Text('$childName / $age세 $months개월 / $childGender'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditChildInfoDialog(context),
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              '계정 설정',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('비밀번호 변경'),
              onTap: () {
                // 비밀번호 변경 기능 구현
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('계정 삭제'),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
            const Divider(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showEditChildInfoDialog(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: childName);
    String selectedGender = childGender;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이 정보 수정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              ListTile(
                title: const Text('생년월일'),
                subtitle: Text(
                    '${childBirthday.year}년 ${childBirthday.month}월 ${childBirthday.day}일'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: childBirthday,
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != childBirthday) {
                    setState(() {
                      childBirthday = picked;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: ['남', '여']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedGender = value!;
                },
                decoration: const InputDecoration(labelText: '성별'),
              ),
              Wrap(
                spacing: 8.0,
                children: childInterests
                    .map((interest) => Chip(
                          label: Text(interest),
                          onDeleted: () {
                            setState(() {
                              childInterests.remove(interest);
                            });
                          },
                        ))
                    .toList(),
              ),
              TextButton(
                onPressed: () => _showAddInterestDialog(context),
                child: const Text('관심사 추가'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                childName = nameController.text;
                childGender = selectedGender;
              });
              Navigator.pop(context);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  void _showAddInterestDialog(BuildContext context) {
    TextEditingController interestController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('관심사 추가'),
        content: TextField(
          controller: interestController,
          decoration: const InputDecoration(labelText: '관심사'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (interestController.text.isNotEmpty) {
                  childInterests.add(interestController.text);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    // 기존 코드와 동일
  }

  (int, int) calculateAge(DateTime birthdate) {
    DateTime today = DateTime.now();
    int age = today.year - birthdate.year;
    int months = today.month - birthdate.month;

    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
      months = 12 - (birthdate.month - today.month);
    }

    if (today.day < birthdate.day) {
      months--;
      if (months < 0) {
        months = 11;
        age--;
      }
    }

    return (age, months);
  }
}
