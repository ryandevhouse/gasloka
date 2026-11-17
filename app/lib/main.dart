import 'package:material_ui/material_ui.dart';

import 'data/demo_data.dart';
import 'models/app_user.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/login_reveal_transition.dart';

void main() {
  runApp(const GaslokaApp());
}

class GaslokaApp extends StatefulWidget {
  const GaslokaApp({super.key});

  @override
  State<GaslokaApp> createState() => _GaslokaAppState();
}

class _GaslokaAppState extends State<GaslokaApp> {
  AppUser? _currentUser;
  AppUser? _pendingUser;
  late final List<DemoDelivery> _deliveries = List.of(DemoData.deliveries);
  final _loginScreenKey = GlobalKey();

  void _signInAs(UserRole role) {
    setState(() {
      _currentUser = DemoData.users[role];
    });
  }

  void _beginLogin(UserRole role) {
    final user = DemoData.users[role];
    if (user == null) {
      throw StateError('Tidak ada akun demo untuk peran ${role.label}.');
    }
    setState(() => _pendingUser = user);
  }

  void _completeLoginTransition() {
    final user = _pendingUser;
    if (user == null) return;
    setState(() {
      _currentUser = user;
      _pendingUser = null;
    });
  }

  void _signOut() {
    setState(() {
      _currentUser = null;
    });
  }

  void _addDelivery(DemoDelivery delivery) {
    setState(() => _deliveries.add(delivery));
  }

  void _updateDelivery(DemoDelivery updatedDelivery, DemoDelivery previous) {
    final index = _deliveries.indexOf(previous);
    if (index < 0) return;
    setState(() => _deliveries[index] = updatedDelivery);
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF167D72);

    return MaterialApp(
      title: 'Gasloka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F6),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0E7E4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0E7E4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: seedColor, width: 1.5),
          ),
        ),
      ),
      home: _currentUser != null
          ? _buildDashboard(_currentUser!)
          : _pendingUser != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                _buildDashboard(_pendingUser!),
                LoginRevealTransition(
                  key: const ValueKey('login-reveal-transition'),
                  onCompleted: _completeLoginTransition,
                  child: LoginScreen(
                    key: _loginScreenKey,
                    onLogin: _beginLogin,
                  ),
                ),
              ],
            )
          : LoginScreen(key: _loginScreenKey, onLogin: _beginLogin),
    );
  }

  Widget _buildDashboard(AppUser user) {
    return DashboardScreen(
      user: user,
      onSignOut: _signOut,
      onRoleSelected: _signInAs,
      deliveries: _deliveries,
      onDeliveryAdded: _addDelivery,
      onDeliveryUpdated: _updateDelivery,
    );
  }
}
