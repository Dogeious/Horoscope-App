import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Title
        title: Text(
          'History',
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
        child: History(),
      ),
    );
  }
}

class History extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('users')
          .doc(user!.uid)
          .collection('horoscopes')
          .orderBy('current_date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var horoscopes = snapshot.data!.docs;
        return ListView.builder(                            //Displaying the information
          itemCount: horoscopes.length,
          itemBuilder: (context, index) {
            var horoscope = horoscopes[index];
            String sign = horoscope['sign'];
            return ListTile (
              leading: Image.asset(                 //Image
                'assets/images/${sign.toLowerCase()}1.png',
                width: 125,
                height: 125,
              ),
              title: Text(                          //Sign
                horoscope['sign'],
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Playwrite Colombia',
                  color: Colors.black,
                ),
              ),
              subtitle: Text(                       //Date
                horoscope['current_date'],
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Playwrite Colombia',
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HoroscopeDetailPage(horoscope: horoscope),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class HoroscopeDetailPage extends StatelessWidget {
  final DocumentSnapshot horoscope;
  const HoroscopeDetailPage({required this.horoscope});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(                              //Title
          horoscope['sign'],
          style: TextStyle(
            fontFamily: 'Playwrite Colombia',
          ),
        ),
        actions: [
          IconButton(                             //Delete Icon
            icon: Icon(Icons.delete),
            onPressed: () async {
              await deleteHoroscope(context);
            },
          ),
        ],
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
      body: Container(             //Image + Data displayed
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF224fb6), Color(0xFFa665db)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/${horoscope['sign'].toLowerCase()}1.png',
                  height: 200,
                ),
              ),
              SizedBox(height: 16.0),
              buildHoroscopeDetail('Current Date', horoscope['current_date']),
              buildHoroscopeDetail('Compatibility', horoscope['compatibility']),
              buildHoroscopeDetail('Lucky Time', horoscope['lucky_time']),
              buildHoroscopeDetail('Lucky Number', horoscope['lucky_number']),
              buildHoroscopeDetail('Mood', horoscope['mood']),
              buildHoroscopeDetail('Color', horoscope['color']),
              buildHoroscopeDetail('Description', horoscope['description']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHoroscopeDetail(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(                //Category
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Playwrite Colombia',
          ),
        ),
        SizedBox(height: 8.0),
        Text(                         //Category Information
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

  Future<void> deleteHoroscope(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('horoscopes')
          .doc(horoscope.id)
          .delete();
      Navigator.pop(context);
    }
  }
}
