/* import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../data/user/user.dart';
import '../domain/repositories/app_repo.dart';
import '../domain/repositories/auth_repo.dart';
import '../presentation/utils/colors.dart';
import '../presentation/utils/constants.dart';
import '../presentation/utils/validators.dart';
import '../presentation/utils/values.dart';
import '../presentation/widgets/app_text_form_field.dart';
import '../presentation/widgets/column_pro.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'signup_controller.dart';

class SignupScreen extends GetView<SignupController> {
  SignupScreen({Key? key}) : super(key: key);

  Future<void> _launchInBrowser(
    String host,
  ) async {
    final Uri toLaunch = Uri.parse(host);
    //Uri(scheme: 'https', host: host, path:  path);
    if (!await launchUrl(
      toLaunch,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $toLaunch';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create  Account',
          style: Get.textTheme.titleLarge,
        ),
        leading: InkWell(
            onTap: () {
              debugPrint(Get.previousRoute);
              if (Get.previousRoute.contains('BOTTOMSHEET')) {
                AuthRepository.instance.userType = UserType.guest;
                Get.back();
              } else
                Get.back();
            },
            child: Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          if (Get.previousRoute.contains('BOTTOMSHEET')) {
            AuthRepository.instance.userType = UserType.guest;
            Get.back();
          } else
            Get.back();
          return true;
        },
        child: Form(
          key: controller.formKey,
          child: FlexibleScrollViewColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            padding: EdgeInsets.all(AppPadding.p24),
            children: [
              AppTextFormField(
                label: 'Full Name (Surname first)',
                autofillHints: [AutofillHints.name],
                hintText: 'e.g Avan David',
                onSaved: (val) => controller.name = val!,
                validator: Validator.isName,
              ),
              spacer(),
              AppTextFormField(
                label: 'Email Address',
                autofillHints: [AutofillHints.email],
                hintText: 'e.g alexushud@gmail.com',
                onSaved: (val) => controller.email = val!.trim(),
                validator: Validator.isEmail,
              ),
              spacer(),
              if (AppRepository.userIsVendor)
                Column(
                  children: [
                    AppTextFormField(
                      label: 'Branch Email Address',
                      autofillHints: [AutofillHints.email],
                      hintText: 'e.g alexushud@gmail.com',
                      onSaved: (val) => controller.branchEmail = val!.trim(),
                      //validator: Validator.isOptional,
                    ),
                    spacer(),
                  ],
                ),
              AppTextFormField(
                label: 'Phone Number',
                textInputType: TextInputType.phone,
                hintText: 'e.g 08134574947',
                autofillHints: [AutofillHints.telephoneNumber],
                validator: Validator.isPhone,
                onSaved: (val) => controller.phone = val!.trim(),
              ),
              spacer(),
              AppTextFormField(
                label: 'Referrer Code (Optional)',
                textInputType: TextInputType.name,
                hintText: 'Enter Your Referrer Code',
                // validator: Validator.isReferrerCode,
                onSaved: (val) => controller.referrerCode = val!.trim(),
              ),
              spacer(),
              Obx(() => AppTextFormField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    autofillHints: [AutofillHints.password],
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
              spacer(),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.agreedToTerms.value,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        controller.onCheckboxChanged(val);
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _launchInBrowser('https://terms.foodelo.africa');
                      },
                      child: RichText(
                        text: TextSpan(
                            text: 'I agree to ',
                            style: Get.textTheme.titleSmall,
                            children: [
                              TextSpan(
                                  text: 'terms and conditions',
                                  style: Get.textTheme.titleSmall!.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ))
                            ]),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: AppSize.s48),
              ElevatedButton(
                child: Text('Create account'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
                onPressed: controller.createAccount,
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
              //   label: Text('Sign up with Google'),
              //   icon: Image.asset('assets/icons/google_icon.png'),
              //   onPressed: () {},
              // ),
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              /*if (!AppRepository.userIsVendor)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.shade100),
                  onPressed: controller.onContinuePressed,
                  child: Text(
                    'Continue as a guest',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),*/
              Expanded(
                child: SizedBox(
                  height: AppSize.s16,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style:
                      Get.textTheme.labelLarge!.copyWith(letterSpacing: 0.75),
                  text: "I have an account - ",
                  children: [
                    TextSpan(
                      text: 'Log In',
                      style: TextStyle(color: AppColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (AppRepository.userIsGuest) {
                            Get.toNamed(Routes.login);
                          } else
                            Get.back();
                        },
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