import 'package:flutter/material.dart';
import 'shop_screen.dart';
// سنستدعي شاشة اللعبة لاحقاً هنا عندما ننشئها

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // تحريك التوهج في الخلفية لإعطاء جمالية بصرية
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // تأثير الخلفية المتوهجة (Cyberpunk Glow)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2 + (_animationController.value * 0.2),
                    colors: [
                      const Color(0xff14142b),
                      const Color(0xff0a0a12),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // محتويات الشاشة الرئيسية
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // اسم اللعبة بتصميم النيون المشع
                Text(
                  'OPEN THE PATH',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.black,
                    letterSpacing: 6,
                    color: const Color(0xff00ffcc),
                    shadows: [
                      Shadow(
                        color: const Color(0xff00ffcc).withOpacity(0.8),
                        blurRadius: 20,
                      ),
                      Shadow(
                        color: const Color(0xffff007f).withOpacity(0.5),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'CLEAR THE WAY • LET IT PASS',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 50),
                
                // زر بدء اللعب بتصميم مخصص
                _buildMenuButton(
                  text: 'START JOURNEY',
                  color: const Color(0xff00ffcc),
                  onPressed: () {
                    // سينتقل لشاشة اللعبة لاحقاً
                  },
                ),
                const SizedBox(height: 20),
                
                // زر المتجر
                _buildMenuButton(
                  text: 'CYBER SHOP',
                  color: const Color(0xffff007f),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // أداة بناء أزرار نيون مخصصة وممتعة بصرياً عند الضغط
  Widget _buildMenuButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 250,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff121224),
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
