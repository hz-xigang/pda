import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hz_xg_pda/app_routes.dart';
import 'package:hz_xg_pda/entity/login_user.dart';
import 'package:hz_xg_pda/http/UserApi.dart';
import 'package:hz_xg_pda/provider/TokenProvider.dart';
import 'package:hz_xg_pda/util/JwtUtil.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _restoreLoginUser();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _restoreLoginUser() async {
    final loginUser = await TokenProvider.getLoginUser();
    if (!mounted || loginUser == null) {
      return;
    }

    _usernameController.text = loginUser.username;
    _passwordController.text = loginUser.pwd;
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入用户名和密码')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    try{
      var token =  await UserApi.login({
        "username" : username,
        "pwd" : password,
      });

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);


      await TokenProvider.saveLoginUser(
      LoginUser(
        username: username,
        pwd: password,
        rememberMe: true,
        realName: decodedToken['realName'],
        token: token,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    EasyLoading.showSuccess("登录成功");

    Navigator.pushReplacementNamed(context, AppRoutes.home);
    }catch(e){
      setState(() {
        _isSubmitting = false;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E2433),
                Color(0xFFF3F6FB),
              ],
              stops: [0, 0.42],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x16000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7EEFF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.factory_outlined,
                          size: 30,
                          color: Color(0xFF2E61F3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '仓储作业登录',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '请输入用户名和密码后进入系统',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: '用户名',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          filled: true,
                          fillColor: const Color(0xFFF6F8FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        //onSubmitted: (_) => _isSubmitting ? null : _submit(),
                        decoration: InputDecoration(
                          labelText: '密码',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          filled: true,
                          fillColor: const Color(0xFFF6F8FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E61F3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('登录'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
