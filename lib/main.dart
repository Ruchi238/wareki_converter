import 'package:flutter/material.dart';

void main() {
  runApp(const WarekiConverterApp());
}

class WarekiConverterApp extends StatelessWidget {
  const WarekiConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上の「Debug」ラベルを非表示にする
      debugShowCheckedModeBanner: false,
      title: '和暦西暦変換',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String _selectedEra = '令和';
  String _inputYear = '';
  String _result = '数字を押してね';

  // 数字ボタンが押された時の処理
  void _onNumberPressed(String number) {
    setState(() {
      // 最初の数字が0にならないように制限
      if (_inputYear == '' && number == '0') return;
      // 4桁以上は入力できないように制限（実用的には2~3桁で十分なため）
      if (_inputYear.length >= 3) return;

      _inputYear += number;
      _updateResult();
    });
  }

  // 消去ボタン（C）が押された時の処理
  void _onClear() {
    setState(() {
      _inputYear = '';
      _result = '数字を押してね';
    });
  }

  // 西暦への変換計算
  void _updateResult() {
    int? year = int.tryParse(_inputYear);
    if (year == null) return;

    int seireki;
    switch (_selectedEra) {
      case '令和':
        seireki = year + 2018;
        break;
      case '平成':
        seireki = year + 1988;
        break;
      case '昭和':
        seireki = year + 1925;
        break;
      default:
        seireki = 0;
    }
    setState(() {
      _result = '西暦 $seireki 年';
    });
  }

  // 数字ボタンを作成する共通パーツ
  Widget _buildNumButton(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _onNumberPressed(label),
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('和暦・西暦変換'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // 元号選択ボタン
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: '令和', label: Text('令和')),
              ButtonSegment(value: '平成', label: Text('平成')),
              ButtonSegment(value: '昭和', label: Text('昭和')),
            ],
            selected: {_selectedEra},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedEra = newSelection.first;
                // 元号を変えたら入力をリセットする（ご要望のポイント！）
                _inputYear = '';
                _result = '数字を押してね';
              });
            },
          ),
          const SizedBox(height: 40),
          // 入力と結果の表示エリア
          Card(
            elevation: 0,
            color: Colors.blue.withOpacity(0.05),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      '$_selectedEra $_inputYear 年',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Icon(Icons.arrow_downward, color: Colors.grey),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          // 電卓風の数字入力キーパッド
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildNumButton('1'),
                    _buildNumButton('2'),
                    _buildNumButton('3'),
                  ],
                ),
                Row(
                  children: [
                    _buildNumButton('4'),
                    _buildNumButton('5'),
                    _buildNumButton('6'),
                  ],
                ),
                Row(
                  children: [
                    _buildNumButton('7'),
                    _buildNumButton('8'),
                    _buildNumButton('9'),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox()), // 左側の空白
                    _buildNumButton('0'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _onClear,
                          child: const Text(
                            'C',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
