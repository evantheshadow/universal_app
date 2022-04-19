import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_calc/screens/5_networking/api/networking_repository.dart';
import 'package:new_calc/screens/5_networking/networking_bloc.dart';
import 'package:new_calc/screens/5_networking/networking_events.dart';
import 'package:new_calc/screens/5_networking/networking_states.dart';

class NetworkingScreen extends StatefulWidget {
  @override
  _NetworkingScreenState createState() => _NetworkingScreenState();
}

class _NetworkingScreenState extends State<NetworkingScreen> {
  TextEditingController _inputWordController = new TextEditingController();

  final NetworkingBloc _netBloc = NetworkingBloc(
    NetworkingRepository(),
    DefaultState(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Взаимодействие с API'),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder(
          bloc: _netBloc,
          builder: (BuildContext context, NetworkingState state) {
            print('Networking Screen state type: ' +
                state.runtimeType.toString());
            if (state is LoadingState) {
              return _buildLoadingContent(context, state);
            } else if (state is ErrorState) {
              return _buildErrorContent(context, state);
            } else if (state is DefaultState) {
              return _buildDefaultContent(context, state);
            } else if (state is SuccessState) {
              return _buildSuccessfulContent(context, state);
            }
            return Container();
          }),
    );
  }

  Widget _buildLoadingContent(BuildContext context, LoadingState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 8.0),
          Text("Загрузка данных..."),
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, ErrorState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 32.0),
          Text(
            state.errorMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          OutlineButton(
            child: const Text('Вернуться'),
            onPressed: () {
              _netBloc.add(FirstScreenEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context, DefaultState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Center(
            child: Image(
              width: 300,
              height: 80,
              image: AssetImage('assets/images/urbanDictionaryLogo.png'),
            ),
          ),
          SizedBox(
            width: 200.0,
            child: TextField(
              decoration:
                  const InputDecoration(labelText: 'Введите слово для поиска'),
              controller: _inputWordController,
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.yellow;
                  }
                  return Colors.black;
                }),
                textStyle: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return size 40, otherwise 20
                  if (states.contains(MaterialState.pressed)) {
                    return const TextStyle(color: Colors.black);
                  }
                  return const TextStyle(color: Colors.white);
                }),
              ),
              onPressed: () {
                _netBloc.add(GetInputWordEvent(_inputWordController.text));
              },
              child: const Text(
                'Найти',
              ))
        ],
      ),
    );
  }

  Widget _buildSuccessfulContent(BuildContext context, SuccessState state) {
    final urbanCards = state.data.posts;
    return (state.data.posts.isNotEmpty)
        ? ListView.builder(
            itemCount: urbanCards.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Text(
                        urbanCards[index].word!,
                        style: GoogleFonts.ptSerif(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 19, 79, 230),
                        ),
                      ),
                      // ),
                    ]),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            urbanCards[index].definition!,
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        urbanCards[index].example!,
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: <Widget>[
                      Text(
                        'by ',
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        urbanCards[index].author!,
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 19, 79, 230),
                        ),
                      ),
                    ]),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _convertNormalDate(urbanCards[index].createdOn!),
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButtonTheme(
                      data: ElevatedButtonThemeData(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 60))),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(255, 124, 255, 0);
                                }
                                return Colors.white;
                              }),
                              shape:
                                  MaterialStateProperty.resolveWith((states) {
                                return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                );
                              }),
                            ),
                            onPressed: () => setState(() {
                              print('Press Like!');
                            }),
                            child: _evaluationContent(
                              Icons.thumb_up_rounded,
                              urbanCards[index].likes!,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(255, 124, 255, 0);
                                }
                                return Colors.white;
                              }),
                              shape:
                                  MaterialStateProperty.resolveWith((states) {
                                return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                );
                              }),
                            ),
                            onPressed: () => setState(() {
                              print('Press Disike!');
                            }),
                            child: _evaluationContent(
                              Icons.thumb_down_rounded,
                              urbanCards[index].dislikes!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              );
            })
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '😔',
                  style: TextStyle(fontSize: 80.0),
                ),
                const SizedBox(height: 8.0),
                const Text('Увы, мы не нашли такого слова.',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        // If the button is pressed, return green, otherwise blue
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.yellow;
                        }
                        return Colors.black;
                      }),
                      textStyle: MaterialStateProperty.resolveWith((states) {
                        // If the button is pressed, return size 40, otherwise 20
                        if (states.contains(MaterialState.pressed)) {
                          return const TextStyle(color: Colors.black);
                        }
                        return const TextStyle(color: Colors.white);
                      }),
                    ),
                    onPressed: () {
                      _netBloc.add(FirstScreenEvent());
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                    )),
              ],
            ),
          );
  }

  Widget? _evaluationContent(IconData? currentIcon, int numOfEvals) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Icon(
            currentIcon,
            color: Colors.black,
          ),
          const SizedBox(width: 5), // give it width
          Text(numOfEvals.toString(),
              style: const TextStyle(
                color: Colors.black,
              )),
        ],
      ),
    );
  }

  String _convertNormalDate(String dateSource) {
    var dateValue =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(dateSource).toLocal();
    String formattedDate = DateFormat.yMMMMd('en_US').format(dateValue);
    return formattedDate;
  }

  @override
  void dispose() {
    _netBloc.close();
    super.dispose();
  }
}
