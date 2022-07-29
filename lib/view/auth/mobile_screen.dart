import 'package:country_phone_code_picker/core/country_phone_code_picker_widget.dart';
import 'package:country_phone_code_picker/models/country.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/common/button.dart';
import '../../common/colors.dart';
import '../../common/text.dart';
import '../../controller/mobile_auth_controller.dart';

class MobileScreen extends StatelessWidget {
  MobileScreen({Key? key}) : super(key: key);

  MobileController controller = Get.put(MobileController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Ts(
          text: "Enter your phone number",
          color: AppColors.mainColor,
          size: height * 0.025,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<MobileController>(
        init: MobileController(),
        builder: (value) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Ts(
                  text: 'whatsApp will need to verify your phone number',
                  size: height * 0.017,
                ),
                SizedBox(
                  height: height * 0.05,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: Row(
                    children: [
                      CountryPhoneCodePicker.withDefaultSelectedCountry(
                        defaultCountryCode: Country(
                            name: 'India', countryCode: 'IN', phoneCode: '+91'),
                        borderRadius: 0,
                        borderWidth: 1,
                        width: 80,
                        height: height * 0.06,
                        showPhoneCode: true,
                        showFlag: false,
                        borderColor: Colors.grey,
                        style: const TextStyle(fontSize: 16),
                        searchBarHintText: 'Search by name',
                      ),
                      Expanded(
                        child: Container(
                          height: height * 0.06,
                          width: width,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.textColor)),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                maxLength: 10,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.numberWithOptions(),
                                controller: controller.phone,
                                decoration: InputDecoration(
                                  counter: Offstage(),
                                  border: InputBorder.none,
                                  hintText: 'Enter Number',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),

                /// send otp
                value.isLoading == false
                    ? Button(
                        buttonName: 'NEXT',
                        onTap: () {
                          if (controller.phone.text.length < 10) {
                            showAlert('Enter 10 digit number');
                          } else {
                            controller.sendOtp(context);
                          }
                        },
                        buttonColor: AppColors.mainColor,
                        height: height * 0.045,
                        width: height * 0.11,
                        fontSize: height * 0.018,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                SizedBox(
                  height: height * 0.03,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
