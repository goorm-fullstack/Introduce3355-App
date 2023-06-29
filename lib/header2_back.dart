import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<double> callback;
  const Header({Key? key, required this.callback, required String title})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 70);

  @override
  Widget build(BuildContext context) {
    final height = preferredSize.height;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFFD6F0EF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0), // 아이콘 위에 패딩 추가
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/logo_goorm.png',
                  width: 150,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
