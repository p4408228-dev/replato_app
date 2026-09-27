import 'package:flutter/material.dart';
import 'theme.dart';
import 'api.dart';

void main() => runApp(const ReplatoApp());

class ReplatoApp extends StatelessWidget {
  const ReplatoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RePlato',
      debugShowCheckedModeBanner: false,
      theme: ReplatoTheme.light(),
      home: const SplashScreen(),
    );
  }
}

// ---------------- SPLASH ----------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _status = 'Connecting to backend...';

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final res = await ApiService.healthCheck();
    if (!mounted) return;
    setState(() {
      _status = res != null ? 'Backend: ONLINE ✅' : 'Backend: OFFLINE ❌';
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReplatoColors.creamBeige,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: ReplatoColors.tealGreen,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: ReplatoColors.tealGreen.withAlpha(90),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🍽️', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('RePlato',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: ReplatoColors.tealGreen,
                  letterSpacing: 1.5,
                )),
            const SizedBox(height: 8),
            const Text('Rescue Food. Feed People.',
                style: TextStyle(
                  color: ReplatoColors.oliveGreen,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                )),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ReplatoColors.softCream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_status,
                  style: const TextStyle(
                      color: ReplatoColors.charcoal, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- LOGIN ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'DONOR';

  void _login() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => HomeScreen(role: _role)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReplatoColors.creamBeige,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Text('Welcome Back 👋',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: ReplatoColors.tealGreen)),
              const SizedBox(height: 6),
              const Text('Login to continue to RePlato',
                  style: TextStyle(color: ReplatoColors.mutedText)),
              const SizedBox(height: 30),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined,
                      color: ReplatoColors.tealGreen),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline,
                      color: ReplatoColors.tealGreen),
                ),
              ),
              const SizedBox(height: 20),
              const Text('I am a:',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ReplatoColors.charcoal)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ['DONOR', 'NGO', 'VOLUNTEER'].map((r) {
                  final selected = _role == r;
                  return ChoiceChip(
                    label: Text(r),
                    selected: selected,
                    onSelected: (_) => setState(() => _role = r),
                    selectedColor: ReplatoColors.mustardYellow,
                    backgroundColor: ReplatoColors.softCream,
                    labelStyle: TextStyle(
                      color: selected
                          ? ReplatoColors.charcoal
                          : ReplatoColors.oliveGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: const Text('LOGIN'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Signup coming in next block')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: ReplatoColors.crimsonRed,
                  side: const BorderSide(color: ReplatoColors.crimsonRed),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Create an Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- HOME ----------------
class HomeScreen extends StatefulWidget {
  final String role;
  const HomeScreen({super.key, required this.role});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _donations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getDonations();
    if (!mounted) return;
    setState(() {
      _donations = data;
      _loading = false;
    });
  }

  Color get _roleColor {
    switch (widget.role) {
      case 'NGO':
        return ReplatoColors.mustardYellow;
      case 'VOLUNTEER':
        return ReplatoColors.crimsonRed;
      default:
        return ReplatoColors.tealGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReplatoColors.creamBeige,
      appBar: AppBar(
        title: Text('${widget.role} Dashboard'),
        backgroundColor: _roleColor,
      ),
      floatingActionButton: widget.role == 'DONOR'
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DonateForm()));
                _load();
              },
              backgroundColor: ReplatoColors.tealGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Donate Food'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _statBanner(),
                  const SizedBox(height: 16),
                  const Text('Recent Donations',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ReplatoColors.charcoal)),
                  const SizedBox(height: 10),
                  if (_donations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No donations yet. Be the first!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ReplatoColors.mutedText)),
                    )
                  else
                    ..._donations.map(_donationCard).toList(),
                ],
              ),
      ),
    );
  }

  Widget _statBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ReplatoColors.tealGreen, ReplatoColors.oliveGreen],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('🍱', style: TextStyle(fontSize: 42)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_donations.length} active donations',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Every meal rescued counts 🌱',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _donationCard(dynamic d) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: ReplatoColors.mustardYellow.withAlpha(64),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                  child: Text('🍱', style: TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d['foodName'] ?? 'Food',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: ReplatoColors.charcoal)),
                  const SizedBox(height: 4),
                  Text('${d['quantity']} servings · ${d['location']}',
                      style: const TextStyle(
                          color: ReplatoColors.mutedText, fontSize: 13)),
                  Text('Available until ${d['availableUntil']}',
                      style: const TextStyle(
                          color: ReplatoColors.oliveGreen, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: ReplatoColors.tealGreen.withAlpha(38),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${d['status']}',
                  style: const TextStyle(
                      color: ReplatoColors.tealGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- DONATE FORM ----------------
class DonateForm extends StatefulWidget {
  const DonateForm({super.key});
  @override
  State<DonateForm> createState() => _DonateFormState();
}

class _DonateFormState extends State<DonateForm> {
  final _name = TextEditingController();
  final _qty = TextEditingController();
  final _location = TextEditingController();
  final _until = TextEditingController();
  final _desc = TextEditingController();
  String _category = 'Cooked Food';
  bool _sending = false;

  static const _categories = [
    'Cooked Food',
    'Packaged Food',
    'Bakery',
    'Fruits',
    'Vegetables',
    'Other'
  ];

  Future<void> _submit() async {
    if (_name.text.isEmpty || _qty.text.isEmpty || _location.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: ReplatoColors.crimsonRed,
            content: Text('Please fill food name, quantity and location')),
      );
      return;
    }
    setState(() => _sending = true);
    final ok = await ApiService.createDonation({
      'foodName': _name.text,
      'category': _category,
      'quantity': int.tryParse(_qty.text) ?? 0,
      'location': _location.text,
      'availableUntil': _until.text.isEmpty ? 'N/A' : _until.text,
      'description': _desc.text,
      'status': 'PENDING',
      'donorName': 'You',
    });
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: ReplatoColors.tealGreen,
            content: Text('✅ Donation submitted successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: ReplatoColors.crimsonRed,
            content: Text('❌ Failed to submit. Is backend running?')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReplatoColors.creamBeige,
      appBar: AppBar(title: const Text('Donate Food')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                prefixIcon:
                    Icon(Icons.restaurant, color: ReplatoColors.tealGreen),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _category,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon:
                    Icon(Icons.category, color: ReplatoColors.tealGreen),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _qty,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity (servings)',
                prefixIcon:
                    Icon(Icons.numbers, color: ReplatoColors.tealGreen),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _location,
              decoration: const InputDecoration(
                labelText: 'Pickup Location',
                prefixIcon:
                    Icon(Icons.location_on, color: ReplatoColors.tealGreen),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _until,
              decoration: const InputDecoration(
                labelText: 'Available Until (e.g. 9:00 PM)',
                prefixIcon:
                    Icon(Icons.access_time, color: ReplatoColors.tealGreen),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _desc,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon:
                    Icon(Icons.notes, color: ReplatoColors.tealGreen),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sending ? null : _submit,
                style: ElevatedButton.styleFrom(
                    backgroundColor: ReplatoColors.mustardYellow,
                    foregroundColor: ReplatoColors.charcoal),
                child: _sending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('SUBMIT DONATION'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}