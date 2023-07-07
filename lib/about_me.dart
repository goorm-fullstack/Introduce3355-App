import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'header2_back.dart';
import 'package:goorm_3355/login/log.dart';

class AboutMe extends StatefulWidget {
  final String documentId;

  const AboutMe({Key? key, required this.documentId}) : super(key: key);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with TickerProviderStateMixin {
  late Future<DocumentSnapshot<Map<String, dynamic>>> documentFuture;
  late AnimationController _slideController;
  late Animation<Offset> _offsetAnimation;
  late AnimationController _usernameRoleFadeController;
  late AnimationController _aboutMeFadeController;
  late AnimationController _skillFadeController;
  late AnimationController _evaluationFadeController;
  late Animation<double> _usernameRoleFadeAnimation;
  late Animation<double> _aboutMeFadeAnimation;
  late Animation<double> _skillFadeAnimation;
  late Animation<double> _evaluationFadeAnimation;

  @override
  void initState() {
    super.initState();
    documentFuture = FirebaseFirestore.instance
        .collection('3_Team')
        .doc(widget.documentId)
        .get();

    _slideController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.01), // 여기야
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _usernameRoleFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _aboutMeFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _skillFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _evaluationFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _usernameRoleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_usernameRoleFadeController);
    _aboutMeFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_aboutMeFadeController);
    _skillFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_skillFadeController);
    _evaluationFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_evaluationFadeController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(
          title: 'About Me',
          callback: (value) {
            print('Callback received value: $value');
          },
        ),
        body: SingleChildScrollView(
          // 스크롤 가능한 뷰로 변경
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: documentFuture,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Map<String, dynamic>? data = snapshot.data?.data();
                if (data == null) {
                  return Center(child: Text('No data'));
                } else {
                  String imageUrl = data['photo_url1'];
                  String username = data['String username'];
                  String role = data['role'] ?? '역할 정보 없음';
                  String about_me = data['about_me'] ?? '소개 정보 없음';
                  List<String?> skills = [
                    data['skill1'],
                    data['skill2'],
                    data['skill3'],
                    data['skill4'],
                    data['skill5'],
                    data['skill6'],
                    data['skill7'],
                    data['skill8'],
                  ];

                  Future.delayed(const Duration(seconds: 1), () {
                    _usernameRoleFadeController.forward();
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    _aboutMeFadeController.forward();
                  });
                  Future.delayed(const Duration(seconds: 3), () {
                    _skillFadeController.forward();
                  });
                  Future.delayed(const Duration(seconds: 4), () {
                    _evaluationFadeController.forward();
                  });

                  return Center(
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            // GestureDetector 위젯 추가
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage2(), // 이동하려는 페이지
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 70,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeTransition(
                            opacity: _usernameRoleFadeAnimation,
                            child: Text(username),
                          ),
                          FadeTransition(
                            opacity: _usernameRoleFadeAnimation,
                            child: Text(
                              '\n $role',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          FadeTransition(
                            opacity: _aboutMeFadeAnimation,
                            child: Padding(
                              padding: EdgeInsets.only(right: 300),
                              child: Text(
                                '\n\n 소개',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                          FadeTransition(
                            opacity: _aboutMeFadeAnimation,
                            child: Text(
                              '\n $about_me',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          FadeTransition(
                            opacity: _skillFadeAnimation,
                            child: Padding(
                              padding: EdgeInsets.only(right: 300),
                              child: Text(
                                '\n\n 기술\n',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                          FadeTransition(
                            opacity: _skillFadeAnimation,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 30.0), // 원하는 패딩값을 설정하세요
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 15.0, // 각 이미지 사이의 간격
                                runSpacing: 30.0, // 줄 사이의 간격
                                children: skills.map((skill) {
                                  if (skill != null && skill.isNotEmpty) {
                                    return Image.network(skill,
                                        width: 80, height: 80); // 크기를 조절
                                  } else {
                                    return Container(); // skill이 없는 경우 빈 컨테이너 반환
                                  }
                                }).toList(),
                              ),
                            ),
                          ),
                          FadeTransition(
                            opacity: _evaluationFadeAnimation,
                            child: Padding(
                              padding: EdgeInsets.only(right: 300),
                              child: Text(
                                ' 피드백\n',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                          FadeTransition(
                            opacity: _evaluationFadeAnimation,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity, // 가로로 꽉 차도록
                                  padding: EdgeInsets.all(16.0), // 안쪽 여백
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFEF0D6), // 박스 색상 설정
                                    borderRadius: BorderRadius.circular(
                                        10.0), // 모서리 라운딩 처리
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: '    '),
                                        TextSpan(
                                          text: data['evaluation1_1'] ??
                                              '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(color: Colors.black),
                                        ),
                                        TextSpan(text: '    '),
                                        TextSpan(
                                          text: data['evaluation1_2'] ??
                                              '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                  color: Colors
                                                      .grey), // 회색의 흐린 텍스트 스타일
                                        ),
                                        TextSpan(text: '\n\n '),
                                        TextSpan(
                                          text:
                                              data['evaluation1'] ?? '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style, // 기본 텍스트 스타일
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25.0), // 박스와 박스 사이의 간격
                                Container(
                                  width: double.infinity, // 가로로 꽉 차도록
                                  padding: EdgeInsets.all(16.0), // 안쪽 여백
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F2F4), // 박스 색상 설정
                                    borderRadius: BorderRadius.circular(
                                        10.0), // 모서리 라운딩 처리
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: '    '),
                                        TextSpan(
                                          text: data['evaluation2_1'] ??
                                              '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(color: Colors.black),
                                        ),
                                        TextSpan(text: '    '),
                                        TextSpan(
                                          text: data['evaluation2_2'] ??
                                              '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                  color: Colors
                                                      .grey), // 회색의 흐린 텍스트 스타일
                                        ),
                                        TextSpan(text: '\n\n '),
                                        TextSpan(
                                          text:
                                              data['evaluation2'] ?? '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style, // 기본 텍스트 스타일
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                Container(
                                  width: double.infinity, // 가로로 꽉 차도록
                                  padding: EdgeInsets.all(16.0), // 안쪽 여백
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFEF0D6), // 박스 색상 설정
                                    borderRadius: BorderRadius.circular(
                                        10.0), // 모서리 라운딩 처리
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: '    '),
                                        TextSpan(
                                          text: data['evaluation3_1'] ??
                                              '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(color: Colors.black),
                                        ),
                                        TextSpan(text: '    '),
                                        TextSpan(
                                          text: data['evaluation3_2'] ??
                                              '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                  color: Colors
                                                      .grey), // 회색의 흐린 텍스트 스타일
                                        ),
                                        TextSpan(text: '\n\n '),
                                        TextSpan(
                                          text:
                                              data['evaluation3'] ?? '평가 정보 없음',
                                          style: DefaultTextStyle.of(context)
                                              .style, // 기본 텍스트 스타일
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _usernameRoleFadeController.dispose();
    _aboutMeFadeController.dispose();
    _skillFadeController.dispose();
    _evaluationFadeController.dispose();
    super.dispose();
  }
}
