import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'header2_back.dart';

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
      end: const Offset(0.0, -0.13),
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
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: documentFuture,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
              String skill = data['skill'] ?? '기술 정보 없음';
              String Evaluation = data['Evaluation'] ?? '기술 정보 없음';

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
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 70,
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
                            '\n\n 기술',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _skillFadeAnimation,
                        child: Text(
                          '\n $skill',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      FadeTransition(
                        opacity: _evaluationFadeAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(right: 300),
                          child: Text(
                            '\n\n 평가',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _evaluationFadeAnimation,
                        child: Text(
                          '\n $Evaluation',
                          style: TextStyle(fontSize: 15),
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
    );
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
