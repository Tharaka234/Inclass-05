
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Profile',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5856D6),
        ),
      ),
      home: const ProfileScreen(),
    );
  }
}

// ============================================================
// PROFILE SCREEN
// ============================================================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primary = Color(0xFF5856D6);
  static const Color dark = Color(0xFF18223B);

  String name = 'Tharaka';
  String email = 'tikottagoda@students.nsbm.ac.lk';
  String phone = '';
  String bio = '';

  int points = 0;
  bool notifications = true;
  bool darkMode = false;

  // ==========================================================
  // THEME COLORS
  // ==========================================================

  Color get pageBackground =>
      darkMode ? const Color(0xFF101526) : const Color(0xFFF5F7FC);

  Color get cardBackground =>
      darkMode ? const Color(0xFF242B40) : Colors.white;

  Color get primaryText =>
      darkMode ? Colors.white : dark;

  Color get secondaryText =>
      darkMode ? const Color(0xFFB7C0D1) : const Color(0xFF7B8799);

  Color get borderColor =>
      darkMode ? const Color(0xFF394258) : const Color(0xFFEDF0F6);

  // ==========================================================
  // PROFILE COMPLETION
  // ==========================================================

  double get profileCompletion {
    int completed = 0;

    if (name.trim().isNotEmpty) completed++;
    if (email.trim().isNotEmpty) completed++;
    if (phone.trim().isNotEmpty) completed++;
    if (bio.trim().isNotEmpty) completed++;

    return completed / 4;
  }

  // ==========================================================
  // ADD POINT
  // ==========================================================

  void addPoint() {
    setState(() {
      points++;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You earned 1 point!'),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ==========================================================
  // EDIT PROFILE
  // ==========================================================

  Future<void> editProfile() async {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final bioController = TextEditingController(text: bio);

    final formKey = GlobalKey<FormState>();

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: primary,
                brightness:
                darkMode ? Brightness.dark : Brightness.light,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: cardBackground,
              ),
            ),
            child: AlertDialog(
              backgroundColor: cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _editField(
                          controller: nameController,
                          label: 'Full Name',
                          icon: Icons.person_outline,
                          requiredField: true,
                        ),
                        const SizedBox(height: 14),
                        _editField(
                          controller: emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          requiredField: true,
                          emailField: true,
                        ),
                        const SizedBox(height: 14),
                        _editField(
                          controller: phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),
                        _editField(
                          controller: bioController,
                          label: 'About Me',
                          icon: Icons.info_outline,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: secondaryText),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    setState(() {
                      name = nameController.text.trim();
                      email = emailController.text.trim();
                      phone = phoneController.text.trim();
                      bio = bioController.text.trim();
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          );
        },
      );
    } finally {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      bioController.dispose();
    }
  }

  Widget _editField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool requiredField = false,
    bool emailField = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType ??
          (emailField
              ? TextInputType.emailAddress
              : TextInputType.text),
      style: TextStyle(color: primaryText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryText),
        prefixIcon: Icon(icon, color: primary),
        filled: true,
        fillColor: pageBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (requiredField && text.isEmpty) {
          return 'This field is required';
        }

        if (emailField &&
            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
          return 'Enter a valid email address';
        }

        return null;
      },
    );
  }

  // ==========================================================
  // RESET POINTS
  // ==========================================================

  Future<void> resetPoints() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBackground,
          title: Text(
            'Reset Reward Points?',
            style: TextStyle(color: primaryText),
          ),
          content: Text(
            'Are you sure you want to reset all points?',
            style: TextStyle(color: secondaryText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirm == true) {
      setState(() {
        points = 0;
      });
    }
  }

  // ==========================================================
  // MAIN UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 68),

              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Welcome to your personal space',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 25),

              _buildPointsCard(),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompletionCard(),

                    const SizedBox(height: 28),

                    _sectionTitle(
                      'Personal Information',
                      Icons.account_circle_outlined,
                    ),

                    const SizedBox(height: 17),

                    _infoCard(
                      'FULL NAME',
                      name,
                      Icons.person_outline_rounded,
                      const Color(0xFFEDEBFF),
                      primary,
                    ),

                    _infoCard(
                      'EMAIL ADDRESS',
                      email,
                      Icons.email_outlined,
                      const Color(0xFFCCFBF1),
                      const Color(0xFF0D9488),
                    ),

                    _infoCard(
                      'PHONE NUMBER',
                      phone.isEmpty ? 'Not added' : phone,
                      Icons.phone_outlined,
                      const Color(0xFFDBEAFE),
                      const Color(0xFF2563EB),
                    ),

                    _infoCard(
                      'ABOUT ME',
                      bio.isEmpty
                          ? 'Tell us about yourself'
                          : bio,
                      Icons.info_outline,
                      const Color(0xFFFFEDD5),
                      const Color(0xFFEA580C),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: editProfile,
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _sectionTitle(
                      'Achievements',
                      Icons.emoji_events_outlined,
                    ),

                    const SizedBox(height: 17),

                    _buildAchievements(),

                    const SizedBox(height: 30),

                    _sectionTitle(
                      'Settings',
                      Icons.settings_outlined,
                    ),

                    const SizedBox(height: 17),

                    _buildSettings(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return SizedBox(
      height: 230,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 185,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3949AB),
                  Color(0xFF6554D9),
                  Color(0xFF9274E8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  right: -35,
                  top: -65,
                  child: CircleAvatar(
                    radius: 110,
                    backgroundColor:
                    Colors.white.withOpacity(0.07),
                  ),
                ),
                Positioned(
                  left: -50,
                  bottom: -80,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor:
                    Colors.white.withOpacity(0.05),
                  ),
                ),
                const Positioned(
                  top: 25,
                  left: 24,
                  child: Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Positioned(
                  top: 62,
                  left: 24,
                  child: Text(
                    'Manage your personal information',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.18),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 62,
                      backgroundColor: Color(0xFFEDEBFF),
                      child: Icon(
                        Icons.person_rounded,
                        size: 75,
                        color: primary,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // POINTS CARD
  // ==========================================================

  Widget _buildPointsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF252B60),
            Color(0xFF5146A9),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Color(0xFFFFD66B),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Reward Points',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$points Points',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: addPoint,
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROFILE COMPLETION
  // ==========================================================

  Widget _buildCompletionCard() {
    final percent = (profileCompletion * 100).round();

    return _surface(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Completion',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: profileCompletion,
                    minHeight: 9,
                    backgroundColor: darkMode
                        ? const Color(0xFF394258)
                        : const Color(0xFFE9E8FA),
                    color: const Color(0xFF8275FF),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$percent%',
                style: TextStyle(
                  color: darkMode
                      ? const Color(0xFFB9B1FF)
                      : primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Complete your details to reach 100%.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: darkMode
              ? const Color(0xFF9F96FF)
              : primary,
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PERSONAL INFORMATION CARD - DARK MODE FIXED
  // ==========================================================

  Widget _infoCard(
      String label,
      String value,
      IconData icon,
      Color iconBg,
      Color iconColor,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: _surface(
        Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: secondaryText,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ACHIEVEMENTS
  // ==========================================================

  Widget _buildAchievements() {
    return Row(
      children: [
        _achievement(
          'Starter',
          Icons.star_rounded,
          1,
        ),
        const SizedBox(width: 10),
        _achievement(
          'Explorer',
          Icons.explore_rounded,
          5,
        ),
        const SizedBox(width: 10),
        _achievement(
          'Champion',
          Icons.emoji_events_rounded,
          10,
        ),
      ],
    );
  }

  Widget _achievement(
      String title,
      IconData icon,
      int requiredPoints,
      ) {
    final unlocked = points >= requiredPoints;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(
              unlocked ? icon : Icons.lock_outline,
              size: 30,
              color: unlocked
                  ? const Color(0xFFFFC857)
                  : secondaryText,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              unlocked ? 'Unlocked' : '$requiredPoints pts',
              style: TextStyle(
                color: unlocked
                    ? const Color(0xFF22C55E)
                    : secondaryText,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SETTINGS - DARK MODE FIXED
  // ==========================================================

  Widget _buildSettings() {
    return _surface(
      Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Notifications',
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            secondary: Icon(
              Icons.notifications_outlined,
              color: darkMode
                  ? const Color(0xFF9F96FF)
                  : primary,
            ),
            activeThumbColor: primary,
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          Divider(color: borderColor),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Dark Mode',
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            secondary: Icon(
              Icons.dark_mode_outlined,
              color: darkMode
                  ? const Color(0xFF9F96FF)
                  : primary,
            ),
            activeThumbColor: primary,
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),

          Divider(color: borderColor),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.restart_alt,
              color: Colors.redAccent,
            ),
            title: Text(
              'Reset Reward Points',
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: secondaryText,
            ),
            onTap: resetPoints,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // REUSABLE CARD SURFACE
  // ==========================================================

  Widget _surface(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: darkMode
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}