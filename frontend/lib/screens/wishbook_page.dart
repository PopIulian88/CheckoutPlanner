import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class WishbookPage extends StatefulWidget {
  const WishbookPage({super.key});

  @override
  State<WishbookPage> createState() => _WishbookPageState();
}

class _WishbookPageState extends State<WishbookPage> {

  late TextEditingController dateController;
  String shiftOption = 'SHIFT_1';
  int? employeeOption ;

  @override
  void initState() {
    super.initState();
    start();

    dateController = TextEditingController();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  Future<void> start() async {
    final appState = context.read<MyAppState>();
    await appState.loadWishbook();
    await appState.loadEmployee();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (employeeOption == null && appState.employeeList.isNotEmpty) {
      employeeOption = appState.employeeList[0].id;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Wishbook')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Date input
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date (yyyy-mm-dd)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    // Dropdown employee
                    DropdownButton<int>(
                      value: employeeOption,
                      items: appState.employeeList.map((employee) {
                        return DropdownMenuItem(
                          value: employee.id,
                          child: Text('${employee.id}: ${employee.name}'),
                        );
                      }).toList(),
                      hint: const Text('Select employee'),
                      onChanged: (value) {
                        setState(() {
                          employeeOption = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 16),

                    // Dropdown Shifts
                    DropdownButton<String>(
                      value: shiftOption,
                      items: const [
                        DropdownMenuItem(value: 'SHIFT_1', child: Text('SHIFT_1')),
                        DropdownMenuItem(value: 'SHIFT_2', child: Text('SHIFT_2')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          shiftOption = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 16),

                    // Submit button
                    ElevatedButton(
                      onPressed: () {
                        handleSubmitPress(dateController.text, employeeOption!, shiftOption);
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
                // Auto schedule button
                ElevatedButton(
                  onPressed: () async {
                    await handleAutoSchedulePress(dateController.text);
                  },
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.orange)),
                  child: const Text('PRESS TO AUTO SCHEDULE (admin)',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                ),
              ],
            ),
          ),

          // Wishbook
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Employee ID')),
                DataColumn(label: Text('Shift')),
                DataColumn(label: Text('Approve')),
                DataColumn(label: Text('Remove')),
              ],
              rows: appState.wishbookList.map(
                    (wishbook) {
                  return DataRow(
                    cells: [
                      DataCell(Text(wishbook.date)),
                      DataCell(
                          Text(
                              '${wishbook.employeeId}: ${appState.employeeList.firstWhere(
                                (e) => e.id == int.parse(wishbook.employeeId)
                              ).name}'
                          )
                      ),
                      DataCell(Text(wishbook.shift)),
                      // Approve
                      DataCell(
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await appState.planSchedule(
                                  wishbook.id, wishbook.date,
                                  int.parse(wishbook.employeeId),
                                  wishbook.shift);
                            }catch(e) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Schedule Full'),
                                  content: const Text('This time must be already full, or the employee is already assigned for the day'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }

                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.green)
                          ),
                          child: const Text('OK', style: TextStyle(color: Colors.black),),
                        ),
                      ),
                      // Delete
                      DataCell(
                        ElevatedButton(
                          onPressed: () async {
                            appState.deleteWishbook(wishbook.id);
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.red)
                          ),
                          child: const Text('DELETE', style: TextStyle(color: Colors.black),),
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

  Future<void> handleAutoSchedulePress(String date) async {
    final appState = Provider.of<MyAppState>(context, listen: false);

    // RegExp: 4 digits, '-', 2 digits, '-', 2 digits
    final RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

    if(datePattern.hasMatch(date)) {
      await appState.autoPlanSchedule(date);
    }else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Invalid Date'),
          content: const Text('Date must be in the format YYYY-MM-DD'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> handleSubmitPress(String date, int empId, String shiftOption) async {
    final appState = Provider.of<MyAppState>(context, listen: false);

    // RegExp: 4 digits, '-', 2 digits, '-', 2 digits
    final RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

    if(datePattern.hasMatch(date)) {
      await appState.setWishbook(date, empId, shiftOption);
    }else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Invalid Date'),
          content: const Text('Date must be in the format YYYY-MM-DD'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
