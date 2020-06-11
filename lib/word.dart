import 'dart:math';

class Word {
  final String word;

  Word(this.word);

  String scramble() {
    Random r = new Random();
    // Convert your string into a simple char array:
    List<String> a = word.split('');

    // Scramble the letters using the standard Fisher-Yates shuffle
    // Modify slightly by making first letter not first letter!
    for (int i = 0; i < a.length - 1; i++) {
      int j;
      if (i == 0) {
        j = r.nextInt(a.length - 2) + 1;
      } else {
        j = i + r.nextInt(a.length - i);
      }

      // Swap letters
      String _temp = a[i];
      a[i] = a[j];
      a[j] = _temp;
    }

    return a.join('');
  }

  String display() {
    return word.toUpperCase();
  }
}