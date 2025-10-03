import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0C0C0C)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 380,
            height: 550,
            child: MyHomePage(title: 'ISLAMIC UNIVERSITY OF TECHNOLOGY'),
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
  

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Card
        Container(
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
             
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: ColoredBox(
                      color: const Color.fromARGB(255, 1, 41, 28),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/iutt_logo.png',
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 8),
                            const Text(
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
                //photo
                  Positioned(
                    bottom: -80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: scheme.outlineVariant),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/muichiro.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            
              const SizedBox(height: 70),

          //body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  
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
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 1, 41, 28),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.circle, size: 18, color: Color.fromARGB(163, 3, 128, 134)),
                                    SizedBox(width: 8),
                                    Text(
                                      '210041231',
                                      style: TextStyle(
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

                     
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            BulletField(icon: Icons.person_outline
, label: 'Student Name', value: 'Nafisa Haque'),
                            BulletField(icon: Icons.school, label: 'Program', value: 'B.Sc. in CSE'),
                            BulletField(icon: Icons.apartment, label: 'Department', value: 'CSE'),
                            BulletField(icon: Icons.place, label: 'Bangladesh', value: ''),
                          ],
                        ),
                      ),
                      

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

             //footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 1, 41, 28),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: const Center(
                  child: Text(
                    'A subsidiary organ of OIC',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),

        
      ],
    );
  }
}

class BulletField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const BulletField({super.key, required this.icon, required this.label, required this.value});

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
