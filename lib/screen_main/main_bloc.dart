import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';

const LOG_TAG = "UPA -> ";
const STREAM_LOW_URL = "http://78.155.222.238:8010/souz_radio_64.mp3";
const STREAM_MED_URL = "http://78.155.222.238:8010/souz_radio_128.mp3";
const STREAM_HIGH_URL = "http://78.155.222.238:8010/souz_radio_192.mp3";

class MainBloc extends Bloc<MainEvent, MainState> {
  final AudioPlayer _player = AudioPlayer();
  String _currentUrl = "";
  final Logger _logger = Logger();

  MainBloc()
      : super(MainState("Pausing", "Initialising", Icons.play_arrow_rounded)) {
    Timer.periodic(Duration(seconds: 2), (Timer t) => _checkForBufferLoading());
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    _currentUrl = STREAM_LOW_URL;

    _player.playerStateStream.listen((playerState) {
      switch (playerState.processingState) {
        case ProcessingState.idle:
          add(PlayerStateChangedToIdle(playerState.playing));
          break;
        case ProcessingState.loading:
          add(PlayerStateChangedToLoading(playerState.playing));
          break;
        case ProcessingState.buffering:
          add(PlayerStateChangedToBuffering(playerState.playing));
          break;
        case ProcessingState.ready:
          add(PlayerStateChangedToReady(playerState.playing));
          break;
        case ProcessingState.completed:
          add(PlayerStateChangedToCompleted(playerState.playing));
          break;
      }
    });

    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      _showError("A stream error occurred", e);
      _waitForConnection();
    });

    _waitForConnection();
  }
  Future<void> _checkForBufferLoading() async {
    //TODO:теоретически эт работает, нужно только добавить проверку на воспроизведение поскольку после переключения каналов плеер перестаёт подгружать в буффер данные во время паузы и заполненность буффера всегда равна нулю
    if(await internetConnectionCheck()){
      if(_player.bufferedPosition.inSeconds - _player.position.inSeconds>15){
        switch (_currentUrl) {
          case STREAM_LOW_URL:
            _currentUrl = STREAM_MED_URL;
            _log(_player.bufferedPosition.inSeconds.toString());
            _log(_player.position.inSeconds.toString());
            _log("Stream is now in medium bitrate");
            _waitForConnection();
            break;
          case STREAM_MED_URL:
            _currentUrl = STREAM_HIGH_URL;
            _log(_player.bufferedPosition.inSeconds.toString());
            _log(_player.position.inSeconds.toString());
            _log("Stream is now in high bitrate");
            _waitForConnection();
            break;
        }
      }
      else if(_player.bufferedPosition.inSeconds - _player.position.inSeconds<2){
        switch (_currentUrl) {
        case STREAM_HIGH_URL:
          _currentUrl = STREAM_MED_URL;
          _log(_player.bufferedPosition.inSeconds.toString());
          _log(_player.position.inSeconds.toString());
          _log("Stream is now in medium bitrate");
          _waitForConnection();
          break;
        case STREAM_MED_URL:
          _currentUrl = STREAM_LOW_URL;
          _log(_player.bufferedPosition.inSeconds.toString());
          _log(_player.position.inSeconds.toString());
          _log("Stream is now in low bitrate");
          _waitForConnection();
          break;
      }

      }
    }
  }

  Future<void> _waitForConnection() async {
    try {
      //TODO: хотя ты и делаешь проверку асинхронно, но в случае false после проверки ты обратно вылетаешь на проверку.
      //TODO: по-хорошему, нужно давать ресурсам какое то время и на иные задачи
      //TODO: поэтому лучше добавить какой то тайм-аут между проверками. Допустим, 1 сек.
      //while(await check() == false) {}

      while (await internetConnectionCheck() == false) {
        Future.delayed(Duration(seconds: 1));
      }

      final _newSource = AudioSource.uri(Uri.parse(_currentUrl));
      await _player.setAudioSource(_newSource);
    } catch (e) {
      _showError("Stream load error happens", e);
      //TODO: в случае, если открытие потока будет генерировать ошибку (допустим, если поток прекратил свое существование по какой то причина)
      //TODO: ты влетишь в бесконечный цикл, т.к. _waitForConnection() будет все время вызывать саму себя.
      //TODO: так делать, конечно же, нельзя
      await _waitForConnection();
    }
  }

  //TODO: лучше давать более осмысленные именования функциям. Если просто check() - непонятно, что именно проверяется.
  Future<bool> internetConnectionCheck() async {
    //TODO: лучше использовать final
    //var connectivityResult = await (Connectivity().checkConnectivity());
    final connectivityResult = await (Connectivity().checkConnectivity());

    //TODO: так код будет нагляднее
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');

      //TODO: в данном случае, можно написать компактнее
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //   return true;
      // }
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is PlayPauseFabPressed) {
      yield* _mapPlayPauseFabPressedToState();
      return;
    }
    /* TODO:
    * К сожалению, такая логика не применима. У тебя получается, что если плеер перешел в состоние буферизации,
    * то он будет переключен на поток меньшего битрейда. Но это не совсем правильно.
    * В буфферизации нет ничего плохого. В реальных условиях соединение может "подтормаживать"
    * по самым разным причинам. И если это явление кратковременное, то внутренний буфер
    * не даст радиостанции замолчать. И если подкачка пройдет нормально, то нет причины
    * переключать плеер на меньшее качество.
    * В идеале логика должна быть чуть более изощренной.
    * Например, мы устанавливаем какой то уровень "заполняемости" буфера. Ну, допустим, 30%.
    * Задаем это значение констартой или, впоследствии, в настройках.
    * Мы должны постоянно контролировать процент заполения буфера. Допустим, 1 раз в секунду.
    * Если заполнение буфера меньше 30% - переключамся на меньший поток.
    * Если выше 30% - то на больший.
    * В итоге мы должны контролировать не изменение статуса плеера, а состояние буффера.
    * Попробуй поискать такую возможность
    * */
    if (event is PlayerStateChangedToBuffering) { 
      yield* _mapPlayerStateChangedBufferingToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToCompleted) {
      yield* _mapPlayerStateChangedCompletedToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToIdle) {
      yield* _mapPlayerStateChangedIdleToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToLoading) {
      yield* _mapPlayerStateChangedLoadingToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToReady) {
      yield* _mapPlayerStateChangedReadyToState(event.isPlaying);
      return;
    }
    _log("Unknown event may be from user, may be from player");
  }

  Stream<MainState> _mapPlayPauseFabPressedToState() async* {
    String stateStr01 = state.stateStr01;
    IconData iconData = state.iconData;

    if (_player.processingState == ProcessingState.ready) {
      stateStr01 = _createStateStr01(!_player.playing);
      iconData = _createIconData(!_player.playing);
      _setPlayerMode(!_player.playing);
    }

    yield MainState(stateStr01, state.stateStr02, iconData);
  }

  Stream<MainState> _mapPlayerStateChangedBufferingToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Buffering", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedCompletedToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Completed", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedLoadingToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Loading", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedIdleToState(bool isPlaying) async* {
    yield MainState(state.stateStr01, "Idle", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedReadyToState(bool isPlaying) async* {
    yield MainState(state.stateStr01, "Ready", _createIconData(isPlaying));
  }

  void _setPlayerMode(bool isPlaying) =>
      isPlaying ? _player.play() : _player.pause();

  String _createStateStr01(bool isPlaying) => isPlaying ? "Playing" : "Pausing";

  IconData _createIconData(bool isPlaying) =>
      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded;

  //TODO: нужно понять, вызывается ли этот метод автоматом,
  //TODO: или нужно сделать вызов явно
  @override
  Future<void> close() async {
    _player.dispose();
    super.close();
  }

  //TODO: нужно сделать отображение ошибок на экране
  void _showError(String msg, Object error) {
    _log("$msg: $error");
  }

  void _log(String msg) => _logger.d("$LOG_TAG $msg");
}
