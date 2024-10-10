import 'package:account/main.dart';
import 'package:account/models/transactions.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatefulWidget {


  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();

   final  pName = TextEditingController();
   final  fName = TextEditingController();
   final  pDate = TextEditingController();
   final  userAmount = TextEditingController();
   final  date = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        appBar: AppBar(
          title: const Text('แบบฟอร์มเพิ่มข้อมูล'),
        ),
        body: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ Platform',
                  ),
                  autofocus: false,
                  controller: pName,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'กรุณากรอกชื่อ Platform';
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อผู้ก่อตั้ง',
                  ),
                  autofocus: false,
                  controller: fName,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'กรุณากรอกชื่อผู้ก่อตั้ง';
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'วันที่เปิดให้เริ่มใช้งาน',
                  ),
                  autofocus: false,
                  controller: pDate,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'กรุณากรอกชื่อผู้ก่อตั้ง';
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'จำนวนผู้ใช้งาน',
                  ),
                  keyboardType: TextInputType.number,
                  controller: userAmount,
                  validator: (String? input) {
                    try {
                      double amount = double.parse(input!);
                      if (amount < 0) {
                        return 'กรุณากรอกข้อมูลมากกว่า 0';
                      }
                    } catch (e) {
                      return 'กรุณากรอกข้อมูลเป็นตัวเลข';
                    }
                  },
                ),
                TextButton(
                    child: const Text('บันทึก'),
                    onPressed: () {
                          if (formKey.currentState!.validate())
                            {
                              // create transaction data object
                              var statement = Transactions(
                                  keyID: null,
                                  pName: pName.text,
                                  fName: fName.text,
                                  pDate: pDate.text,
                                  userAmount: int.parse(userAmount.text),
                                  date: DateTime.now()
                                  );
                            
                              // add transaction data object to provider
                              var provider = Provider.of<TransactionProvider>(context, listen: false);
                              
                              provider.addTransaction(statement);

                              Navigator.push(context, MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context){
                                  return MyHomePage();
                                }
                              ));
                            }
                        })
              ],
            )));
  }
}

