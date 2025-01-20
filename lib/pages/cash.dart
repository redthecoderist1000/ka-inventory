import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ka_inventory/components/appBar.dart';

class Cash extends StatefulWidget {
  const Cash({super.key});

  @override
  State<Cash> createState() => _CashState();
}

class _CashState extends State<Cash> {
  List<TextEditingController> inController = [];
  List<TextEditingController> outController = [];
  List<Widget> inInput = [];
  List<Widget> outInput = [];
  double beginningCash = 0;

  @override
  Widget build(BuildContext context) {
    double cashInflow = 0;
    double cashOutflow = 0;
    TextStyle headerStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    for (var item in inController) {
      if (item.text.isNotEmpty) {
        cashInflow += double.parse(item.text);
      }
    }
    for (var item in outController) {
      if (item.text.isNotEmpty) {
        cashOutflow += double.parse(item.text);
      }
    }

    Widget buildInput(controller, label) {
      return TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            setState(() {});
          },
          decoration: InputDecoration(
            labelText: label,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ]);
    }

    addInflow() {
      TextEditingController controller = TextEditingController();
      setState(() {
        inController.add(controller);
        inInput
            .add(buildInput(controller, 'Cash Infloww ${inInput.length + 1}'));
      });
    }

    addOutflow() {
      TextEditingController controller = TextEditingController();
      setState(() {
        outController.add(controller);
        outInput
            .add(buildInput(controller, 'Cash Outflow ${outInput.length + 1}'));
      });
    }

    return Scaffold(
      appBar: Appbar(title: "Cash", leading: true),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.grey.shade700),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Beginning Cash: ',
                        style: headerStyle,
                      ),
                      Text('₱0.00')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cash Inflow: ',
                        style: headerStyle,
                      ),
                      Text('PHP ${cashInflow.toStringAsFixed(2)}')
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
                  ElevatedButton(
                    onPressed: addInflow,
                    child: Text('Add Cash Inflow'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cash Outflow: ', style: headerStyle),
                      Text('PHP ${cashOutflow.toStringAsFixed(2)}')
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
                  ElevatedButton(
                    onPressed: addOutflow,
                    child: Text('Add Cash Outflow'),
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ending Cash: ', style: headerStyle),
                      Text('₱0.00')
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
