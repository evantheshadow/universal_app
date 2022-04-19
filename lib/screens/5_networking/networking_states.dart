import 'package:equatable/equatable.dart';
import 'package:new_calc/screens/5_networking/api/networking_model.dart';

abstract class NetworkingState extends Equatable {}

class DefaultState extends NetworkingState {
  @override
  List<Object> get props => [];
}

class LoadingState extends NetworkingState {
  @override
  List<Object> get props => [];
}

class SuccessState extends NetworkingState {
  final UrbanDictionaryCardResponse data;

  SuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class ErrorState extends NetworkingState {
  final String errorMessage;

  ErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}