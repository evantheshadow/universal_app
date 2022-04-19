import 'package:bloc/bloc.dart';
import 'package:new_calc/screens/5_networking/api/networking_model.dart';

import 'package:new_calc/screens/5_networking/api/networking_repository.dart';
import 'package:new_calc/screens/5_networking/networking_events.dart';
import 'package:new_calc/screens/5_networking/networking_states.dart';

class NetworkingBloc extends Bloc<NetworkingEvent, NetworkingState> {
  final NetworkingRepository _netRepository;

  NetworkingBloc(
        this._netRepository,
        initialState,
      ) : super(initialState);

  @override
  Stream<NetworkingState> mapEventToState(event) async* {
    print('NetworkingBloc event state type: ' + event.runtimeType.toString());
    switch (event.runtimeType) {
      case FirstScreenEvent:
        await for (var value in _goToMainScreen(event as FirstScreenEvent)) {
          yield value;
        }
        break;
      case GetInputWordEvent:
        await for (var value in _getInputWord(event as GetInputWordEvent)) {
          yield value;
        }
        break;
    }
  }

  Stream<NetworkingState> _goToMainScreen(FirstScreenEvent event) async* {
    yield LoadingState();
    await Future.delayed(const Duration(seconds: 5));
    yield DefaultState();
  }

  Stream<NetworkingState> _getInputWord(GetInputWordEvent event) async* {
    yield LoadingState();
    final response = await _netRepository.getWordLink(event.inputWord);
    print('Response: $response');
    if (response.isSuccessful) {
      yield SuccessState(response.data);
    } else {
      const message = 'Произошла ошибка!';
      yield ErrorState(message);
    }
    }
  }