import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../navigation/navigation.dart';
import '../../theme.dart';
import '../../view_models/auth_view_cubit/auth_view_cubit.dart';
import '../../view_models/auth_view_cubit/auth_view_cubit_state.dart';
import '../widgets/custom_sized_container.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}


class _AuthScreenState extends State<AuthScreen> {


  final _loginTextFieldController = TextEditingController();
  final _passwordTextFieldController = TextEditingController();
  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _hidePassword = true;
  final bool isError = false;
  late String _errorMessage;
  AuthViewCubitState? _authState;

  void _onNextFieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _loginTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _loginFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthViewCubit, AuthViewCubitState>(
        listener: _onAuthViewCubitStateChange,
        child:  Scaffold(
          backgroundColor: AppColors.backgroundMain1,
          body: SafeArea(
            child: SingleChildScrollView(
              child: CustomSizeContainer(GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'assets/DV-rybak-logo-cropped.png',
                        height: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                      child: LoginFormWidget(context),
                    ),
                  ],
                ),
              ), context),
            ),
          ),
        )
    );
  }


  Widget LoginFormWidget(context) {
    return Form(
      child: Column(children: [
        if (_authState is AuthViewCubitErrorState)
          Text(_errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: AppColors.textInfo2),),
        TextFormField(
          controller: _loginTextFieldController,
          focusNode: _loginFocus,
          autofocus: true,
          onFieldSubmitted: (_) {
            _onNextFieldFocus(context, _loginFocus, _passwordFocus);
          },
          cursorColor: AppColors.textSecondary,
          style: const TextStyle(fontSize: 20, color: DarkColors.backgroundMain1, decoration: TextDecoration.none),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: AppColors.textMain,
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))
            ),
            labelText: 'Логин',
            labelStyle: TextStyle(fontSize: 20, color: AppColors.backgroundMain1),
            prefixIcon: const Icon(Icons.person),
            prefixIconColor: AppColors.backgroundMain1,
            focusColor: AppColors.backgroundMain3,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordTextFieldController,
          focusNode: _passwordFocus,
          obscureText: _hidePassword,
          style: const TextStyle(fontSize: 20, color: DarkColors.backgroundMain1, decoration: TextDecoration.none),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: AppColors.textMain,
            filled: true,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32))
            ),
            labelText: 'Пароль',
            labelStyle: const TextStyle(fontSize: 22),
            prefixIcon: const Icon(Icons.lock),
            prefixIconColor: AppColors.backgroundMain1,
            focusColor: AppColors.backgroundMain3,
            suffixIconColor: AppColors.backgroundMain3,
            suffixIcon: GestureDetector(
              child:
              Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
              onTap: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: (){
            // Navigator.of(context).pushNamed(MainNavigationRouteNames.resetPasswordScreen);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Забыли пароль?',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 18
              ),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textMain,
            foregroundColor: AppColors.backgroundMain5,
            minimumSize: const Size.fromHeight(60),
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _login(_loginTextFieldController.text,
                _passwordTextFieldController.text, context
            );
          },
          child: _authState is AuthViewCubitAuthProgressState
              ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(
            'Войти',
            style: TextStyle(fontSize: 20, color: AppColors.backgroundMain1),
          ),
        ),
        const SizedBox(height: 20,)
      ]),
    );
  }


  void _onAuthViewCubitStateChange (
      BuildContext context,
      AuthViewCubitState state
      ) {
    if (state is AuthViewCubitSuccessAuthState) {
      Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.homeScreen);
    } else {
      setState(() {
        _authState = state;
        if (state is AuthViewCubitErrorState) {
          _errorMessage = state.error;
        }
      });
    }
  }

  void _login(username, pass, context) async {
    BlocProvider.of<AuthViewCubit>(context).auth(email:username, password:pass);
    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.homeScreen);
  }

}
