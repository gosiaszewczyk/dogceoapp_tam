# Dog CEO App

Aplikacja mobilna we Flutterze korzystajaca z publicznego REST API Dog CEO.

## Funkcje

- lista ras psow pobierana z endpointu `https://dog.ceo/api/breeds/list/all`
- ekran szczegolow rasy z losowym zdjeciem z endpointu `https://dog.ceo/api/breed/{breed}/images/random`
- lokalny zapis danych w Hive CE, dzieki czemu lista dziala po ponownym uruchomieniu aplikacji bez internetu
- oznaczanie ras jako ulubione
- osobny ekran ulubionych ras
- ekran statystyk zapisanych danych
- reczne odswiezanie danych z API
- stan ladowania i komunikaty bledow

## Materialy z laboratoriow

Projekt wykorzystuje mechanizmy przerabiane na laboratoriach:

- `StatefulWidget` i `StatelessWidget`
- `MaterialApp`, `Scaffold`, `AppBar`, `Card`, `ListTile`
- `ListView.builder`
- `Navigator.push` i `MaterialPageRoute`
- `FutureBuilder`
- pakiet `http`
- `jsonDecode`
- lokalna baza `Hive CE`
- `setState`

## Uruchomienie

```bash
flutter pub get
flutter run
```

Na Windowsie Flutter moze wymagac wlaczonego Developer Mode, poniewaz paczki z pluginami korzystaja z symlinkow.
