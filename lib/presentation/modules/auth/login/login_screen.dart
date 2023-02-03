/* import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../domain/repositories/app_repo.dart';
import '../presentation/modules/auth/login/login_controller.dart';
import '../presentation/utils/colors.dart';
import '../presentation/utils/constants.dart';
import '../presentation/utils/validators.dart';
import '../presentation/utils/values.dart';
import '../presentation/widgets/app_text_form_field.dart';
import '../presentation/widgets/column_pro.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      if (AppRepository.userIsCustomer) {
        /*controller.emailText.text = 'Iceyventures@gmail.com';
        controller.passText.text = 'foodelo12';
       */ /*controller.emailText.text = 'Usmanhaleemah67h@gmail.com';
        controller.passText.text = 'lovelyfood';*/

        controller.emailText.text = 'seyipaye+123@outlook.com';
        controller.passText.text = 'Seyi1234';
/*
        controller.emailText.text = 'seyi.ipaye+1@foodelo.africa';
        controller.passText.text = 'foodelo12';*/
      } else {
        /*controller.emailText.text = 'Iceyventures@gmail.com';
        controller.passText.text = 'foodelo12';
*/
        controller.emailText.text = 'alobently+13@outlook.com';
        controller.passText.text = 'alo12345';
       
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: Get.previousRoute == Routes.customerTypeScreen
            ? IconButton(
                onPressed: () {
                  Get.back();
                  //  Get.toNamed(Routes.customerTypeScreen);
                },
                icon: Icon(Icons.arrow_back),
              )
            : IconButton(
                onPressed: () {
                  Get.offNamed(Routes.customerTypeScreen);
                  //  Get.toNamed(Routes.customerTypeScreen);
                },
                icon: Icon(Icons.arrow_back),
              ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome Back ',
              style: Get.textTheme.titleLarge,
            ),
            ImageIcon(
              AssetImage('assets/icons/hand_wave.png'),
              color: AppColors.primary,
              size: 24,
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: FlexibleScrollViewColumn(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(AppPadding.p24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextFormField(
                        textEditingController: controller.emailText,
                        label: 'Email Address',
                        autofillHints: [AutofillHints.email],
                        hintText: 'e.g alexushud@gmail.com',
                        onSaved: (val) => controller.email = val!.trim(),
                        validator: Validator.isEmail,
                      ),
                      spacer(),
                      Obx(() => AppTextFormField(
                            textEditingController: controller.passText,
                            label: 'Password',
                            autofillHints: [AutofillHints.password],
                            hintText: 'Enter your password',
                            obscureText: controller.hidePassword.value,
                            validator: Validator.isPassword,
                            onSaved: (val) => controller.password = val!.trim(),
                            suffixIcon: IconButton(
                              icon: controller.hidePassword.value
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.remove_red_eye),
                              onPressed: controller.hidePasswordPressed,
                            ),
                          )),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            'Forgot password',
                            textAlign: TextAlign.right,
                            style: Get.textTheme.labelLarge!.copyWith(
                              letterSpacing: 0.75,
                              color: AppColors.primary,
                            ),
                          ),
                          onPressed: controller.onForgetPasswordPressed,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        child: Text('Log In'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: controller.onLoginPressed,
                      ),
                      SizedBox(height: AppSize.s8),
                      // Row(
                      //   children: [
                      //     Expanded(child: Divider()),
                      //     Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 25),
                      //         child: Text('OR')),
                      //     Expanded(child: Divider())
                      //   ],
                      // ),
                      // SizedBox(height: AppSize.s8),
                      // OutlinedButton.icon(
                      //   label: Text('Sign in with Google'),
                      //   icon: Image.asset('assets/icons/google_icon.png'),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Get.textTheme.labelLarge!.copyWith(
                    letterSpacing: 0.75,
                  ),
                  text: "Don’t have an account? - ",
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(color: AppColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = controller.onSignupTap,
                    ),
                  ],
                ),
              ),
              spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
 */