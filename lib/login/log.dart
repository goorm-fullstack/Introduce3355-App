import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao_flutter_sdk;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goorm_3355/login/join_new.dart';
import 'package:goorm_3355/login/after_login/log_main.dart';

bool isLoggedIn = false;

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  void _kakaoLogin(BuildContext context) async {
    try {
      kakao_flutter_sdk.OAuthToken token =
          await kakao_flutter_sdk.UserApi.instance.loginWithKakaoAccount();
      if (kDebugMode) {
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
      }
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage3(),
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null) {
      _emailController.text = email;
      rememberMe = true;
      setState(() {});
    }
  }

  void _goToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _saveEmail() async {
    if (rememberMe) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', _emailController.text);
    }
  }

  void _login(BuildContext context) async {
    setState(() {
      _errorMessage = null;
    });

    // 입력값이 asnvkfwn0103인 경우, Firebase 인증을 스킵하고 바로 MyHomePage3로 이동
    if (_emailController.text == 'test' && _passwordController.text == '1234') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage3(),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true; // 로딩 상태 시작
      });

      firebase_auth.UserCredential userCredential =
          await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        isLoading = false; // 로딩 상태 종료
      });

      if (!userCredential.user!.emailVerified) {
        // 이메일 인증이 안 된 경우
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("이메일 인증"),
              content: const Text(
                  "원활한 로그인 기능을 사용하기 위해서는 이메일 인증을 부탁드리겠습니다!\n\n\n\n             이메일을 확인해주세요"),
              actions: <Widget>[
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      _saveEmail();
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage3(),
        ),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = '해당 이메일로 등록된 사용자가 없습니다.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = '비밀번호가 틀렸습니다.';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        isLoading = false; // 예외 발생 시 로딩 상태 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Unknown.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            const Positioned(
              top: 200, // 로그인 이미지 텍스트 옮기기
              left: 25,
              child: Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 48,
                  fontFamily: 'Poppins-Medium',
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 81, 149, 72),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                        activeColor: const Color.fromARGB(
                            255, 81, 149, 72), // 체크박스 색상 변경
                        checkColor: Colors.white, // 선택될 때 체크 마크의 색상입니다.
                      ),
                      const Text('아이디 저장',
                          style: TextStyle(
                              color: Color.fromARGB(
                                  255, 81, 149, 72))), // 이메일 저장 텍스트 색상 변경
                    ],
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '아이디',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 81, 149, 72)), // 라벨 색상 변경
                      filled: false,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 81, 149, 72),
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 81, 149, 72)), // 텍스트 색상 변경
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 81, 149, 72)), // 라벨 색상 변경
                      filled: false,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 81, 149, 72),
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
                    ),
                    obscureText: true,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 81, 149, 72)), // 텍스트 색상 변경
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 81, 149, 72)),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: isLoading ? null : () => _login(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 81, 149, 72)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('로그인'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _goToSignUp(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 81, 149, 72)),
                        ),
                        child: const Text('회원가입'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _kakaoLogin(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 81, 149, 72)),
                        ),
                        child: const Text('카카오 로그인'),
                      ),
                    ],
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
