import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student ID Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 1, 15, 1),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            height: 650,
            child: MyHomePage(title: 'Student ID card'),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameCtrl = TextEditingController();
  final idCtrl = TextEditingController();
  final programCtrl = TextEditingController();
  final deptCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    idCtrl.dispose();
    programCtrl.dispose();
    deptCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 8),
            color: Colors.black12,
          ),
        ],
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: scheme.onSecondaryContainer,
              ),
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tap to pick image
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: scheme.primaryContainer,
                      backgroundImage:
                          _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                      child: _imageBytes == null
                          ? Icon(Icons.camera_alt,
                              size: 40, color: scheme.onPrimaryContainer)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInputField("Name", nameCtrl),
                  _buildInputField("Student ID", idCtrl),
                  _buildInputField("Program", programCtrl),
                  _buildInputField("Department", deptCtrl),
                  _buildInputField("Email", emailCtrl,
                      keyboardType: TextInputType.emailAddress),
                  _buildInputField("Phone", phoneCtrl,
                      keyboardType: TextInputType.phone),

                  const SizedBox(height: 16),

                  // Generate button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final data = StudentInfo(
                          name: nameCtrl.text.trim(),
                          studentId: idCtrl.text.trim(),
                          program: programCtrl.text.trim(),
                          department: deptCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          imageBytes: _imageBytes,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => IdPreviewPage(info: data),
                          ),
                        );
                      },
                      child: const Text("Generate ID Card"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable field builder
  Widget _buildInputField(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          labelText: null, // keep M3 style labels simple
        ).copyWith(labelText: label),
      ),
    );
  }
}

/// Data model passed to preview
class StudentInfo {
  final String name;
  final String studentId;
  final String program;
  final String department;
  final String email;
  final String phone;
  final Uint8List? imageBytes;

  StudentInfo({
    required this.name,
    required this.studentId,
    required this.program,
    required this.department,
    required this.email,
    required this.phone,
    required this.imageBytes,
  });
}

/// IUT-styled preview page (matches your 3rd screenshot)
class IdPreviewPage extends StatelessWidget {
  const IdPreviewPage({super.key, required this.info});
  final StudentInfo info;

  static const _iutGreen = Color.fromARGB(255, 1, 41, 28);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text("ID Card Preview"),
      ),
      body: Center(
        child: Container(
          width: 380,
          height: 550,
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 16,
                spreadRadius: 2,
                offset: Offset(0, 8),
                color: Colors.black12,
              ),
            ],
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HEADER (logo + title)
              SizedBox(
                height: 160,
                child: ColoredBox(
                  color: _iutGreen,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        _IUTLogo(),
                        SizedBox(height: 8),
                        Text(
                          'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // PHOTO (overlapping)
              Transform.translate(
                offset: const Offset(0, -40),
                child: Center(
                  child: Container(
                    width: 110,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: scheme.outlineVariant),
                      image: DecorationImage(
                        image: info.imageBytes != null
                            ? MemoryImage(info.imageBytes!)
                            : const AssetImage('assets/images/placeholder.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Student ID badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.vpn_key, size: 16, color: Colors.black87),
                                  SizedBox(width: 4),
                                  Text(
                                    'Student ID',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _iutGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.circle,
                                        size: 16,
                                        color: Color.fromARGB(163, 3, 128, 134)),
                                    const SizedBox(width: 8),
                                    Text(
                                      info.studentId.isEmpty ? '—' : info.studentId,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Fields (exactly like the 3rd picture)
                      BulletField(
                          icon: Icons.person_outline,
                          label: 'Student Name',
                          value: _dash(info.name)),
                      BulletField(
                          icon: Icons.school,
                          label: 'Program',
                          value: _dash(info.program)),
                      BulletField(
                          icon: Icons.apartment,
                          label: 'Department',
                          value: _dash(info.department)),
                      const BulletField(
                          icon: Icons.place, label: 'Bangladesh', value: ''),

                      // (email/phone are collected but not shown on card to match the design)
                    ],
                  ),
                ),
              ),

              // FOOTER
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: _iutGreen,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: const Center(
                  child: Text(
                    'A subsidiary organ of OIC',
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dash(String v) => v.isEmpty ? '—' : v;
}

class _IUTLogo extends StatelessWidget {
  const _IUTLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/iutt_logo.png',
      height: 50,
      fit: BoxFit.contain,
    );
  }
}

class BulletField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const BulletField(
      {super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final faded = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: faded),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: onSurface),
              children: [
                TextSpan(
                  text: '$label  ',
                  style: TextStyle(
                    color: faded,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (value.isNotEmpty)
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
