import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pharmacy_mobile/controllers/chat_controller.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/views/address/address.dart';
import 'package:pharmacy_mobile/views/signin/signin.dart';
import 'package:pharmacy_mobile/views/signup/widgets/gender.dart';
import 'package:pharmacy_mobile/views/user/widget/profile_image.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';
import 'package:pharmacy_mobile/widgets/input.dart';
import 'package:pharmacy_mobile/widgets/scroll_behavior.dart';

import '../../helpers/snack.dart';
import '../../services/user_service.dart';
import '../../widgets/button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController mailCtl = TextEditingController();
  TextEditingController dobCtl = TextEditingController();
  TextEditingController addressCtl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> tokenMap;

  String imgUrl = '';

  Map<String, dynamic> userMap = {
    "fullname": "string",
    "phoneNo": "string",
    "email": "user@example.com",
    "gender": 0,
    "imageUrl": "string",
    "dob": "2023-04-11",
    "cityId": "string",
    "districtId": "string",
    "wardId": "string",
    "homeAddress": "string"
  };

  String address = "";

  bool isMale = true;

  @override
  void initState() {
    Get.log(Get.arguments.toString());
    tokenMap = JwtDecoder.decode(Get.arguments['token']);
    try {
      phoneCtl.text =
          (tokenMap['phone_number'] as String).convertToOriginalPhone;
      userMap['phoneNo'] =
          (tokenMap['phone_number'] as String).convertToOriginalPhone;
    } catch (e) {
      Get.log('Error: $e');
      phoneCtl.text = "";
    }
    super.initState();
  }

  void genderSelect(bool value) {
    userMap['gender'] = value ? 0 : 1;
    setState(() {
      isMale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool result = true;
    RegExp numberPattern = RegExp(r'\d');
    RegExp specialCharPattern = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    try {
      final box = GetStorage();
      result = box.read("isFirst");
    } catch (e) {
      Get.log(e.toString());
    }
    return Scaffold(
      appBar: PharmacyAppBar(
        leftWidget: PharmacyBackButton(fn: () {
          SignupController controller = Get.find();
          controller.codeSent.value = false;
        }),
        midText: "Đăng kí",
        rightWidget: Container(),
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: SizedBox(
                        height: Get.height * 0.65,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CircleProfilePicture(
                                  imageUrl: imgUrl,
                                  size: Get.height * .15,
                                  onTap: () async {
                                    if (imgUrl.isNotEmpty) {
                                      Get.defaultDialog(
                                        title: 'Thay đổi ảnh đại diện',
                                        middleText:
                                            'Bạn có muốn xóa hoặc thay đổi ảnh này không?',
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('Huỷ'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                imgUrl = '';
                                              });
                                              Get.back();
                                            },
                                            child: const Text('Xóa'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Get.back();
                                              var res = await MessageController
                                                  .pickImage();
                                              if (res.isNotEmpty) {
                                                setState(() {
                                                  imgUrl = res;
                                                });
                                                userMap['imageUrl'] = res;
                                              }
                                            },
                                            child: const Text('Chọn ảnh khác'),
                                          ),
                                        ],
                                      );
                                    } else {
                                      var res =
                                          await MessageController.pickImage();
                                      if (res.isNotEmpty) {
                                        setState(() {
                                          imgUrl = res;
                                        });
                                        userMap['imageUrl'] = res;
                                      }
                                    }
                                  },
                                ),
                                const AutoSizeText(
                                  'Ảnh đại diện',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    letterSpacing: 2,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            Input(
                              isFormField: true,
                              validator: (p0) => p0!.isEmpty
                                  ? "Không được để trống"
                                  : (numberPattern.hasMatch(p0) ||
                                          specialCharPattern.hasMatch(p0))
                                      ? "Không được chứa ký tự đặc biệt hoặc số"
                                      : null,
                              inputController: nameCtl,
                              title: "Họ và tên",
                              onChanged: (p0) => userMap['fullname'] = p0,
                            ),
                            Input(
                              isFormField: true,
                              validator: (p0) =>
                                  p0!.isEmpty ? "Không được để trống" : null,
                              inputController: phoneCtl,
                              title: "Số điện thoại",
                              enabled: false,
                            ),
                            Input(
                              isFormField: true,
                              validator: (p0) => p0!.isNotEmpty
                                  ? p0.isEmail
                                      ? null
                                      : "Email không hợp lệ"
                                  : null,
                              inputController: mailCtl,
                              title: "Email (không bắt buộc)",
                              onChanged: (p0) {
                                p0.isEmail
                                    ? userMap['email'] = p0
                                    : userMap['email'] = "";
                              },
                            ),
                            GestureDetector(
                              onTap: () => showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                setState(() {
                                  if (value is DateTime) {
                                    final date = value.convertToDate;
                                    setState(() {
                                      dobCtl.text = date;
                                    });
                                    userMap['dob'] =
                                        value.toString().substring(0, 10);
                                  }
                                });
                              }),
                              child: Input(
                                isFormField: true,
                                validator: (p0) =>
                                    p0!.isEmpty ? "Không được để trống" : null,
                                inputController: dobCtl,
                                title: "Sinh nhật",
                                enabled: false,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                  useSafeArea: true,
                                  enableDrag: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(42.0),
                                      topRight: Radius.circular(42.0),
                                    ),
                                  ),
                                  context: Get.context!,
                                  builder: (context) =>
                                      const AddressSelectionScreen(
                                    isForCreateUser: true,
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      addressCtl.text =
                                          "${value['homeAddress']}, ${value['wardName']}, ${value['districtName']}, ${value['cityName']}";
                                      userMap['homeAddress'] =
                                          value['homeAddress'];
                                      userMap['wardId'] = value['wardId'];
                                      userMap['districtId'] =
                                          value['districtId'];
                                      userMap['cityId'] = value['cityId'];
                                    });
                                  }
                                });
                              },
                              child: Input(
                                isFormField: true,
                                validator: (p0) =>
                                    p0!.isEmpty ? "Không được để trống" : null,
                                title: "Địa chỉ",
                                inputController: addressCtl,
                                enabled: false,
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: GenderSelect(
                      isMale: isMale,
                      callback: genderSelect,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Hero(
                      tag: "signupBtn",
                      child: SizedBox(
                        width: 300.w,
                        height: 40.h,
                        child: PharmacyButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Get.log(userMap.toString());
                              var res =
                                  await UserService().registerUser(userMap);
                              if (res == 200) {
                                showSnack(
                                  "Đăng kí thành công",
                                  "Đăng nhập để tiếp tục",
                                  SnackType.success,
                                );
                                Get.offNamed('/signin');
                              }
                            }
                          },
                          text: "Đăng kí",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
