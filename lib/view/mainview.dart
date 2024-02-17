import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/mainview_model.dart';
import '../model/mainview_model_online.dart';
import '../view_model/mainview_viewmodel.dart';
import '../view_model/mainview_viewmodel_online.dart';

class MainView extends StatefulWidget {
  String title;
  MainView(this.title, {super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _counter = 0;
  List<GraphQLModel> _graphQLList = [];

  void _incrementCounter() {
    final viewModel = Provider.of<PersonViewModel>(context, listen: false);
    viewModel.increment(Counter(counter: _counter++));
  }

  void _getRepositories() async {
    final viewModel = Provider.of<ServerViewModel>(context, listen: false);
    viewModel.getRepositories();
    _graphQLList = viewModel.graphQLList;
    _graphQLList.forEach((value) {
      print("Name come from GRAPHQL: ${value.name}");
    });
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
            Consumer<ServerViewModel>(
              builder: (context, viewModel, _) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.graphQLList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(viewModel.graphQLList[index].name),
                        subtitle: Text('ID: ${viewModel.graphQLList[index].id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getRepositories,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
