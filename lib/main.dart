import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'detail_main.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Header(callback: (value) {}),
    );
  }
}

class MovingCloud extends StatefulWidget {
  final String imagePath;
  final double width;
  final bool isMoveToLeft;
  const MovingCloud({
    super.key,
    required this.imagePath,
    required this.width,
    this.isMoveToLeft = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MovingCloudState createState() => _MovingCloudState();
}

class _MovingCloudState extends State<MovingCloud>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double topPosition;
  late double endPosition;

  @override
  void initState() {
    super.initState();
    topPosition = Random().nextDouble() * 1000;
    endPosition = -widget.width;
    _controller = AnimationController(
      duration: Duration(seconds: Random().nextInt(50) + 7),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Positioned(
          top: topPosition,
          left: widget.isMoveToLeft
              ? _controller.value * MediaQuery.of(context).size.width
              : null,
          right: widget.isMoveToLeft
              ? null
              : _controller.value * MediaQuery.of(context).size.width,
          child: Image.asset(
            widget.imagePath,
            width: widget.width,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Header extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<double>? callback;
  const Header({Key? key, this.callback}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 70);

  @override
  // ignore: library_private_types_in_public_api
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isFirstImageVisible = false;
  bool isSecondImageVisible = false;
  final bool _isTimeElapsed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.value >= 0.5 && !isFirstImageVisible) {
        setState(() {
          isFirstImageVisible = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 7), () {
      Navigator.of(context).push(_createRouteFadeTransition());
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isSecondImageVisible = true;
      });
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.preferredSize.height;
    return GestureDetector(
      onTap: () {
        if (_isTimeElapsed) {
          Navigator.of(context).push(_createRouteFadeTransition());
        }
      },
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Color(0xFFD6F0EF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        child: Stack(
          children: [
            const MovingCloud(
              imagePath: 'assets/images/goorm_double.png',
              width: 200.0,
            ),
            const MovingCloud(
              imagePath: 'assets/images/goorm_single.png',
              width: 150.0,
              isMoveToLeft: true,
            ),
            const MovingCloud(
              imagePath: 'assets/images/goorm_double.png',
              width: 170.0,
            ),
            const MovingCloud(
              imagePath: 'assets/images/goorm_single.png',
              width: 190.0,
              isMoveToLeft: true,
            ),
            const MovingCloud(
              imagePath: 'assets/images/goorm_double.png',
              width: 210.0,
            ),
            const MovingCloud(
              imagePath: 'assets/images/goorm_single.png',
              width: 230.0,
              isMoveToLeft: true,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: isFirstImageVisible ? 1.0 : 0.0,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeIn,
                    child: Image.asset(
                      'assets/images/logo_goorm.png',
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 200),
                  AnimatedOpacity(
                    opacity: isSecondImageVisible ? 1.0 : 0.0,
                    duration: const Duration(seconds: 3),
                    curve: Curves.easeIn,
                    child: Image.asset(
                      'assets/images/logo_3355.png',
                      width: 300,
                    ),
                  ),
                  const SizedBox(height: 350),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Route _createRouteFadeTransition() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MyHomePage(),
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
