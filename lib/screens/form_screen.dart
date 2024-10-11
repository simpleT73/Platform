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

  final pName = TextEditingController();
  final fName = TextEditingController();
  final pDate = TextEditingController();
  final userAmount = TextEditingController();
  final date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แบบฟอร์มเพิ่มข้อมูล'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'เพิ่มข้อมูล Platform',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ชื่อ Platform',
                        prefixIcon: const Icon(Icons.apps),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      controller: pName,
                      validator: (String? str) {
                        if (str!.isEmpty) {
                          return 'กรุณากรอกชื่อ Platform';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ชื่อผู้ก่อตั้ง',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      controller: fName,
                      validator: (String? str) {
                        if (str!.isEmpty) {
                          return 'กรุณากรอกชื่อผู้ก่อตั้ง';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'วันที่เปิดให้เริ่มใช้งาน',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      controller: pDate,
                      validator: (String? str) {
                        if (str!.isEmpty) {
                          return 'กรุณากรอกวันที่เปิดใช้งาน';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'จำนวนผู้ใช้งาน',
                        prefixIcon: const Icon(Icons.group),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      controller: userAmount,
                      validator: (String? input) {
                        try {
                          int amount = int.parse(input!);
                          if (amount < 0) {
                            return 'กรุณากรอกข้อมูลมากกว่า 0';
                          }
                        } catch (e) {
                          return 'กรุณากรอกข้อมูลเป็นตัวเลข';
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // สร้าง object ของ transaction
                            var statement = Transactions(
                              keyID: null,
                              pName: pName.text,
                              fName: fName.text,
                              pDate: pDate.text,
                              userAmount: int.parse(userAmount.text),
                              date: DateTime.now(),
                            );

                            // เพิ่มข้อมูล transaction ลงใน provider
                            var provider = Provider.of<TransactionProvider>(context, listen: false);
                            provider.addTransaction(statement);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MyHomePage();
                                },
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'บันทึก',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
