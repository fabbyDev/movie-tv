import 'package:flutter/foundation.dart';

abstract class StateNotifier<State> extends ChangeNotifier {
  State _state;
  State _oldState;

  StateNotifier(this._state) : _oldState = _state;

  bool _mounted = true;
  State get state => _state;
  State get oldState => _oldState;
  get mounted => _mounted;

  set state(State newState) => _update(newState);

  void _update(State newState, {bool notify = true}) {
    if (_state != newState) {
      _oldState = _state;
      _state = newState;
      if (notify) {
        notifyListeners();
      }
    }
  }

  void onlyUpdate(State newState) {
    _update(newState, notify: false);
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
