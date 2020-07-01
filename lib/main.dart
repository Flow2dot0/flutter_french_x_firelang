import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'French X Firelang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

enum Lang {
  French,
  Firelang,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// [_parasite] is used for
  /// french to firelang traduction
  final String _parasite = 'av';

  /// [_textEditingController] is used for
  /// clean the input TextField
  final TextEditingController _textEditingController = TextEditingController();

  /// [_lang] is the actual
  /// selected radio index
  Lang _lang = Lang.Firelang;

  /// [_displayed] is the result
  /// traduction on screen
  String _displayed = '';

  /// String [char] as args
  /// evaluate by RegExp
  /// if contains any of this char
  /// bool as return
  bool _isVoyelle(String char) =>
      char.contains(RegExp(r'[aàâäeéèêëiïîoôöuùûüyÿ]'));
  bool _isConsonne(String char) =>
      char.contains(RegExp(r'[bcçdfghjklmnpqrstvwxz]'));

  /// String [text] as args
  /// if not empty
  /// loop on any characters of the [text]
  /// Add [_parasite] to [traduction] on index 0 on case
  /// _isVoyelle(index) => return true
  /// Add [_parasite] to [traduction] on indexes on case
  /// _isConsonne(index) and _isVoyelle(index+1) => return true
  /// incrementing index in that case to skip the next loop
  /// Add current character to [traduction] in other cases
  /// refresh [_displayed]
  void _toFirelang(String text) {
    String traduction = '';
    if (text != null) {
      for (var index = 0; index < text.length; index++) {
        if (index == 0 && _isVoyelle(text[index])) {
          traduction += _parasite + text[index];
        } else if (index == text.length - 1) {
          traduction += text[index];
        } else {
          if (_isConsonne(text[index])) {
            if (_isVoyelle(text[index + 1])) {
              traduction += text[index] + _parasite + text[index + 1];
              index++;
            } else {
              traduction += text[index];
            }
          } else {
            traduction += text[index];
          }
        }
      }
    }
    _displayed = traduction;
  }

  /// String [text] as args
  /// replace all [_parasite] on text
  /// refresh [_displayed]
  void _toFrench(String text) {
    _displayed = text.replaceAll(_parasite, '');
  }

  /// Dispose [_textEditingController]
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCard(
                  Row(
                    children: [
                      Text('to Firelang'),
                      Radio(
                          value: Lang.Firelang,
                          groupValue: _lang,
                          onChanged: (Lang value) {
                            setState(() {
                              _switchLang(value);
                            });
                          }),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                ),
                _buildCard(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: Lang.French,
                          groupValue: _lang,
                          onChanged: (Lang value) {
                            setState(() {
                              _switchLang(value);
                            });
                          }),
                      Text('to French'),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
                ),
              ],
            ),
            _buildCard(
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: 'Write text'),
                  keyboardType: TextInputType.text,
                  onChanged: (String newString) {
                    setState(() {
                      _lang == Lang.Firelang
                          ? _toFirelang(newString)
                          : _toFrench(newString);
                    });
                  },
                ),
                width: 265),
            SizedBox(
              height: 50,
            ),
            _buildCard(
                Text(
                  _displayed,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                width: 265),
          ],
        ),
      ),
    );
  }

  _buildCard(Widget child,
      {num width,
      EdgeInsets margin,
      EdgeInsets padding = const EdgeInsets.all(20)}) {
    return Card(
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        child: child,
      ),
    );
  }

  _switchLang(Lang value) {
    _lang = value;
    _displayed = '';
    _textEditingController.clear();
  }
}
