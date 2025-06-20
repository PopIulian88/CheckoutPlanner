import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/wishbook_page.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    final appState = context.read<MyAppState>();
    await appState.loadEmployee();
    await appState.loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => appState.loadSchedule(),
                      child: const Text('Reload Schedule'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WishbookPage(),
                          ),
                        );
                      },
                      child: const Text('To Wishbook'),
                    ),
                  ]

              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: appState.scheduleList.length,
                itemBuilder: (context, index) {
                  final schedule = appState.scheduleList[index];

                  final shift1 = schedule.shift_1.map(
                        (id) {
                      final employee = appState.employeeList[id];
                      return '$id: ${employee.name ?? "Unknown"}\n';
                    },
                  ).join(', ');

                  final shift2 = schedule.shift_2.map(
                        (id) {
                      final employee = appState.employeeList[id];
                      return '$id: ${employee.name ?? "Unknown"}\n';
                    },
                  ).join('');

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                      },
                      children: [
                        // Header
                        if (index == 0)
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Shift 1',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Shift 2',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                        // Data row
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(schedule.date),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(shift1),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(shift2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            ),
          ],
        ),
    );
  }
}
