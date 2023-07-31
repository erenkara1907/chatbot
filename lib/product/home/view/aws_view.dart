import 'package:chatbot/core/utils/aws_polly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AwsView extends StatefulWidget {
  const AwsView({super.key});

  @override
  _AwsViewState createState() => _AwsViewState();
}

class _AwsViewState extends State<AwsView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter AWS Polly'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Provider.of<AwsPollyService>(context,
                        listen: false)
                    .onLoadUrl(
                        "Hello, I want to buy a flower for my beautiful girlfriend. Her favorite color is white, so I want to buy a white lilac."),
                child: const Text('Load URL'),
              ),
              ElevatedButton(
                onPressed: () =>
                    Provider.of<AwsPollyService>(context, listen: false)
                        .onPlay(),
                child: const Text('Play URL'),
              ),
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: const <Widget>[
                    Text('URL: '),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
