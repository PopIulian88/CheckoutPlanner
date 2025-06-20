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
      appBar: AppBar(title: const Text('Schedule')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishbookPage(),
                  ),
                );
                },
              child: const Text('To Wishbook ---->'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowMaxHeight: 80,
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Shift 1 \n(07:00 - 15:30)')),
                DataColumn(label: Text('Shift 2 \n(11:30 - 20:00)')),
                DataColumn(label: Text('Free employee')),
              ],
              rows: appState.scheduleList.map(
                    (schedule) {
                  return DataRow(
                    cells: [
                      DataCell(Text(schedule.date)),
                      DataCell(
                          Text(schedule.shift_1.map(
                                (id) {
                                  final employee = appState.employeeList[id - 1];
                                  return '$id: ${employee.name ?? "Unknown"}';
                                },
                            ).join('\n'),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          )
                      ),
                      DataCell(
                          Text(schedule.shift_2.map(
                                (id) {
                              final employee = appState.employeeList[id - 1];
                              return '${employee.name ?? "Unknown"} (id: $id)';
                            },
                          ).join('\n'),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            appState.deleteSchedule(schedule.date);
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ],
      )
    );
  }
}
