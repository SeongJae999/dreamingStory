import 'package:flutter/material.dart';

Widget buildSectionCard(
    {required String title, required List<Widget> children}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 27, 65, 89),
                fontFamily: 'GodoB'),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    ),
  );
}

Widget buildInfoTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: const Color.fromARGB(255, 242, 210, 114)),
    title: Text(title,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'GodoB',
        )),
    subtitle: Text(subtitle,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'GodoB',
        )),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
    enableFeedback: false,
  );
}

Widget buildActionTile({
  required IconData icon,
  required String title,
  Color? color,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading:
        Icon(icon, color: color ?? const Color.fromARGB(255, 242, 210, 114)),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: color ?? Colors.black,
        fontFamily: 'GodoM',
      ),
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
    enableFeedback: false,
  );
}

Widget buildExpandableSection({
  required String title,
  required bool isExpanded,
  required ValueChanged<bool> onToggle,
  required List<String> content,
}) {
  return Card(
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onToggle(!isExpanded),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max, // ← 수정됨
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: isExpanded ? 0.5 : 0,
                      child: const Icon(Icons.expand_more, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content
                        .map((text) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                text,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget buildExpandableTile({
  required String title,
  required bool isExpanded,
  required VoidCallback onTap,
  required List<Widget> content,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'GodoB',
          color: Color.fromARGB(255, 27, 65, 89),
        ),
      ),
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        color: const Color.fromARGB(255, 242, 210, 114),
      ),
      onExpansionChanged: (expanded) => onTap(),
      enableFeedback: false,
      children: [
        Container(
          height: 300, // 고정 높이 설정
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildSwitchTile({
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'GodoB',
        color: Color.fromARGB(255, 27, 65, 89),
      ),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'GodoM',
        color: Colors.grey,
      ),
    ),
    trailing: Switch(
      value: value,
      onChanged: onChanged,
      activeColor: const Color.fromARGB(255, 242, 210, 114),
    ),
  );
}

Widget buildVersionInfo(String version) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      '버전: $version',
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'GodoM',
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

// Widget buildSectionCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'GodoB',
//                 color: Color.fromARGB(255, 27, 65, 89),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

Widget buildFAQItem({
  required String question,
  required String answer,
}) {
  return ExpansionTile(
    title: Text(
      question,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'GodoB',
        color: Color.fromARGB(255, 27, 65, 89),
      ),
    ),
    enableFeedback: false,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          answer,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'GodoM',
            color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}

Widget buildContactTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: const Color.fromARGB(255, 242, 210, 114)),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'GodoB',
        color: Color.fromARGB(255, 27, 65, 89),
      ),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'GodoM',
        color: Colors.grey,
      ),
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
    enableFeedback: false,
  );
}
