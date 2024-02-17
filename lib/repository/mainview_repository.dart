import '../model/mainview_model.dart';

abstract class MainViewRepositoryApi {
  factory MainViewRepositoryApi() = _MainViewRepositoryImpl;
  String returningAnInt(Counter count);
}

class _MainViewRepositoryImpl implements MainViewRepositoryApi {
  @override
  String returningAnInt(Counter count) => 'Total price: ${count.counter}';
}