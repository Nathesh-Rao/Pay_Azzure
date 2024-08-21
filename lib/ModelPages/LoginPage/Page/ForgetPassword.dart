import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Controller/ForgetPasswordController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});
  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: MyColors.blue2,
                ),
                onPressed: () {
                  Get.back();
                }),
            title: Text(
              "Forgot Password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: MyColors.blue2, fontFamily: 'redhatsmbold'),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset(
                  'assets/images/pay_azzure_text.png',
                  width: 90,
                  height: 35,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
              elevation: 40,
              color: MyColors.white1,
              shadowColor: MyColors.buzzilyblack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: forgetPasswordController.OTPSent.value
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "OTP sent successfully",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height * 0.02,
                                color: MyColors.blue1,
                                fontFamily: 'opensansbold'),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Enter OTP',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.height * 0.02,
                                    color: MyColors.blue2,
                                    fontFamily: 'poppinssemibold'),
                              ),
                              forgetPasswordController.showTimer.value
                                  ? Text(
                                      "Resend OTP in " + forgetPasswordController.timerText.value.toString(),
                                      style: const TextStyle(color: MyColors.blue2, fontSize: 15, fontWeight: FontWeight.w700),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        forgetPasswordController.reSendOTP();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            border: Border.all(width: 2, color: MyColors.blue2)),
                                        child: Text(
                                          "Resend OTP",
                                          style: TextStyle(
                                              color: MyColors.blue2,
                                              fontFamily: 'redhabold',
                                              fontSize: MediaQuery.of(context).size.height * 0.01),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            obscureText: !forgetPasswordController.showOTP.value,
                            controller: forgetPasswordController.otpController,
                            maxLength: int.tryParse(forgetPasswordController.otpLength.value ?? "8"),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorText:
                                  forgetPasswordController.otpError.value == "" ? null : forgetPasswordController.otpError.value,
                              hintText: 'OTP',
                              hintStyle: const TextStyle(
                                fontSize: 15,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  forgetPasswordController.showOTP.value ? Icons.visibility_off : Icons.visibility,
                                  color: MyColors.buzzilyblack,
                                ),
                                onPressed: () {
                                  forgetPasswordController.showOTP.toggle();
                                },
                              ),
                              filled: true,
                              fillColor: MyColors.buzzilygrey,
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Proxima_Nova_Regular',
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: MyColors.white1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Enter New Password',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.height * 0.02,
                                    color: MyColors.blue2,
                                    fontFamily: 'poppinssemibold'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            textInputAction: TextInputAction.next,
                            obscureText: !forgetPasswordController.showPass.value,
                            controller: forgetPasswordController.passwordController,
                            //  enabled: false,
                            decoration: InputDecoration(
                              errorText: forgetPasswordController.passError.value == ""
                                  ? null
                                  : forgetPasswordController.passError.value,
                              errorMaxLines: 2,
                              hintText: 'New Password',
                              hintStyle: const TextStyle(
                                fontSize: 15,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  forgetPasswordController.showPass.value ? Icons.visibility_off : Icons.visibility,
                                  color: MyColors.buzzilyblack,
                                ),
                                onPressed: () {
                                  forgetPasswordController.showPass.toggle();
                                },
                              ),
                              filled: true,
                              fillColor: MyColors.buzzilygrey,
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Proxima_Nova_Regular',
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: MyColors.white1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Enter Confirm Password',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.height * 0.02,
                                    color: MyColors.blue2,
                                    fontFamily: 'poppinssemibold'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            textInputAction: TextInputAction.next,
                            obscureText: !forgetPasswordController.showConPass.value,
                            controller: forgetPasswordController.confirmPasswordController,
                            //  enabled: false,
                            decoration: InputDecoration(
                              errorText: forgetPasswordController.conPassError.value == ""
                                  ? null
                                  : forgetPasswordController.conPassError.value,
                              hintText: 'Confirm Password',
                              hintStyle: const TextStyle(
                                fontSize: 15,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  forgetPasswordController.showConPass.value ? Icons.visibility_off : Icons.visibility,
                                  color: MyColors.buzzilyblack,
                                ),
                                onPressed: () {
                                  forgetPasswordController.showConPass.toggle();
                                },
                              ),
                              filled: true,
                              fillColor: MyColors.buzzilygrey,
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Proxima_Nova_Regular',
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: MyColors.white1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {
                              forgetPasswordController.submitOTPClicked();
                            },
                            child: Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    colors: [MyColors.blue1, MyColors.blue1],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft),
                              ),
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/pay_azzure_text.png',
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Forgot Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height * 0.03,
                                color: MyColors.blue2,
                                fontFamily: 'redhatsmbold'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Enter email to reset password',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.height * 0.02,
                                color: MyColors.blue2),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            controller: forgetPasswordController.userNameController,
                            textInputAction: TextInputAction.next,
                            //keyboardType: TextInputType.emailAddress,
                            //  enabled: false,
                            decoration: InputDecoration(
                              hintText: 'User Name',
                              errorText: forgetPasswordController.errUserName.value == ""
                                  ? null
                                  : forgetPasswordController.errUserName.value,
                              hintStyle: const TextStyle(
                                fontSize: 15,
                              ),
                              filled: true,
                              fillColor: MyColors.buzzilygrey,
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Proxima_Nova_Regular',
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: MyColors.white1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: forgetPasswordController.emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            //  enabled: false,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              errorText: forgetPasswordController.emailError.value == ""
                                  ? null
                                  : forgetPasswordController.emailError.value,
                              hintStyle: const TextStyle(
                                fontSize: 15,
                              ),
                              filled: true,
                              fillColor: MyColors.buzzilygrey,
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Proxima_Nova_Regular',
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: MyColors.white1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: InkWell(
                              onTap: () {
                                forgetPasswordController.proceedButtonClicked();
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(color: MyColors.blue2, borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    'Proceed',
                                    style: TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 70),
                        ],
                      ),
              ),
            ),
          ),
        ));
  }
}
