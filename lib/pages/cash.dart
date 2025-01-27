import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/components/button1.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Cash extends StatefulWidget {
  const Cash({super.key});

  @override
  State<Cash> createState() => _CashState();
}

class _CashState extends State<Cash> {
  List<TextEditingController> inAmtConList = [];
  List<TextEditingController> inLabConList = [];
  List<TextEditingController> outAmtConList = [];
  List<TextEditingController> outLabConList = [];
  List<Widget> inInput = [];
  List<Widget> outInput = [];
  TextEditingController beginningCashCon = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List cashFlowBox = [];
  double startingSales = 0;

  @override
  void initState() {
    super.initState();

    cashFlowBox = userDataBox.get(userKey).cashFlowLsit;
    print(cashFlowBox);

    if (cashFlowBox.isNotEmpty) {
      beginningCashCon.text =
          cashFlowBox[cashFlowBox.length - 1]['endingCash'].toString();
    } else {
      beginningCashCon.text = '0';
    }

    var lastCashFlowDate = cashFlowBox.isNotEmpty
        ? cashFlowBox[cashFlowBox.length - 1]['date']
        : null;

    for (var item in userDataBox.get(userKey).transactionList) {
      // startingSales += item['price'] * item['cost'];

      if (lastCashFlowDate != null) {
        if (item['date'].isAfter(lastCashFlowDate)) {
          startingSales += item['price'] * item['quantity'];
        }
      } else {
        startingSales += item['price'] * item['quantity'];
      }
    }

    print('Starting Sales: $startingSales');

    if (startingSales > 0) {
      inAmtConList.add(TextEditingController(text: startingSales.toString()));
      inLabConList.add(TextEditingController(text: 'Starting Sales'));
      inInput.add(buildInput(inAmtConList[inAmtConList.length - 1], 'Inflow',
          inAmtConList.length - 1, inLabConList[inLabConList.length - 1]));
    }
  }

  Widget buildInput(TextEditingController amtCon, String type, int index,
      TextEditingController labCon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text('$type ${index + 1}'),
        SizedBox(
          height: 50,
          width: 150,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: 'label', hintStyle: TextStyle(color: Colors.grey)),
            controller: labCon,
          ),
        ),
        SizedBox(
          height: 50,
          width: 70,
          child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'amount', hintStyle: TextStyle(color: Colors.grey)),
              textAlign: TextAlign.center,
              controller: amtCon,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                setState(() {});
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(cashFlowBox);
    double cashInflow = 0;
    double cashOutflow = 0;
    double endingCash = 0;
    TextStyle headerStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    for (var item in inAmtConList) {
      if (item.text.isNotEmpty) {
        cashInflow += double.parse(item.text);
      }
    }
    for (var item in outAmtConList) {
      if (item.text.isNotEmpty) {
        cashOutflow += double.parse(item.text);
      }
    }

    if (beginningCashCon.text.isNotEmpty) {
      endingCash =
          double.parse(beginningCashCon.text) + cashInflow - cashOutflow;
    } else {
      endingCash = cashInflow - cashOutflow;
    }

    addInflow() {
      TextEditingController amtCon = TextEditingController();
      TextEditingController labCon = TextEditingController();
      int index = inAmtConList.length;
      setState(() {
        inAmtConList.add(amtCon);
        inLabConList.add(labCon);
        inInput.add(buildInput(amtCon, 'Inflow', index, labCon));
      });
    }

    addOutflow() {
      TextEditingController amtCon = TextEditingController();
      TextEditingController labCon = TextEditingController();
      int index = outAmtConList.length;
      setState(() {
        outAmtConList.add(amtCon);
        outLabConList.add(labCon);
        outInput.add(buildInput(amtCon, 'Outflow', index, labCon));
      });
    }

    saveCashFlow(DateTime date) {
      cashFlowBox.add({
        'beginningCash': double.parse(beginningCashCon.text),
        'cashInflow': cashInflow,
        'cashOutflow': cashOutflow,
        'endingCash': endingCash,
        'date': date,
      });
      userDataBox.put(userKey, userDataBox.get(userKey));
    }

    showConfirm() {
      DateFormat formatter = DateFormat('MMM dd, yyyy HH:mm');
      DateTime dateRaw = DateTime.now();
      String date = formatter.format(dateRaw);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Save Cash Flow?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure you want to save this cash flow?'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ',
                    ),
                    SizedBox(width: 10),
                    Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Beginning Cash: ',
                    ),
                    SizedBox(width: 10),
                    Text('PHP ${beginningCashCon.text}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash Inflow: ',
                    ),
                    SizedBox(width: 10),
                    Text('PHP ${cashInflow.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash Outflow: ',
                    ),
                    SizedBox(width: 10),
                    Text('PHP ${cashOutflow.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ending Cash: ',
                    ),
                    SizedBox(width: 10),
                    Text('PHP ${endingCash.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  saveCashFlow(dateRaw);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: Appbar(title: "Cash", leading: true),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Beginning Cash: ',
                              style: headerStyle,
                            ),
                            SizedBox(
                              height: 50,
                              width: 70,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 17,
                                    color: beginningCashCon.text.isEmpty
                                        ? Colors.grey.shade200
                                        : double.parse(beginningCashCon.text) >
                                                0
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(hintText: 'amount'),
                                textAlign: TextAlign.center,
                                controller: beginningCashCon,
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  setState(() {});
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*required';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.grey,
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'The initial Beginning Cash is the Ending Cash of the previous record.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cash Inflow: ',
                            style: headerStyle,
                          ),
                          Text(
                            'PHP ${cashInflow.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 17),
                          )
                        ],
                      ),
                      SizedBox(
                        height: inInput.length * 50.0,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: inInput.length,
                          itemBuilder: (context, index) {
                            return inInput[index];
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: inInput.isNotEmpty
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        children: [
                          Button1(
                            onpressed: addInflow,
                            label: 'Add Item',
                            icon: Icons.add,
                            color: Colors.green,
                          ),
                          inInput.isNotEmpty
                              ? Button1(
                                  onpressed: () {
                                    setState(() {
                                      inAmtConList.removeLast();
                                      inInput.removeLast();
                                    });
                                  },
                                  label: 'Remove Item',
                                  icon: Icons.delete_forever_rounded,
                                  color: Colors.red,
                                )
                              : SizedBox(),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cash Outflow: ', style: headerStyle),
                          Text(
                            'PHP ${cashOutflow.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 17),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: outInput.length * 50.0,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: outInput.length,
                          itemBuilder: (context, index) {
                            return outInput[index];
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: outInput.isNotEmpty
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        children: [
                          Button1(
                            onpressed: addOutflow,
                            label: 'Add Item',
                            icon: Icons.add,
                            color: Colors.green,
                          ),
                          outInput.isNotEmpty
                              ? Button1(
                                  onpressed: () {
                                    setState(() {
                                      outAmtConList.removeLast();
                                      outInput.removeLast();
                                    });
                                  },
                                  label: 'Remove Item',
                                  icon: Icons.delete_forever_rounded,
                                  color: Colors.red,
                                )
                              : SizedBox()
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ending Cash: ', style: headerStyle),
                          Text(
                            'PHP ${endingCash.toStringAsFixed(2)}',
                            style: TextStyle(
                                color:
                                    endingCash > 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      showConfirm();
                    }
                  },
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
