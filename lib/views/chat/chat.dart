import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/chat_controller.dart';
import 'package:pharmacy_mobile/views/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/views/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

import 'widgets/chat_list.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.find();
    chatController.getChats(userController.user.value!.id!);
    return Scaffold(
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: "Đơn hàng",
        rightWidget: NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: const NeumorphicBoxShape.circle(),
            color: context.theme.canvasColor,
            shape: NeumorphicShape.flat,
          ),
          onPressed: () => chatController.createRequestDialog(),
          child: Icon(
            Icons.add_comment_rounded,
            color: context.theme.primaryColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  final messages = chatController.chats;

                  if (chatController.isLoading.isTrue) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (messages.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Chưa có yêu cầu, nếu bạn có yêu cầu, xin đừng ngại liên hệ với chúng tôi",
                        ),
                      ),
                    );
                  } else {
                    return ChatList(
                      messages: messages,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
