import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model.dart';

class HoroscopePage extends StatefulWidget {
  @override
  _HoroscopePageState createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  final List<String> starSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];
  String? selectedSign;
  bool isLoading = false;
  Map<String, dynamic>? horoscopeData;
  final HoroscopeService horoscopeService = HoroscopeService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Horoscope',
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'VintageRotter',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF224fb6), Color(0xFFa665db)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF224fb6), Color(0xFFa665db)],
          ),
        ),
        child: selectedSign == null
            ? ListView.builder(
             itemCount: starSigns.length,
             itemBuilder: (context, index) {
               return ListTile(
               leading: Container(
                width: 60.0,
                height: 60.0,
                child: Image.asset(
                  'assets/images/${starSigns[index].toLowerCase()}1.png',
                  fit: BoxFit.cover,
                ),
               ),
                title: Text(
                starSigns[index],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'VintageRotter',
                ),
              ),
              onTap: () {
                setState(() {
                  selectedSign = starSigns[index];
                  fetchHoroscope();
                });
              },
            );
          },
        )
            : buildDetailsPage(),
      ),
    );
  }

  Future<void> fetchHoroscope() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await horoscopeService.getHoroscope('today', selectedSign!.toLowerCase());
      setState(() {
        horoscopeData = response;
        isLoading = false;
      });
      await storeHoroscopeInFirestore(response, selectedSign!);
    } catch (e) {
      setState(() {
        isLoading = false;
        horoscopeData = {
          'description': 'Failed to load horoscope. Check your connection.',
        };
      });
    }
  }

  Future<void> storeHoroscopeInFirestore (Map<String, dynamic> horoscopeData, String sign) async {
    User? user = auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      horoscopeData['sign'] = sign;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('horoscopes')
          .add(horoscopeData);
    }
  }

  Widget buildDetailsPage() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (horoscopeData == null) {
      return Center(
        child: Text(
          'Failed to load horoscope.',
          style: TextStyle(
            color: Color(0xFF22394d),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'VintageRotter',
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(      //Images
              child: Image.asset(
                'assets/images/${selectedSign!.toLowerCase()}1.png',
                height: 200,
              ),
            ),
            SizedBox(height: 16.0),
            buildHoroscopeDetail('Current Date', horoscopeData!['current_date']),
            buildHoroscopeDetail('Compatibility', horoscopeData!['compatibility']),
            buildHoroscopeDetail('Lucky Time', horoscopeData!['lucky_time']),
            buildHoroscopeDetail('Lucky Number', horoscopeData!['lucky_number']),
            buildHoroscopeDetail('Mood', horoscopeData!['mood']),
            buildHoroscopeDetail('Color', horoscopeData!['color']),
            buildHoroscopeDetail('Description', horoscopeData!['description']),
            SizedBox(height: 16.0), // Extra spacing at the bottom
          ],
        ),
      ),
    );
  }

  Widget buildHoroscopeDetail(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(                         //Category of data
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Playwrite Colombia',
          ),
        ),
        SizedBox(height: 8.0),
        Text(                         //Particular category's information
          value ?? 'Not available',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Playwrite Colombia',
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}