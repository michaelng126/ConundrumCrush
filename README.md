# Conundrum Crush

Conundrum Crush is a conundrum solving game app for Android and iOS.

The player tries to unscramble anagrams as quickly as possible, with the purpose of leveling up to become a 'Conundrum Master'. 


(note: this is the initial prototype for portfolio purposes. The full repo remains private.)

## Development

Conundrum Crush was developed with Google Flutter, a competitor of React Native - cross-platform app development frameworks. Flutter is based off Dart, which is similar to Java. My setup was VSCode and Terminal (lightweight).

### Selecting Words based on Google Frequency

I used SQLite to store the word list in a database. This list was then joined with word frequency from Google WordRank data. This allows inherent 'difficulty' based on how common the word is.

### Adding Definitions using the ENABLE API

Adding definitions for the words was a heavily requested feature. I implemented this using the public online dictionary API 'ENABLE'.

