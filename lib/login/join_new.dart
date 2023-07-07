import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goorm_3355/login/log.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  String? _errorMessage;

  Future<bool?> _onBackPressed() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // 사용자가 팝업 외부를 터치해도 닫히지 않도록 설정
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('경고'),
          content: const Text('회원가입을 취소하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }

  void _signUpAndVerifyEmail(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      if (kDebugMode) {
        print('회원가입 실패');
      }
      setState(() {
        isLoading = false;
      });
    } else if (_passwordController.text != _confirmPasswordController.text) {
      if (kDebugMode) {
        print('회원가입 실패');
      }
      setState(() {
        isLoading = false;
      });
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          // ignore: deprecated_member_use
          await user.updateProfile(displayName: _nameController.text);
          if (kDebugMode) {
            print('Signed in as ${user.email}');
          }
          if (kDebugMode) {
            print('Signed in as ${user.displayName}');
          } //추가

          await user.sendEmailVerification();

          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('인증 메일 전송'),
              content:
                  const Text('회원님의 이메일로 인증 메일을 보냈습니다. 확인 후 이메일 인증을 완료해주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _completeSignUp(context);
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          );

          if (kDebugMode) {
            print(
                '회원가입 성공: 이름: ${_nameController.text}, 이메일: ${_emailController.text}, 비밀번호: ${_passwordController.text}');
          }
        } else {
          if (kDebugMode) {
            print('No user signed in.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _completeSignUp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyHomePage2()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        return result ?? false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Unknown.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ), // 상태 표시줄 높이만큼 간격 추가
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _onBackPressed().then((value) {
                          if (value == true) {
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 16),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '\n Sign up\n',
                            style: TextStyle(
                              fontSize: 48,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 81, 149, 72),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: '성함',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 81, 149, 72),
                            ),
                            filled: false,
                            fillColor: const Color.fromARGB(255, 81, 149, 72),
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
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: '이메일',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 81, 149, 72),
                            ),
                            filled: false,
                            fillColor: const Color.fromARGB(255, 81, 149, 72),
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
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 81, 149, 72),
                            ),
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
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: '비밀번호 확인',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 81, 149, 72),
                            ),
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
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 81, 149, 72),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () => _signUpAndVerifyEmail(context),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  '이메일 인증 및 회원가입',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
