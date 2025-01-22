import 'package:flutter/material.dart';

class SubscribePage extends StatelessWidget {
  const SubscribePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구독 및 결제'),
        backgroundColor: const Color.fromARGB(255, 27, 65, 89),
        foregroundColor: const Color.fromARGB(255, 242, 210, 114),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '구독 플랜 선택',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GodoB'),
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              title: '월간 구독',
              price: '₩9,900',
              description: '1개월 동안 모든 기능을 이용하세요',
              onTap: () => _handleSubscription(context, 'monthly'),
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              title: '연간 구독',
              price: '₩99,000',
              description: '1년 동안 모든 기능을 이용하세요 (월 ₩8,250)',
              onTap: () => _handleSubscription(context, 'yearly'),
            ),
            const SizedBox(height: 32),
            const Text(
              '결제 정보',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GodoB'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: '카드 번호',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: '유효 기간 (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'CVC',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 결제 처리 로직 구현
                  _handlePayment(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 242, 210, 114),
                ),
                child: const Text(
                  '결제하기',
                  style: TextStyle(
                      fontSize: 18, color: Colors.black, fontFamily: 'GodoB'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GodoB'),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(
                    fontSize: 18, color: Colors.green, fontFamily: 'GodoM'),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                    fontSize: 16, color: Colors.grey, fontFamily: 'GodoM'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubscription(BuildContext context, String plan) {
    // 구독 플랜 선택 처리 로직
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$plan 플랜을 선택했습니다.',
            style: const TextStyle(fontFamily: 'GodoM')),
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    // 결제 처리 로직
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('결제가 완료되었습니다.', style: TextStyle(fontFamily: 'GodoM')),
      ),
    );
    Navigator.pop(context);
  }
}
