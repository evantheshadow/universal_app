abstract class NetworkingEvent {}

class FirstScreenEvent extends NetworkingEvent {
  FirstScreenEvent();
}

class GetInputWordEvent extends NetworkingEvent {
  final String inputWord;

  GetInputWordEvent(this.inputWord);
}
