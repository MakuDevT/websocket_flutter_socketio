import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Scoket"),
      ),
      body: Column(
        children: [
          Center(
            child: Text("Talk to me"),
          ),
          Form(
            child: TextFormField(
              decoration: InputDecoration(labelText: "Send any message"),
              controller: editingController,
            ),
          ),
          StreamBuilder(
              stream: _channel.stream,
              builder: ((context, snapshot) {
                return Text(snapshot.hasData ? "${snapshot.data}" : "olol");
              }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (() {
          setState(() {
            print("sheesh");
            _sendMessage();
          });
        }),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (editingController.text.isNotEmpty) {
      _channel.sink.add(editingController.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
  }
}
