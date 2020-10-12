import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pizza_delivery_app/app/modules/auth/controller/register_controller.dart';
import 'package:pizza_delivery_app/app/shared/componets/piazza_delivery_input.dart';
import 'package:pizza_delivery_app/app/shared/componets/pizza_delivery_button.dart';
import 'package:pizza_delivery_app/app/shared/mixins/loader_mixin.dart';
import 'package:pizza_delivery_app/app/shared/mixins/message_mixin.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class RegisterPage extends StatelessWidget {
  static const router = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
              create: (context) => RegisterController(),
              child: RegisterContent()),
        ),
      ),
    );
  }
}

class RegisterContent extends StatefulWidget {
  @override
  _RegisterContentState createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent>
    with LoaderMixin, MessageMixin {
  final formKey = GlobalKey<FormState>();
  final obscureTextPassword = ValueNotifier<bool>(true);
  final obscureTextConfirmPassword = ValueNotifier<bool>(true);
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = context.read<RegisterController>();
    controller.addListener(() {
      showHideLoaderHelper(context, controller.showLoader);

      if (!isNull(controller.error)) {
        showError(message: controller.error, context: context);
      }

      if (controller.registerSuccess) {
        showSuccess(
            message: 'Usuário cadastrado com sucesso', context: context);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    PizzaDeliveryInput(
                      'Nome',
                      controller: nameEditingController,
                      validator: (value) {
                        if (isNull(value?.toString()) ||
                            value.toString().isEmpty) {
                          return 'Nome obrigatório';
                        }
                        return null;
                      },
                    ),
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
                        valueListenable: obscureTextPassword,
                        builder: (context, obscureTextPasswordValue, child) {
                          return PizzaDeliveryInput('Senha',
                              controller: passwordEditingController,
                              suffixIcon: Icon(FontAwesome.key),
                              obscureText: obscureTextPasswordValue,
                              suffixIconOnPressed: () {
                            obscureTextPassword.value =
                                !obscureTextPasswordValue;
                          }, validator: (value) {
                            if (isNull(value) ||
                                !isLength(value.toString(), 6)) {
                              return 'Senha precisar ter no mínimo 6 caracteres';
                            }
                            return null;
                          });
                        }),
                    ValueListenableBuilder(
                        valueListenable: obscureTextConfirmPassword,
                        builder:
                            (context, obscureTextConfirmPasswordValue, child) {
                          return PizzaDeliveryInput(
                            'Confirmar Senha',
                            controller: confirmPasswordEditingController,
                            suffixIcon: Icon(FontAwesome.key),
                            obscureText: obscureTextConfirmPasswordValue,
                            suffixIconOnPressed: () {
                              obscureTextConfirmPassword.value =
                                  !obscureTextConfirmPasswordValue;
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Confrima senha é obrigatório';
                              }

                              if (passwordEditingController.text !=
                                  value.toString()) {
                                return 'Senha e confirma senha não conferem ';
                              }

                              return null;
                            },
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    PizzaDeliveryButton('Salvar ',
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        labelColor: Colors.white,
                        buttonColor: Theme.of(context).primaryColor,
                        labelSize: 18, onPressed: () {
                      if (formKey.currentState.validate()) {
                        context.read<RegisterController>().registerUser(
                            nameEditingController.text,
                            emailEditingController.text,
                            passwordEditingController.text);
                      }
                    }),
                    SizedBox(height: 10),
                    PizzaDeliveryButton(
                      'Voltar',
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      labelColor: Colors.black,
                      labelSize: 18,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
