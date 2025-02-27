import 'package:ccquarters/common_widgets/wide_text_button.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/states.dart';
import 'package:ccquarters/login_register/views/email_and_password_fields.dart';
import 'package:ccquarters/login_register/views/personal_info_fields.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LoginRegisterPageType {
  login,
  registerPersonalInfo,
  registerEmailAndPassword
}

class LoginRegisterView extends StatefulWidget {
  const LoginRegisterView({
    Key? key,
    required this.page,
    required this.user,
  }) : super(key: key);

  final LoginRegisterPageType page;
  final User user;
  @override
  State<LoginRegisterView> createState() => _LoginRegisterViewState();
}

class _LoginRegisterViewState extends State<LoginRegisterView> {
  final _formKey = GlobalKey<FormState>();
  final firstTextField = TextEditingController();
  final secondTextField = TextEditingController();
  final thirdTextField = TextEditingController();
  final fourthTextField = TextEditingController();

  @override
  void initState() {
    switch (widget.page) {
      case LoginRegisterPageType.login:
        firstTextField.text = widget.user.email;
        break;
      case LoginRegisterPageType.registerPersonalInfo:
        firstTextField.text = widget.user.company ?? "";
        secondTextField.text = widget.user.name ?? "";
        thirdTextField.text = widget.user.surname ?? "";
        fourthTextField.text = widget.user.phoneNumber ?? "";
        break;
      case LoginRegisterPageType.registerEmailAndPassword:
        firstTextField.text = widget.user.email;
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.read<AuthCubit>().state;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width),
        child: Scaffold(
          appBar: _buildAppBar(context),
          bottomNavigationBar: _buildBottomBar(context),
          resizeToAvoidBottomInset: false,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildWelcomeText(),
                  if (state is InputDataState && state.error != null)
                    _showErrors(state, context),
                  _buildFields(),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          switch (widget.page) {
            case LoginRegisterPageType.login:
              _saveEmail();
              context.read<AuthCubit>().goToStartPage();
              break;
            case LoginRegisterPageType.registerPersonalInfo:
              _savePersonalInfo();
              context.read<AuthCubit>().goToStartPage();
              break;
            case LoginRegisterPageType.registerEmailAndPassword:
              _saveEmail();
              context.read<AuthCubit>().goToPersonalInfoRegisterPage();
              break;
          }
        },
      ),
    );
  }

  Padding _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: mediumPaddingSize,
        bottom: mediumPaddingSize,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.page == LoginRegisterPageType.login
              ? "Nie masz jeszcze konta?"
              : "Masz już konto?"),
          TextButton(
            onPressed: () {
              switch (widget.page) {
                case LoginRegisterPageType.login:
                  _saveEmail();
                  context.read<AuthCubit>().goToPersonalInfoRegisterPage();
                  break;
                case LoginRegisterPageType.registerPersonalInfo:
                  _savePersonalInfo();
                  context.read<AuthCubit>().goToLoginPage();
                  break;
                case LoginRegisterPageType.registerEmailAndPassword:
                  _saveEmail();
                  context.read<AuthCubit>().goToLoginPage();
                  break;
              }
            },
            child: Text(widget.page == LoginRegisterPageType.login
                ? "Zarejestruj się"
                : "Zaloguj się"),
          )
        ],
      ),
    );
  }

  Padding _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.only(top: largePaddingSize),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.page == LoginRegisterPageType.login
                    ? "Witaj!"
                    : "Cześć!",
                style: const TextStyle(fontSize: 40)),
            Text(
              widget.page == LoginRegisterPageType.login
                  ? "Zaloguj się, aby kontynuować"
                  : "Stwórz nowe konto",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _showErrors(InputDataState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "${state.error!}!",
        style: TextStyle(
            color: Theme.of(context).colorScheme.error, fontFamily: "Arial"),
      ),
    );
  }

  _buildFields() {
    switch (widget.page) {
      case LoginRegisterPageType.login:
        return EmailAndPasswordFields(
          email: firstTextField,
          password: secondTextField,
        );
      case LoginRegisterPageType.registerPersonalInfo:
        return PersonalInfoFields(
          company: firstTextField,
          name: secondTextField,
          surname: thirdTextField,
          phoneNumber: fourthTextField,
          isBusinessAccount: context.read<AuthCubit>().isBusinessAccount,
          saveIsBusinessAcount: (value) {
            context.read<AuthCubit>().isBusinessAccount = value;
          },
        );
      case LoginRegisterPageType.registerEmailAndPassword:
        return EmailAndPasswordFields(
          email: firstTextField,
          password: secondTextField,
          repeatPassword: thirdTextField,
        );
    }
  }

  Column _buildButtons(BuildContext context) {
    return Column(
      children: [
        WideTextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              switch (widget.page) {
                case LoginRegisterPageType.login:
                  _saveEmail();
                  context
                      .read<AuthCubit>()
                      .signIn(password: secondTextField.text);
                  break;
                case LoginRegisterPageType.registerPersonalInfo:
                  _savePersonalInfo();
                  context.read<AuthCubit>().goToEmailAndPasswordRegisterPage();
                  break;
                case LoginRegisterPageType.registerEmailAndPassword:
                  _saveEmail();
                  context
                      .read<AuthCubit>()
                      .register(password: secondTextField.text);
                  break;
              }
            }
          },
          text: _getButtonText(),
        ),
        if (widget.page == LoginRegisterPageType.login)
          TextButton(
            onPressed: () {},
            child: const Text("Zapomniałeś hasła?"),
          ),
      ],
    );
  }

  String _getButtonText() {
    switch (widget.page) {
      case LoginRegisterPageType.login:
        return "Zaloguj się";
      case LoginRegisterPageType.registerPersonalInfo:
        return "Przejdź dalej";
      case LoginRegisterPageType.registerEmailAndPassword:
        return "Zarejestruj się";
    }
  }

  _savePersonalInfo() {
    context.read<AuthCubit>().savePersonalInfo(firstTextField.text,
        secondTextField.text, thirdTextField.text, fourthTextField.text);
  }

  _saveEmail() {
    context.read<AuthCubit>().saveEmail(firstTextField.text);
  }
}
