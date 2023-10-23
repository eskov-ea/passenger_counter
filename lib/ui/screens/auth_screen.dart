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
  late String errorMessage;

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
          body: SafeArea(
            child: SingleChildScrollView(
              child: CustomSizeContainer(GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Image.asset(
                            '',
                            height: 150,
                          ),
                        )),
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
    final cubit = context.watch<AuthViewCubit>();
    return Form(
      child: Column(children: [
        if (cubit.state is AuthViewCubitErrorState)
          Text(cubit.state.errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),),
        TextFormField(
          controller: _loginTextFieldController,
          focusNode: _loginFocus,
          autofocus: true,
          onFieldSubmitted: (_) {
            _onNextFieldFocus(context, _loginFocus, _passwordFocus);
          },
          style: const TextStyle(fontSize: 20, color: DarkColors.textMain, decoration: TextDecoration.none),
          decoration: const InputDecoration(
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: DarkColors.textMain, width: 2.5, )
            ),

            labelText: 'Логин',
            labelStyle: TextStyle(fontSize: 22),
            prefixIcon: Icon(Icons.person),
            prefixIconColor: Colors.blue,
            focusColor: Colors.blue,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordTextFieldController,
          focusNode: _passwordFocus,
          obscureText: _hidePassword,
          style: const TextStyle(fontSize: 20, color: DarkColors.textMain, decoration: TextDecoration.none),
          decoration: InputDecoration(
            labelText: 'Пароль',
            labelStyle: const TextStyle(fontSize: 22),
            prefixIcon: const Icon(Icons.lock),
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
                  color: Colors.blueAccent,
                  fontSize: 18
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        ElevatedButton(
          child: cubit.state is AuthViewCubitAuthProgressState
              ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text(
            'Логин',
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.indigo,
            minimumSize: const Size.fromHeight(45),
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _login(_loginTextFieldController.text,
                _passwordTextFieldController.text, context
            );
          },
        ),
      ]),
    );
  }


  void _onAuthViewCubitStateChange (
      BuildContext context,
      AuthViewCubitState state
      ) {
    if (state is AuthViewCubitSuccessAuthState) {
      Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.homeScreen);
    }
  }

  void _login(username, pass, context) async {
    BlocProvider.of<AuthViewCubit>(context).auth(email:username, password:pass);
  }

}
