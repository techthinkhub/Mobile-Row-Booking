import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../componen/color.dart';
import '../../../componen/custom_widget.dart';
import '../../../routes/app_pages.dart';
import '../componen/fade_animationtest.dart';
import '../controllers/authorization_controller.dart';

class AuthorizationView extends GetView<AuthorizationController> {
  const AuthorizationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.black,
        ),
        toolbarHeight: 0,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 600,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black
                        .withOpacity(0.0),
                    Colors.black
                        .withOpacity(0.2),
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: FadeInAnimation(
                      delay: 2.8,
                      child: CustomElevatedButton(
                        message: "Masuk",
                        function: () async {
                          HapticFeedback.lightImpact();
                          Get.toNamed(Routes.SINGIN);
                        },
                        color: MyColors.appPrimaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: FadeInAnimation(
                      delay: 3.0,
                      child: CustomElevatedButton2(
                        message: "Register",
                        function: () async {
                          HapticFeedback.lightImpact();
                          Get.toNamed(Routes.SINGUP);
                        },
                        color: Colors.white,
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
