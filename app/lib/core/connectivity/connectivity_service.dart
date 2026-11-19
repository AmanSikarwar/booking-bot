import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import '../../features/chat/data/chat_api.dart';

@lazySingleton
class ConnectivityService {
  ConnectivityService(this._api) : _connectivity = Connectivity();

  final ChatApi _api;
  final Connectivity _connectivity;
  final _online = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _retry;
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  Stream<bool> get changes => _online.stream;

  Future<void> start() async {
    _sub = _connectivity.onConnectivityChanged.listen(_onInterfaces);
    await _onInterfaces(await _connectivity.checkConnectivity());
  }

  Future<void> recheck() => _onInterfaces(const [ConnectivityResult.other]);

  Future<void> _onInterfaces(List<ConnectivityResult> results) async {
    final hasInterface = results.any((r) => r != ConnectivityResult.none);
    _set(hasInterface && await _api.ping());
  }

  void _set(bool online) {
    _retry?.cancel();
    if (!online) _retry = Timer(const Duration(seconds: 15), recheck);
    if (online == _isOnline) return;
    _isOnline = online;
    _online.add(online);
  }

  @disposeMethod
  Future<void> dispose() async {
    _retry?.cancel();
    await _sub?.cancel();
    await _online.close();
  }
}
