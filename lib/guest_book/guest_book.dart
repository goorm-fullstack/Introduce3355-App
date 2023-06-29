import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

const double kDefaultPadding = 20.0;

class MainSubScreen extends StatelessWidget {
  const MainSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          10,
          (index) => FeaturePlantCard(
            index: index,
            color: index % 2 == 0
                ? const Color(0xFFFEF0D6)
                : const Color(0xFFF1F2F4),
            press: () {},
          ),
        ),
      ),
    );
  }
}

class FeaturePlantCard extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FeaturePlantCard({
    Key? key,
    required this.index,
    required this.color,
    this.press = defaultFunction,
  }) : super(key: key);

  static void defaultFunction() {}

  final int index;
  final Color color;
  final void Function() press;

  final _formKey = GlobalKey<FormBuilderState>();

  void _saveGuestBook(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final originalData = _formKey.currentState!.value;
      final data = {...originalData};
      data['date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());

      try {
        await firestore.collection('guest_book').add(data);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('방명록 등록이 성공적으로 완료되었습니다!')));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('방명록 등록이 완료되지 못했습니다...!')));
        print('Error saving to guest book: $e');
      }
    } else {
      print("저장된 값 없어 이거 나오면 나 오늘 못잠");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getGuestBookStream() {
    return firestore.collection('guest_book').snapshots();
  }

  Widget _buildGuestBookEntry(
      BuildContext context, DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final entry = snapshot.data();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('방명록 내용'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('${entry?['date'] ?? ''}'),
                    Text('${entry?['detail'] ?? ''}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(entry?['detail'] ?? ''),
              ),
            ],
          ),
          Positioned(
            right: 4,
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  entry?['date'] ?? '',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final _formKey = GlobalKey<FormBuilderState>();
                        return AlertDialog(
                          title: Text('삭제 및 수정'),
                          content: SingleChildScrollView(
                            child: FormBuilder(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  FormBuilderTextField(
                                    name: 'name',
                                    decoration:
                                        InputDecoration(labelText: '닉네임'),
                                  ),
                                  FormBuilderTextField(
                                    name: 'password',
                                    decoration:
                                        InputDecoration(labelText: '비밀번호'),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final enteredName =
                                      _formKey.currentState!.value['name'];
                                  final enteredPassword =
                                      _formKey.currentState!.value['password'];
                                  if (entry?['name'] == enteredName &&
                                      entry?['password'] == enteredPassword) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('수정 / 삭제'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text('수정 또는 삭제를 선택하세요.'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('수정'),
                                              onPressed: () {
                                                // 수정 로직 구현
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('삭제'),
                                              onPressed: () {
                                                // 삭제 로직 구현
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    // 이름과 비밀번호가 일치하지 않을 때
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(''),
                                          content: Text(
                                              '닉네임과 비밀번호가 일치하지 않습니다.\n다시 한번 확인해주세요!'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('닫기'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                            TextButton(
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.black, // 검정색 배경 설정
                      shape: BoxShape.circle, // 원형 모양 설정
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Image.asset(
                        'assets/images/btn_modify.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//

//

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '방명록 작성하기',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: InputDecoration(
                            labelText: '닉네임',
                            labelStyle: TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            labelStyle: TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'detail',
                          decoration: InputDecoration(
                            labelText: '방명록 내용을 입력해주세요.',
                            labelStyle: TextStyle(color: Colors.black87),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          maxLines: 5,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "취소",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            ElevatedButton(
                              onPressed: () => _saveGuestBook(context),
                              child: Text(
                                "등록",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width / 3 - kDefaultPadding * 1.5,
        height: size.width / 3 - kDefaultPadding * 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: index == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: kDefaultPadding - 8.0, // 텍스트 왼쪽으로
                    top: kDefaultPadding - 1.0, // 텍스트 아래로
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '방명록\n작성하기',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                        ),
                        Image.asset(
                          'assets/images/btn_more_hover.png',
                          width: 35,
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : index > 0
                ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _getGuestBookStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final entries = snapshot.data!.docs;

                      if (entries.isEmpty) {
                        return const Text(
                            '\n\n 등록된 방명록이\n 없습니다.'); //파이어베이스에서 가져올 정보 없으면 출력하는 곳
                      }

                      if (index - 1 < entries.length) {
                        return _buildGuestBookEntry(
                            context, entries[index - 1]);
                      }

                      return Container();
                    },
                  )
                : null,
      ),
    );
  }
}
