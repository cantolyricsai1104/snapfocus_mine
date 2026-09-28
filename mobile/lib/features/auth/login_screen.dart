import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthGate extends StatelessWidget {
  const SupabaseAuthGate({
    super.key,
    required this.client,
    required this.child,
  });

  final SupabaseClient client;
  final Widget child;

  @override
  Widget build(BuildContext context) => StreamBuilder<AuthState>(
    stream: client.auth.onAuthStateChange,
    builder: (context, snapshot) => client.auth.currentSession == null
        ? LoginScreen(client: client)
        : child,
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.client});

  final SupabaseClient client;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _creatingAccount = false;
  bool _busy = false;
  bool _obscurePassword = true;
  String? _message;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _message = null;
      _error = null;
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _busy = true);
    try {
      if (_creatingAccount) {
        final response = await widget.client.auth.signUp(
          email: _email.text.trim(),
          password: _password.text,
        );
        if (response.session == null && mounted) {
          setState(
            () => _message =
                'Check your email to confirm your account, then sign in.',
          );
        }
      } else {
        await widget.client.auth.signInWithPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
    } on AuthException catch (exception) {
      if (mounted) setState(() => _error = exception.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not connect. Check your connection and try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendPasswordReset() async {
    final email = _email.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _error = 'Enter your email address above first.';
        _message = null;
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
    });
    try {
      await widget.client.auth.resetPasswordForEmail(email);
      if (mounted) {
        setState(() => _message = 'If an account exists, a reset link is on its way.');
      }
    } on AuthException catch (exception) {
      if (mounted) setState(() => _error = exception.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not send the reset email. Try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _setMode(bool createAccount) {
    setState(() {
      _creatingAccount = createAccount;
      _message = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final title = _creatingAccount ? 'Create your account' : 'Welcome back';
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE9E4),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.spa_rounded,
                            color: Color(0xFFE97965),
                            size: 34,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'SnapFocus',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF29313D),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF756C68),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _email,
                        enabled: !_busy,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: false,
                        decoration: _decoration('Email', Icons.mail_outline_rounded),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty || !email.contains('@')) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _password,
                        enabled: !_busy,
                        obscureText: _obscurePassword,
                        textInputAction: _creatingAccount
                            ? TextInputAction.next
                            : TextInputAction.done,
                        autofillHints: [
                          _creatingAccount
                              ? AutofillHints.newPassword
                              : AutofillHints.password,
                        ],
                        onFieldSubmitted: (_) {
                          if (!_creatingAccount) _submit();
                        },
                        decoration: _decoration(
                          'Password',
                          Icons.lock_outline_rounded,
                        ).copyWith(
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Show password'
                                : 'Hide password',
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').length < 8) {
                            return 'Use at least 8 characters.';
                          }
                          return null;
                        },
                      ),
                      if (_creatingAccount) ...[
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _confirmPassword,
                          enabled: !_busy,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                          onFieldSubmitted: (_) => _submit(),
                          decoration: _decoration(
                            'Confirm password',
                            Icons.lock_outline_rounded,
                          ),
                          validator: (value) => value != _password.text
                              ? 'Passwords do not match.'
                              : null,
                        ),
                      ],
                      if (!_creatingAccount)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _busy ? null : _sendPasswordReset,
                            child: const Text('Forgot password?'),
                          ),
                        )
                      else
                        const SizedBox(height: 12),
                      if (_error != null) ...[
                        _Notice(text: _error!, isError: true),
                        const SizedBox(height: 12),
                      ],
                      if (_message != null) ...[
                        _Notice(text: _message!, isError: false),
                        const SizedBox(height: 12),
                      ],
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _busy ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE97965),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _busy
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _creatingAccount ? 'Create account' : 'Sign in',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => _setMode(!_creatingAccount),
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: colors.onSurface,
                        ),
                        child: Text(
                          _creatingAccount
                              ? 'Already have an account? Sign in'
                              : 'New to SnapFocus? Create an account',
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

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFF0DCCF)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFF0DCCF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE97965), width: 2),
    ),
  );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.isError});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? const Color(0xFFAC3F36) : const Color(0xFF36734D);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: TextStyle(color: color, height: 1.35)),
            ),
          ],
        ),
      ),
    );
  }
}
