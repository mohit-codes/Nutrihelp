import 'package:client/resources/api_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  ApiProvider apiProvider = ApiProvider();
  String otpString = "";
  String emailString = "";
  bool _visibleLogin = true;

  bool requestOtp() {
    final form = _formKey.currentState;
    if (form.validate()) {
      apiProvider.auth(context, emailString);

      return true;
    }
    return false;
  }

  void login() {
    apiProvider.auth(context, emailString, otp: otpString);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffA6E97C), Color(0xffF4F4F4)])),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Stack(alignment: AlignmentDirectional.topCenter, children: [
              Positioned(
                  right: deviceWidth * -0.15,
                  child: Image.asset(
                    'assets/images/upperloginscreen.png',
                    height: deviceHeight * 0.25,
                  )),
              Positioned(
                  left: deviceWidth * -0.15,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/lowerloginscreen.png',
                    height: deviceHeight * 0.25,
                  )),
              Positioned(
                top: deviceHeight * 0.3,
                child: Text('Health Predictor',
                    style: GoogleFonts.redressed(
                        textStyle: TextStyle(
                            color: Colors.black, fontSize: deviceWidth * 0.1))),
              ),
              AnimatedPositioned(
                  top:
                      _visibleLogin ? deviceHeight * 0.42 : deviceHeight * 0.32,
                  duration: const Duration(milliseconds: 400),
                  child: Column(children: [
                    AnimatedOpacity(
                      opacity: _visibleLogin ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          width: deviceWidth * 0.8,
                          child: TextFormField(
                            validator: (val) =>
                                !EmailValidator.validate(val, true)
                                    ? 'Enter a valid email.'
                                    : null,
                            onChanged: (value) => emailString = value,
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              hintText: 'Email',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(20)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 0),
                                  borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 100),
                                  borderRadius: BorderRadius.circular(20)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(
                                left: deviceWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedOpacity(
                        alwaysIncludeSemantics: true,
                        opacity: _visibleLogin ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: deviceWidth * 0.7,
                              child: PinCodeTextField(
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.fade,
                                animationDuration:
                                    const Duration(milliseconds: 10),
                                enableActiveFill: true,
                                appContext: context,
                                length: 4,
                                onChanged: (value) {
                                  setState(() {
                                    otpString = value;
                                  });
                                },
                                cursorColor: Colors.black,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10),
                                  fieldWidth: deviceWidth * 0.15,
                                  selectedFillColor: Colors.white,
                                  // selectedColor: colors,
                                  inactiveColor: Colors.white,
                                  disabledColor: Colors.white,
                                  borderWidth: 1.5,
                                  inactiveFillColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )),
                  ])),
              Positioned(
                  top: deviceHeight * 0.55,
                  child: TextButton(
                    onPressed: () {
                      if (_visibleLogin) {
                        if (requestOtp()) {
                          setState(() {
                            _visibleLogin = !_visibleLogin;
                          });
                        }
                      } else {
                        login();
                      }
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      minimumSize:
                          Size(deviceWidth * 0.25, deviceHeight * 0.07),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      backgroundColor: const Color(0xff05483F),
                    ),
                    child: !_visibleLogin
                        ? Text('LOGIN',
                            style: TextStyle(fontSize: deviceWidth * 0.05))
                        : Text(' Request OTP ',
                            style: TextStyle(fontSize: deviceWidth * 0.05)),
                  ))
            ])));
  }
}
