import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/mainview_model_online.dart';
import '../view_model/mainview_viewmodel_online.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class MainView extends ConsumerWidget {
  final response = FutureProvider((ref) async => ref.watch(apiServiceProvider).getRepositories());
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;

  @override
  Widget build(BuildContext context, WidgetRef viewModel) {
    final responseProvider = viewModel.watch(response);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Practice"),
      ),
      body: SwipeRefresh.material(
        stateStream: _stream,
        onRefresh: () => _refreshData(viewModel),
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Text(
                  'List of items:',
                ),
                responseProvider.when(
                  error: ((error, stackTrace) => Text(error.toString())),
                  loading: () => const CircularProgressIndicator(),
                  data: (data) => Container(
                    child: Column(
                      children: [
                        data.isNotEmpty
                            ? ListInfo(data)
                            : const Text('No hay información'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.sink.add(SwipeRefreshState.hidden);
          viewModel.refresh(apiServiceProvider).getRepositories();
        },
        child: responseProvider.when(
            data: (_) => const Icon(Icons.add),
            error: ((error, _) => const Icon(Icons.refresh)),
            loading: () => const CircularProgressIndicator()),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _refreshData(WidgetRef viewModel) async {
    viewModel.refresh(apiServiceProvider).getRepositories();
    _controller.sink.add(SwipeRefreshState.hidden);
  }
}

class ListInfo extends StatelessWidget {
  List<GraphQLModel> listChats;

  ListInfo(this.listChats, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 12) / 1.5;
    final double itemWidth = size.width / 0.25;

    return GridView.builder(
      padding: EdgeInsets.all(2),
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemCount: listChats.length,
      itemBuilder: (BuildContext context, int index) {
        return CardViewNotificaciones(index, listChats);
      },
    );
  }
}

class CardViewNotificaciones extends StatefulWidget {
  List<GraphQLModel> resultChats;
  int index;

  CardViewNotificaciones(this.index, this.resultChats, {Key? key}) : super(key: key);

  @override
  State<CardViewNotificaciones> createState() => _CardViewNotificaciones();
}

class _CardViewNotificaciones extends State<CardViewNotificaciones> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.resultChats[widget.index].title}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Text(
                        widget.resultChats[widget.index].id,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
