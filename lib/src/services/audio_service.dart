import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final FlutterTts _flutterTts;

  AudioService() : _flutterTts = FlutterTts() {
    _setupTts();
  }

  Future<void> _setupTts() async {
    // Basic setup. You can expand this to set specific languages,
    // speech rates, etc., as needed.
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt
    );
  }

  Future<void> playAudio(String text) async {
    try {
      // Stop any currently speaking audio before starting a new one.
      await _flutterTts.stop();
      // Speak the provided text.
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('Error playing audio with flutter_tts: $e');
    }
  }

  void dispose() {
    // Stop any active speech when the service is disposed.
    _flutterTts.stop();
  }
}