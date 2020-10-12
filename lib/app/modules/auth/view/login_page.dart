import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pizza_delivery_app/app/modules/auth/controller/login_controller.dart';
import 'package:pizza_delivery_app/app/modules/auth/view/register_page.dart';
import 'package:pizza_delivery_app/app/modules/splahs/view/splash_page.dart';
import 'package:pizza_delivery_app/app/shared/componets/piazza_delivery_input.dart';
import 'package:pizza_delivery_app/app/shared/componets/pizza_delivery_button.dart';
import 'package:pizza_delivery_app/app/shared/mixins/loader_mixin.dart';
import 'package:pizza_delivery_app/app/shared/mixins/message_mixin.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatelessWidget {
  static const router = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
              create: (context) => LoginController(), child: LoginContent()),
        ),
      ),
    );
  }
}

class LoginContent extends StatefulWidget {
  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with LoaderMixin, MessageMixin {
  final formKey = GlobalKey<FormState>();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final obscurePasswordValueNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    final loginController = context.read<LoginController>();
    loginController.addListener(() {
      showHideLoaderHelper(context, loginController.showLoader);

      if (!isNull(loginController.error)) {
        showError(message: loginController.error, context: context);
      }

      if (loginController.loginSuccess) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashPage.router, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 250,
          fit: BoxFit.cover,
        ),
        Container(
          child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    PizzaDeliveryInput(
                      'E-mail',
                      controller: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!isEmail(value?.toString()) ?? '') {
                          return 'Email inválido';
                        }

                        return null;
                      },
                    ),
                    ValueListenableBuilder(
                        valueListenable: obscurePasswordValueNotifier,
                        builder: (_, obscurePasswordValueNotifierValue, child) {
                          print('build value notifier');
                          return PizzaDeliveryInput(
                            'Password',
                            controller: passwordEditingController,
                            suffixIcon: Icon(FontAwesome.key),
                            obscureText: obscurePasswordValueNotifierValue,
                            suffixIconOnPressed: () {
                              obscurePasswordValueNotifier.value =
                                  !obscurePasswordValueNotifier.value;
                            },
                            validator: (value) {
                              if (!isLength(value.toString(), 6)) {
                                return 'Senha dever ter no mínimo 6 caracteres';
                              }
                              return null;
                            },
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    PizzaDeliveryButton(
                      'Login',
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      labelColor: Colors.white,
                      buttonColor: Theme.of(context).primaryColor,
                      labelSize: 18,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          context.read<LoginController>().login(
                              emailEditingController.text,
                              passwordEditingController.text);
                        }
                      },
                    ),
                    SizedBox(height: 50),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(RegisterPage.router);
                        },
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(fontSize: 20, fontFamily: 'Arial'),
                        )),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
