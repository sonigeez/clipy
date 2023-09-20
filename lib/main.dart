import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ClipyApp());
}

class ClipyApp extends StatelessWidget {
  const ClipyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String> clipBoardContent = {};
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchClipBoard();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void fetchClipBoard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      var output = data!.text!;
      var length = clipBoardContent.length;
      clipBoardContent.add(output);
      if (length != clipBoardContent.length) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff544340),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                'Clipy',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: CupertinoSearchTextField(
                  backgroundColor: const Color(0xff544340),
                  onChanged: (value) {
                    setState(() {
                      clipBoardContent = clipBoardContent
                          .where((element) => element.contains(value))
                          .toSet();
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clipBoardContent.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () async {
                  ClipboardData data =
                      ClipboardData(text: clipBoardContent.elementAt(index));
                  await Clipboard.setData(data);
                },
                title: Text(
                  clipBoardContent.elementAt(index),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
