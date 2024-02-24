import 'package:absensi/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../provider/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
        () => Provider.of<LoginProvider>(context, listen: false)..getInfo());
  }

  final formKey = GlobalKey<FormState>();
  double getSmallDiameter = Get.width * 2 / 3;
  double getBigDiameter = Get.size.width * 7 / 8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Consumer<LoginProvider>(builder: (context, provider, _) {
        return Stack(
          children: [
            Positioned(
              right: -getSmallDiameter / 3,
              top: -getSmallDiameter / 3,
              child: Container(
                width: getSmallDiameter,
                height: getSmallDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue[200]!, Colors.blueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
            ),
            Positioned(
              left: -getBigDiameter / 4,
              top: -getBigDiameter / 4,
              child: Container(
                width: getBigDiameter,
                height: getBigDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.blueAccent[700]!, Colors.blueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.h)),
                      ),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    const Text(
                      'Sistem Absensi Pegawai',
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListView(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5.0, 350, 5.0, 10),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                      child: Card(
                        elevation: 6.0,
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                _buildEmailForm(),
                                _buildPasswordForm()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Lupa Password?',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 40.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.lightBlue[700]!,
                                    Colors.lightBlue[900]!
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10.0),
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    provider.login().then((response) {
                                      provider.afterLogin(context, response);
                                    });
                                  }
                                },
                                child: Center(
                                  child: context.watch<LoginProvider>().state ==
                                          RequestState.loading
                                      ? const SizedBox(
                                          height: 30.0,
                                          width: 30.0,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          'MASUK',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Sistem Absensi Pegawai Online',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmailForm() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong!';
        }
        return null;
      },
      controller: context.watch<LoginProvider>().emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent)),
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.blueAccent[700],
          ),
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.blueAccent[200])),
      style: TextStyle(color: Colors.blueAccent[700]),
    );
  }

  Widget _buildPasswordForm() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong!';
        }
        return null;
      },
      obscureText: context.watch<LoginProvider>().isPasswordVisible,
      controller: context.read<LoginProvider>().passwordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent)),
          suffixIcon: GestureDetector(
            onTap: () {
              Provider.of<LoginProvider>(context, listen: false)
                  .setPasswordVisible();
            },
            child: Icon(
              context.watch<LoginProvider>().isPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.blueAccent[700],
            ),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.blueAccent[700],
          ),
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.blueAccent[200])),
      style: TextStyle(color: Colors.blueAccent[700]),
    );
  }
}
