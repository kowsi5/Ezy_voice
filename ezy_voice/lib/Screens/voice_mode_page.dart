import 'dart:io';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../res/AppColor.dart';
import '../models/history_item.dart';
import '../services/history_service.dart';
import '../models/sync_service.dart';
import 'app_drawer.dart';
import 'history_page.dart';
import 'plans_page.dart';
import 'support_page.dart';
import 'package:provider/provider.dart';
import '../providers/usage_provider.dart'; // adjust path if different

class VoiceModePage extends StatefulWidget {
  const VoiceModePage({super.key});

  @override
  _VoiceModePageState createState() => _VoiceModePageState();
}

class _VoiceModePageState extends State<VoiceModePage> {
  // Navigation State
  int _selectedIndex = 1; // Default to Voice Mode (Middle)

  // Speech & TTS State
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _input = "Tap the mic and start speaking...";
  String _result = "Result..";
  String _selectedLang = "ta-IN";
  List<String> _availableLanguages = []; // For all TTS languages

  final HistoryService _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    _initTts();
  }




bool _isTtsInitialized = false;


Future<void> _initTts() async {
  try {
    if (Platform.isAndroid) {
      var engines = await _flutterTts.getEngines;
      if (engines.contains("com.google.android.tts")) {
        await _flutterTts.setEngine("com.google.android.tts");
      }
    }

    // Set speech attributes
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); // Slightly slower is better for regional languages


    _flutterTts.setErrorHandler((msg) {
      debugPrint("TTS Error: $msg");
      _isTtsInitialized = false;
    });

    await _flutterTts.setLanguage(_selectedLang);
    _isTtsInitialized = true;
  } catch (e) {
    debugPrint("Error initializing TTS: $e");
  }
}


Future<void> _speak(String text) async {
  if (text.isEmpty || text == "Result.." || text == "Calculating...") return;

  try {
    await _flutterTts.stop();

    await _flutterTts.setLanguage(_selectedLang);
    

    bool isSupported = await _flutterTts.isLanguageAvailable(_selectedLang);
    
    if (!isSupported) {
      
      String shortLang = _selectedLang.split('-')[0];
      await _flutterTts.setLanguage(shortLang);
    }

    var result = await _flutterTts.speak(text);
    if (result == 0) debugPrint("TTS: Speak call failed");
    
  } catch (e) {
    debugPrint("TTS Speak Exception: $e");
  }
}
  void _onMicTap() async {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    if (!_isListening) {
      bool working = await _speech.initialize();
      if (working) {
        setState(() {
          _isListening = true;
          _input = "Listening...";
        });
        _speech.listen(
          localeId: _selectedLang,
          onResult: (val) {
            setState(() => _input = val.recognizedWords);
            if (val.finalResult) {
              setState(() => _isListening = false);
            }
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }


  Future<void> _calculate(String text) async {
    if (text.isEmpty ||
        text == "Tap the mic and start speaking..." ||
        text == "Listening...")
      return;
    setState(() => _result = "Calculating...");

    try {
      final res = await http.post(
        Uri.parse('https://voicecalc-uc7u.onrender.com/calculate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': text, 'lang': _selectedLang}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        String resText =
            data['result_words'] ?? data['result_number'].toString();
        setState(() => _result = resText);
        Provider.of<UsageProvider>(context, listen: false).incrementUsage();
        await _speak(resText);

        final historyItem = HistoryItem(
          inputText: text,
          englishInput: "",
          resultEnglish: data['result_number'].toString(),
          resultLocal: resText,
          lang: _selectedLang,
          timestamp: DateTime.now().toString(),
        );
        await _historyService.add(historyItem);
        SyncService().syncNow();
      } else {
        setState(() => _result = "Error in calculation");
      }
    } catch (e) {
      setState(() => _result = "Server unreachable");
    }
  }

  void _clear() {
    setState(() {
      _input = "Tap the mic and start speaking...";
      _result = "Result..";
    });
    _flutterTts.stop();
  }


  Widget _buildVoiceCalculator() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLang,
                    menuMaxHeight: 400, // Limit height for all languages
                    items: const [
                      DropdownMenuItem(value: "ta-IN", child: Text("Tamil")),
                      DropdownMenuItem(value: "en-IN", child: Text("English")),
                      DropdownMenuItem(
                        value: "ml-IN",
                        child: Text("Malayalam"),
                      ),
                      DropdownMenuItem(value: "hi-IN", child: Text("Hindi")),
                      DropdownMenuItem(value: 'te-IN', child: Text('Telugu')),
                      DropdownMenuItem(
                        value: 'kn-IN',
                        child: Text('Kannada'),
                      ), // Added Kannada
                    ],
                    onChanged: (v) async {
                      setState(() => _selectedLang = v!);
                      await _flutterTts.setLanguage(v!);

                      // Verify availability when user changes language
                      bool available = await _flutterTts.isLanguageAvailable(
                        v!,
                      );
                      if (!available) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Voice data for this language might need to be downloaded in your phone settings.",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Voice Calculator",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _infoBox(_input, isHint: _input.contains("Tap")),
            const SizedBox(height: 15),
            _infoBox(_result, isResult: true, isHint: _result == "Result.."),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _onMicTap,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColor.gradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.pink.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isListening ? "Listening..." : "Tap to Speak",
                    style: const TextStyle(
                      color: AppColor.pink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton("Clear", isOutline: true, onTap: _clear),
                _actionButton(
                  "Calculate",
                  isOutline: false,
                  onTap: () => _calculate(_input),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine body based on bottom nav index
    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = const Center(
          child: Text("Home Dashboard coming soon..."),
        );
        break;
      case 1:
        bodyContent = _buildVoiceCalculator();
        break;
      case 2:
        bodyContent = const HistoryPage();
        break;
      default:
        bodyContent = _buildVoiceCalculator();
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColor.pink),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.jpg', height: 34),
            const SizedBox(width: 8),
            const Text(
              "EZY VOICE",
              style: TextStyle(
                color: AppColor.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColor.pink),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
        centerTitle: true,
      ),
      body: bodyContent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColor.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: "Voice Mode"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
    );
  }

  Widget _infoBox(String text, {bool isResult = false, bool isHint = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: isHint
              ? Colors.grey
              : (isResult ? AppColor.deepPurple : Colors.black87),
        ),
      ),
    );
  }

  Widget _actionButton(
    String title, {
    required bool isOutline,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isOutline ? null : AppColor.gradient,
          border: isOutline ? Border.all(color: AppColor.pink) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isOutline ? AppColor.pink : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
