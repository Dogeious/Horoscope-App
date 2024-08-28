import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'horoscope.dart';
import 'history.dart';

class ZodiacPage extends StatefulWidget {
  @override
  _ZodiacPageState createState() => _ZodiacPageState();
}

class _ZodiacPageState extends State<ZodiacPage> {
  final user= FirebaseAuth.instance.currentUser!;
  final List<Map<String, String>> zodiacSigns = [
    {
      "name": "aries",
      "dates": "March 21 - April 19",
      "good_qualities": "Courageous, determined, confident, enthusiastic, optimistic, honest, passionate",
      "bad_qualities": "Impatient, moody, short-tempered, impulsive, aggressive"
    },
    {
      "name": "taurus",
      "dates": "April 20 - May 20",
      "good_qualities": "Reliable, patient, practical, devoted, responsible, stable",
      "bad_qualities": "Stubborn, possessive, uncompromising"
    },
    {
      "name": "gemini",
      "dates": "May 21 - June 20",
      "good_qualities": "Gentle, affectionate, curious, adaptable, ability to learn quickly and exchange ideas",
      "bad_qualities": "Nervous, inconsistent, indecisive"
    },
    {
      "name": "cancer",
      "dates": "June 21 - July 22",
      "good_qualities": "Tenacious, highly imaginative, loyal, emotional, sympathetic, persuasive",
      "bad_qualities": "Moody, pessimistic, suspicious, manipulative, insecure"
    },
    {
      "name": "leo",
      "dates": "July 23 - August 22",
      "good_qualities": "Creative, passionate, generous, warm-hearted, cheerful, humorous",
      "bad_qualities": "Arrogant, stubborn, self-centered, lazy, inflexible"
    },
    {
      "name": "virgo",
      "dates": "August 23 - September 22",
      "good_qualities": "Loyal, analytical, kind, hardworking, practical",
      "bad_qualities": "Shyness, worry, overly critical of self and others, all work and no play"
    },
    {
      "name": "libra",
      "dates": "September 23 - October 22",
      "good_qualities": "Cooperative, diplomatic, gracious, fair-minded, social",
      "bad_qualities": "Indecisive, avoids confrontations, will carry a grudge, self-pity"
    },
    {
      "name": "scorpio",
      "dates": "October 23 - November 21",
      "good_qualities": "Resourceful, brave, passionate, stubborn, a true friend",
      "bad_qualities": "Distrusting, jealous, secretive, violent"
    },
    {
      "name": "sagittarius",
      "dates": "November 22 - December 21",
      "good_qualities": "Generous, idealistic, great sense of humor",
      "bad_qualities": "Promises more than can deliver, very impatient, will say anything no matter how undiplomatic"
    },
    {
      "name": "capricorn",
      "dates": "December 22 - January 19",
      "good_qualities": "Responsible, disciplined, self-control, good managers",
      "bad_qualities": "Know-it-all, unforgiving, condescending, expecting the worst"
    },
    {
      "name": "aquarius",
      "dates": "January 20 - February 18",
      "good_qualities": "Progressive, original, independent, humanitarian",
      "bad_qualities": "Runs from emotional expression, temperamental, uncompromising, aloof"
    },
    {
      "name": "pisces",
      "dates": "February 19 - March 20",
      "good_qualities": "Compassionate, artistic, intuitive, gentle, wise, musical",
      "bad_qualities": "Fearful, overly trusting, sad, desire to escape reality, can be a victim or a martyr"
    }
  ];

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(        //Drawer
        child: ListView(
          children: <Widget>[
            DrawerHeader(     // Menu Header
              child: Text(
                  'Menu',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontFamily: 'VintageRotter',
                  ),
              ),
            ),
            ListTile(          //Signout Button
              title: Text(
                  'Sign Out',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontFamily: 'VintageRotter',
                ),
              ),
              onTap: signOut,
            ),
          ],
        ),
      ),
      body: Container(     //Background gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF224fb6), Color(0xFFa665db)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40),
            Expanded(                     //Zodiac signs slider
              child: PageView.builder(
                itemCount: zodiacSigns.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(                     // Zodiac signs detail
                            title: Text(zodiacSigns[index]['name']!),
                            content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Dates: ${zodiacSigns[index]['dates']!}"),
                              SizedBox(height: 8),
                              Text("Good Qualities: ${zodiacSigns[index]['good_qualities']!}"),
                              SizedBox(height: 8),
                              Text("Bad Qualities: ${zodiacSigns[index]['bad_qualities']!}"),
                            ],
                          ),
                            actions: [
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(                  //Images
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Image.asset(
                        'assets/images/${zodiacSigns[index]['name']!}.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(       // Horscope Button
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HoroscopePage()),
                        );
                      },
                      child: Container(
                        height: 200,
                        margin: EdgeInsets.only(right: 8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/horoscope.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Horoscope',
                                style: TextStyle(
                                  color: Color(0xFF22394d),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'VintageRotter',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(         //History Button
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryPage()),
                        );
                      },
                      child: Container(
                        height: 200,
                        margin: EdgeInsets.only(left: 8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/history.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'History',
                                style: TextStyle(
                                  color: Color(0xFF22394d),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'VintageRotter',
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
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
