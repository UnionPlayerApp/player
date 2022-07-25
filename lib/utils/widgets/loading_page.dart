import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  final String _title;
  final String _version;

  ProgressPage({Key? key, required List<String> params})
      : _title = params[0],
        _version = params[1],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(_version, style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
        ],
      ),
    );
  }
}
