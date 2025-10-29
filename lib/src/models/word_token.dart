import 'package:uuid/uuid.dart';

// A helper class to give each word in the sentence assembly exercise a unique ID.
// This is necessary to distinguish between identical words (e.g., "the" appearing twice).
class WordToken {
  final String id;
  final String word;

  WordToken({required this.word}) : id = const Uuid().v4();
}