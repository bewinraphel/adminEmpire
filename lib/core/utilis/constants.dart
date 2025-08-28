class SharedpreferenceKey {
  static const String isLoggedIn = 'is_Logged_in';
  
}
String limitWords(String text, int maxWords) {
  final words = text.split(' ');
  if (words.length <= maxWords) return text;
  return words.sublist(0, maxWords).join(' ') + '...';
}