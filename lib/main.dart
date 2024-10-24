import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math'; // Rastgele kod oluşturmak için ekliyoruz

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İndirim Kodları',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.blue.shade900),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Kenar yuvarlama
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Buton içi boşluk
          ),
        ),
      ),
      home: DiscountPage(),
    );
  }
}

class DiscountPage extends StatefulWidget {
  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final List<Map<String, String>> discountSites = [
    {'site': 'Trendyol', 'discount': '10%'},
    {'site': 'Hepsiburada', 'discount': '15%'},
    {'site': 'Sinerji', 'discount': '5%'},
    {'site': 'Gaming.gen', 'discount': '20%'},
    {'site': 'Itopya', 'discount': '10%'},
    {'site': 'Incehesap', 'discount': '30%'},
  ];

  // Rastgele 6 haneli kod oluşturma
  String generateRandomCode() {
    Random random = Random();
    int randomNumber = random.nextInt(900000) + 100000; // 100000 ile 999999 arasında
    return randomNumber.toString();
  }

  // Site adından kısaltma oluşturma
  String getSiteAbbreviation(String site) {
    return site.substring(0, 2).toUpperCase(); // İlk iki harfi al ve büyük harfe çevir
  }

  // İndirim kodları listesi
  late List<String> discountCodes;

  @override
  void initState() {
    super.initState();
    discountCodes = List.generate(discountSites.length, (index) {
      return '${getSiteAbbreviation(discountSites[index]['site']!)}${generateRandomCode()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İndirim Kodları'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: discountSites.length,
        itemBuilder: (context, index) {
          final site = discountSites[index];
          return Card(
            elevation: 6, // Daha belirgin bir gölge
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16), // İçerik için boşluk
              title: Text(
                discountSites[index]['site']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Daha büyük yazı boyutu
                ),
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Yüzde için iç boşluk
                decoration: BoxDecoration(
                  color: Colors.blue, // Yüzde için sabit mavi renk
                  borderRadius: BorderRadius.circular(8), // Kenar yuvarlama
                ),
                child: Text(
                  discountSites[index]['discount']!,
                  style: TextStyle(
                    color: Colors.white, // Metin rengi beyaz
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Daha büyük yazı boyutu
                  ),
                ),
              ),
              onTap: () {
                final discountCode = discountCodes[index]; // Kısaltma ile rastgele kod oluştur
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('${discountSites[index]['site']} İndirim Kodu'),
                    content: Text('İndirim kodun burada: $discountCode'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Kapat'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: discountCode));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Kod panoya kopyalandı!'),
                            ),
                          );
                        },
                        child: Text('Kodu Kopyala'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
