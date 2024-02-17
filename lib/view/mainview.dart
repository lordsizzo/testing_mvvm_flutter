import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/mainview_model.dart';
import '../view_model/mainview_viewmodel.dart';

class MainView extends StatefulWidget {
  String title;
  MainView(this.title, {super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _counter = 0;

  void _incrementCounter() {
    final viewModel = Provider.of<PersonViewModel>(context, listen: false);
    viewModel.increment(Counter(counter: _counter++));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer<PersonViewModel>(
              builder: (context, viewModel, _) {
                return Text(viewModel.count);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
