import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  /// Initialize TTS with default settings
  Future<void> _initializeTts() async {
    if (_isInitialized) return;

    try {
      // Configure TTS settings
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(0.8);
      await _flutterTts.setPitch(1.0);

      // Set up completion handler
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        debugPrint('TTS playback completed');
      });

      // Set up start handler  
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        debugPrint('TTS started speaking');
      });

      // Set up error handler
      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('TTS Error: $msg');
      });

      // Set up cancel handler
      _flutterTts.setCancelHandler(() {
        _isSpeaking = false;
        debugPrint('TTS cancelled');
      });

      _isInitialized = true;
      debugPrint('TTS initialized successfully');
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  /// Speak the provided text
  Future<bool> speakText(String text) async {
    try {
      if (text.trim().isEmpty) {
        debugPrint('Empty text provided for TTS');
        return false;
      }

      // Initialize TTS if not already done
      await _initializeTts();

      debugPrint('Speaking: "$text"');
      
      // Stop any current speech
      await _flutterTts.stop();
      
      // Speak the text
      final result = await _flutterTts.speak(text);
      
      if (result == 1) {
        debugPrint('TTS started successfully');
        return true;
      } else {
        debugPrint('TTS failed to start. Result: $result');
        return false;
      }
    } catch (e) {
      debugPrint('Error in TTS speakText: $e');
      return false;
    }
  }

  /// Stop current speech
  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
      debugPrint('TTS stopped');
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }

  /// Pause current speech
  Future<void> pauseSpeaking() async {
    try {
      await _flutterTts.pause();
      debugPrint('TTS paused');
    } catch (e) {
      debugPrint('Error pausing TTS: $e');
    }
  }

  /// Check if TTS is currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Set language for TTS
  Future<bool> setLanguage(String language) async {
    try {
      final result = await _flutterTts.setLanguage(language);
      debugPrint('Language set to: $language, Result: $result');
      return result == 1;
    } catch (e) {
      debugPrint('Error setting language: $e');
      return false;
    }
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate.clamp(0.0, 1.0));
      debugPrint('Speech rate set to: $rate');
    } catch (e) {
      debugPrint('Error setting speech rate: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume.clamp(0.0, 1.0));
      debugPrint('Volume set to: $volume');
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  /// Set pitch (0.5 to 2.0) 
  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch.clamp(0.5, 2.0));
      debugPrint('Pitch set to: $pitch');
    } catch (e) {
      debugPrint('Error setting pitch: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _flutterTts.stop();
    _isSpeaking = false;
    debugPrint('TTS service disposed');
  }
}

/// Singleton pattern for TTS service
class TTSManager {
  static TTSService? _instance;
  
  static TTSService get instance {
    _instance ??= TTSService();
    return _instance!;
  }
  
  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }
}
