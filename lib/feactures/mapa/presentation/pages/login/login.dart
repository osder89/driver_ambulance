// ignore_for_file: must_be_immutable

import 'package:driver_ambulance/feactures/core/utils/dimensions.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/widgets/big_text.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/widgets/button.dart';
import 'package:driver_ambulance/feactures/mapa/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../utils/colors.dart';

class LogIn extends StatelessWidget {
  static const routeName = '/login_page';
  bool driverLogin = true;

  LogIn({super.key, this.driverLogin = true});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Dimensions.width15, Dimensions.height10,
              Dimensions.width15, Dimensions.height30),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Image.network(
                            'https://www.pngkit.com/png/detail/251-2511622_ambulance-drawing-side-view-ambulance-cartoon.png')),
                    SizedBox(
                      height: Dimensions.height15,
                    ),

                    Row(
                      children: [
                        const Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 2,
                            color: AppColors.black,
                          ),
                        )),
                        BigText(
                          text: 'Last Minute',
                          size: Dimensions.font20 * 1.8,
                        ),
                        const Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 2,
                            color: AppColors.black,
                          ),
                        )),
                      ],
                    )
                    // Button(
                    //   on_pressed: () {},
                    //   text: 'EMERGENCY',
                    //   radius: Dimensions.radius20 * 2,
                    //   width: double.maxFinite,

                    //   color: AppColors.deepRed,
                    // ),
                  ],
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            //controller.onSendOtp();
                          },
                          child: Container(
                            width: Dimensions.width40 * 8,
                            height: Dimensions.height20 * 2.5,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                border: Border.all(
                                    color: colors.primaryColor, width: 2)),
                            child: Center(
                              child: Text('numero'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      BigText(
                        text: 'Introduzca su numero',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: PinCodeTextField(
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(15),
                                activeColor: colors.primaryColor,
                                inactiveColor: colors.secondaryHeaderColor,
                                selectedColor: AppColors.pink,
                              ),
                              appContext: context,
                              length: 8,
                              onChanged: (value) {}),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      BigText(text: 'By clicking Login, you accept our'),
                      BigText(
                        text: 'Terms and Conditions',
                        color: Colors.blueAccent,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      Button(
                        width: double.maxFinite,
                        height: Dimensions.height40 * 1.5,
                        radius: Dimensions.radius20 * 2,
                        on_pressed: () {
                          context.push('/mapa');
                        },
                        text: 'LogIn',
                        color: colors.primaryColor,
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Text_Field(
                radius: Dimensions.radius20,
                text_field_width: double.maxFinite,
                text_field_height: Dimensions.height20 * 3,
                text_field: TextField(
                  //controller:
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: AppColors.pink,
                    ),
                    hintText: 'Mobile Number',
                  ),
                )),
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          Button(
            width: double.maxFinite,
            height: Dimensions.height40 * 1.5,
            radius: Dimensions.radius20 * 2,
            on_pressed: () {},
            text: 'Send Otp',
            color: AppColors.pink,
          ),
        ],
      ),
    );
  }
}
