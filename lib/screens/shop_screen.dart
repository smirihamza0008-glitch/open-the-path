import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _totalPoints = 0;
  String _selectedSkin = 'Default Cube';
  List<String> _unlockedSkins = ['Default Cube'];

  // قائمة العناصر المتوفرة بالمتجر (تصاميم سيبرانية مبتكرة للعين)
  final List<Map<String, dynamic>> _shopItems = [
    {'name': 'Default Cube', 'cost': 0, 'color': const Color(0xff00ffcc), 'type': 'skin'},
    {'name': 'Neon Sphere', 'cost': 150, 'color': const Color(0xffff007f), 'type': 'skin'},
    {'name': 'Quantum Delta', 'cost': 300, 'color': const Color(0xffffff00), 'type': 'skin'},
    {'name': 'Plasma Matrix', 'cost': 500, 'color': const Color(0xff9900ff), 'type': 'skin'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // تحميل النقاط والعناصر المشتراة من ذاكرة الهاتف
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalPoints = prefs.getInt('total_points') ?? 1000; // قيمة افتراضية للتجربة
      _selectedSkin = prefs.getString('selected_skin') ?? 'Default Cube';
      _unlockedSkins = prefs.getStringList('unlocked_skins') ?? ['Default Cube'];
    });
  }

  // معالجة عملية الشراء والاختيار
  Future<void> _handleItemClick(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    String itemName = item['name'];
    int cost = item['cost'];

    if (_unlockedSkins.contains(itemName)) {
      // إذا كان العنصر مفتوحاً بالفعل، يتم تحديده كالعنصر النشط
      setState(() {
        _selectedSkin = itemName;
      });
      await prefs.setString('selected_skin', itemName);
    } else if (_totalPoints >= cost) {
      // شراء العنصر وخصم النقاط
      setState(() {
        _totalPoints -= cost;
        _unlockedSkins.add(itemName);
        _selectedSkin = itemName;
      });
      await prefs.setInt('total_points', _totalPoints);
      await prefs.setStringList('unlocked_skins', _unlockedSkins);
      await prefs.setString('selected_skin', itemName);
    } else {
      // نقاط غير كافية
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough points for $itemName!'),
          backgroundColor: const Color(0xffff007f),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CYBER SHOP', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff0a0a12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff00ffcc)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // عرض النقاط الحالية للاعب أعلى الشاشة بشكل مضيء
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.blur_on, color: Color(0xffffff00), size: 28),
                const SizedBox(width: 5),
                Text(
                  '$_totalPoints PTS',
                  style: const TextStyle(
                    color: Color(0xffffff00),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // مناسب للوضع الأفقي للشاشة
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
          ),
          itemCount: _shopItems.length,
          itemBuilder: (context, index) {
            final item = _shopItems[index];
            bool isUnlocked = _unlockedSkins.contains(item['name']);
            bool isSelected = _selectedSkin == item['name'];

            return GestureDetector(
              onTap: () => _handleItemClick(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: const Color(0xff121224),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? item['color'] 
                        : isUnlocked ? item['color'].withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                    width: isSelected ? 3 : 1.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(color: item['color'].withOpacity(0.3), blurRadius: 10, spreadRadius: 1)
                  ] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // تمثيل المجسم داخل البطاقة بشكل يتوهج بلونه الخاص
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: item['color'], width: 2),
                      ),
                      child: Icon(Icons.token, color: item['color'], size: 30),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    
                    // تحديد حالة الزر (شراء، اختيار، أو نشط حالياً)
                    if (isSelected)
                      const Text('ACTIVE', style: TextStyle(color: Color(0xff00ffcc), fontSize: 12, fontWeight: FontWeight.bold))
                    else if (isUnlocked)
                      const Text('USE', style: TextStyle(color: Colors.grey, fontSize: 12))
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.blur_on, size: 14, color: Color(0xffffff00)),
                          const SizedBox(width: 3),
                          Text('${item['cost']}', style: const TextStyle(color: Color(0xffffff00), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
