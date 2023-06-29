import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'about_me.dart';
import 'header.dart';
import 'guest_book/guest_book.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double opacity = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  double opacity4 = 0.0;
  double opacity5 = 0.0;

  final duration = const Duration(seconds: 1);

// 여기부터는 타이머로 진행하는 애니메이션 구현하는 곳
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          opacity = 1.0;
        });
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          opacity2 = 1.0;
        });
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          opacity3 = 1.0;
        });
      }
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          opacity4 = 1.0;
        });
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          opacity5 = 1.0;
        });
      }
    });
  }
  // 여기까지

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String id) async {
    return FirebaseFirestore.instance.collection('3_Team').doc(id).get();
  }

  void _navigateToAboutMe(BuildContext context, String documentId) {
    setState(() {
      opacity = 0.0;
    });

    Future.delayed(duration, () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AboutMe(documentId: documentId)),
      );
    });

    Future.delayed(duration, () {
      if (mounted) {
        setState(() {
          opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(seconds: 1),
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 140),
                  // 여기부터는 로그인 버튼
                ),
                AnimatedOpacity(
                  opacity: opacity2,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    '\n                                                 about',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ),
                const Center(
                  child: Text(
                    '3조 삼삼오오\n',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                AnimatedOpacity(
                  opacity: opacity2,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    '    저희 팀은 다양한 전문분야를 공부하는 멤버들로 구성되어 있습니다. \n 각자의 전문성과 열정을 바탕으로 협력하는 우리는 동기부여를 유지하며\n협력과 열정을 바탕으로, 빠르게 변화하는 환경에서 문제를 해결하기 위해 \n                 적극적으로 노력하며 지속적인 발전을 추구합니다.\n\n                            지금부터 우리팀을 소개하겠습니다.\n ',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                AnimatedOpacity(
                  opacity: opacity3,
                  duration: const Duration(seconds: 1),
                  child: GestureDetector(
                    onTap: () async {
                      const url =
                          'https://github.com/goorm-fullstack/Introduce3355-App';
                      // ignore: deprecated_member_use
                      if (await canLaunch(url)) {
                        // ignore: deprecated_member_use
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                      'assets/images/git.png',
                      width: 100,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                AnimatedOpacity(
                  opacity: opacity4,
                  duration: const Duration(seconds: 1),
                  child: const MainSubScreen(),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                AnimatedOpacity(
                  opacity: opacity5,
                  duration: const Duration(seconds: 1),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        '\n\nmember',
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                      const SizedBox(height: 5), // 멤버랑 조원소개 간격 조절
                      const Text(
                        '조원소개',
                        style: TextStyle(fontSize: 28),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            future: getDocument('JinhwanB'),
                            builder: buildProfileColumn,
                          ),
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            future: getDocument('MSH'),
                            builder: buildProfileColumn,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            future: getDocument('WhiteKIM'),
                            builder: buildProfileColumn,
                          ),
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            future: getDocument('Ljw'),
                            builder: buildProfileColumn,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Header(
              callback: (double value) {},
              title: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileColumn(
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
  ) {
    if (snapshot.hasData) {
      String documentId = snapshot.data!.id;
      String imageUrl = snapshot.data!.data()!['photo_url1'];
      String username = snapshot.data!.data()!['String username'];
      return GestureDetector(
        onTap: () => _navigateToAboutMe(context, documentId),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(imageUrl),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(username),
            const Text(
              '개발자',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const CircularProgressIndicator();
    }
  }
}
