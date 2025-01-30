import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Cash extends StatefulWidget {
  const Cash({super.key});

  @override
  State<Cash> createState() => _CashState();
}

class _CashState extends State<Cash> {
  DateTime date = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  addInflowDialog() {
    // add inflow
    var labCon = TextEditingController();
    var amountCon = TextEditingController();
    var formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Inflow'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: labCon,
                    decoration: InputDecoration(labelText: 'Label'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter label';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: amountCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all(2),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addinflow(labCon.text, double.parse(amountCon.text));
                    }
                  },
                  child: Text('Save')),
            ],
          );
        });
  }

  addinflow(String label, double amount) {
    // add inflow
    userDataBox.get(userKey).cashFlowLsit.add({
      'cid': userDataBox.get(userKey).cashFlowLsit.length + 1,
      'label': label,
      'amount': amount,
      'type': 'inflow',
      'date': DateTime.now()
    });
    userDataBox.put(userKey, userDataBox.get(userKey));
    Navigator.pop(context);
  }

  addOutFlowDialog() {
    // add inflow
    var labCon = TextEditingController();
    var amountCon = TextEditingController();
    var formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Outflow'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: labCon,
                    decoration: InputDecoration(labelText: 'Label'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter label';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: amountCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all(2),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addOutFlow(labCon.text, double.parse(amountCon.text));
                    }
                  },
                  child: Text('Save')),
            ],
          );
        });
  }

  addOutFlow(String label, double amount) {
    // add inflow
    userDataBox.get(userKey).cashFlowLsit.add({
      'cid': userDataBox.get(userKey).cashFlowLsit.length + 1,
      'label': label,
      'amount': amount,
      'type': 'outflow',
      'date': DateTime.now()
    });
    userDataBox.put(userKey, userDataBox.get(userKey));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
    NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');

    double begCash = 0;

    changeDate() async {
      var selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2021),
          lastDate: DateTime.now());

      if (selectedDate != null) {
        setState(() {
          date = selectedDate;
        });
      }
    }

    // get beginning cash
    var yesterdayCashFlow =
        userDataBox.get(userKey).cashFlowLsit.where((element) {
      DateTime curDate = DateTime(date.year, date.month, date.day);
      DateTime eleDate = element['date'];

      return eleDate.isBefore(curDate);
    }).toList();

    yesterdayCashFlow.forEach((element) {
      if (element['type'] == 'sales' || element['type'] == 'inflow') {
        begCash += element['amount'];
      } else {
        begCash -= element['amount'];
      }
    });

    return Scaffold(
      appBar: Appbar(title: "Cash", leading: true),
      body: ValueListenableBuilder(
          valueListenable: userDataBox.listenable(),
          builder: (context, box, child) {
            double totalInflow = 0;
            double totalOutflow = 0;

            var cashFlowList = box.get(userKey).cashFlowLsit.where((element) {
              DateTime eleDate = element['date'];
              return eleDate.year == date.year &&
                  eleDate.month == date.month &&
                  eleDate.day == date.day;
            }).toList();

            cashFlowList.forEach((element) {
              // DateTime eleDate = element['date'];
              if (element['type'] == 'inflow' || element['type'] == 'sales') {
                totalInflow += element['amount'];
              } else {
                totalOutflow += element['amount'];
              }
            });

            double endCash = begCash + totalInflow - totalOutflow;

            return Column(
              children: [
                // header
                Container(
                  padding:
                      EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      setState(() {
                                        date = date.subtract(Duration(days: 1));
                                      });
                                    },
                                    icon: Icon(Icons.arrow_back_ios_rounded)),
                                Text(dateFormat.format(date)),
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      setState(() {
                                        if (DateTime.now().isAfter(
                                            date.add(Duration(days: 1)))) {
                                          date = date.add(Duration(days: 1));
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.arrow_forward_ios_rounded))
                              ],
                            ),
                            IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: changeDate,
                                icon: Icon(Icons.calendar_month_rounded))
                          ],
                        ),
                        Divider(
                          height: 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Beginning Cash',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  currencyFormat.format(begCash),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: begCash < 0
                                          ? Colors.red
                                          : Colors.green),
                                )
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Inflow',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "+${currencyFormat.format(totalInflow)}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.green),
                                )
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Outflow',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "-${currencyFormat.format(totalOutflow)}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ending Cash',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currencyFormat.format(endCash),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: endCash < 0 ? Colors.red : Colors.green,
                              ),
                            )
                          ],
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 10),
                                children: [
                              TextSpan(
                                  text: 'note: ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'Total Sales and Purchase will be automatically added to Inflow and Outflow at the end of the day.',
                                  style: TextStyle(color: Colors.grey))
                            ]))
                      ],
                    ),
                  ),
                ),
                // actual list
                Expanded(
                  child: ListView.builder(
                    itemCount: cashFlowList.length,
                    itemBuilder: (context, index) {
                      var item = cashFlowList[index];
                      bool isOutflow = item['type'] == 'outflow' ||
                              item['type'] == 'purchase'
                          ? true
                          : false;

                      return Container(
                        margin: EdgeInsets.only(right: 20, left: 20, top: 5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: Colors.white,
                          title: Text(item['label'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text(
                              isOutflow
                                  ? "-${currencyFormat.format(item['amount'])}"
                                  : "+${currencyFormat.format(item['amount'])}",
                              style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      isOutflow ? Colors.red : Colors.green)),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 70,
                )
              ],
            );
          }),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: MaterialButton(
                height: 50,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: addInflowDialog,
                textColor: Colors.white,
                child: Text(
                  "Inflow",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: MaterialButton(
                height: 50,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: addOutFlowDialog,
                textColor: Colors.white,
                child: Text("Outflow",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
