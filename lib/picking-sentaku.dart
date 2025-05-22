import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:otk_wms_mock/pickking-cs.dart';
import 'package:otk_wms_mock/pickking-pcs.dart';
import 'package:otk_wms_mock/pickking-pl.dart';

class PickInstructionScreen extends StatefulWidget {
  const PickInstructionScreen({super.key});

  @override
  State<PickInstructionScreen> createState() => _PickInstructionScreenState();
}

class _PickInstructionScreenState extends State<PickInstructionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<int, List<Map<String, dynamic>>> floorData = {
    0: [
      {'location': '　01001 ', 'pl': 1, 'cs': 3, 'shelfCs': 0, 'shelfBr': 1},
      {'location': '　01002 ', 'pl': 2, 'cs': 0, 'shelfCs': 0, 'shelfBr': 2},
    ],
    1: [
      {'location': '　02002 ', 'pl': 2, 'cs': 1, 'shelfCs': 0, 'shelfBr': 3},
      {'location': '　02003 ', 'pl': 0, 'cs': 0, 'shelfCs': 0, 'shelfBr': 1},
    ],
    2: [
      {'location': '　03003 ', 'pl': 0, 'cs': 2, 'shelfCs': 0, 'shelfBr': 0},
      {'location': '　03004 ', 'pl': 0, 'cs': 0, 'shelfCs': 0, 'shelfBr': 2},
    ],
    3: [
      {'location': '　04004 ', 'pl': 1, 'cs': 0, 'shelfCs': 0, 'shelfBr': 1},
      {'location': '　04005 ', 'pl': 0, 'cs': 0, 'shelfCs': 0, 'shelfBr': 0},
    ],
  };


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // 音声再生（画面表示後）
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/pic-sentaku.ogg'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(40),
            ),
            clipBehavior: Clip.antiAlias,
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: const Text(
                  'ピック指示選択',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica Neue',
                  ),
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black54,
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: '1F'),
                        Tab(text: '2F'),
                        Tab(text: '3F'),
                        Tab(text: '4F'),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: List.generate(4, (index) {
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: _buildTable(floorData[index]!),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> data) {
    return Column(
      children: [
        _buildHeaderRow(),
        const Divider(color: Colors.black),
        ...data.map((row) => _buildDataRow(row)).toList(),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _tableHeaderCell('元ロケエリア'),
        _tableHeaderCell('PL'),
        _tableHeaderCell('CS'),
        _tableHeaderCell('棚CS'),
        _tableHeaderCell('棚BR'),
      ],
    );
  }

  Widget _buildDataRow(Map<String, dynamic> row) {
    final int rowIndex = floorData[_tabController.index]!.indexOf(row);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _tableCell(row['location']),
          _clickableCell(row['pl'].toString(), () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const PickkingPLScreen(), // ← 通常の画面
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _clickableCell(row['cs'].toString(), () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const PickkingCSScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _clickableCell(row['shelfCs'].toString(), () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const PickkingCSScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
          _clickableCell(row['shelfBr'].toString(), () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const PickkingPCSScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
        ],
      ),
    );
  }

  static Widget _tableHeaderCell(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }

  static Widget _tableCell(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }

  static Widget _clickableCell(String value, VoidCallback? onTap) {
    if (value == '0') {
      return _tableCell(value);
    }
    return GestureDetector(
      onTap: onTap,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontFamily: 'Helvetica Neue',
        ),
      ),
    );
  }
}
