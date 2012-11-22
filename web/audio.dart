import 'dart:html';
import 'package:audio/simple_audio.dart';

AudioManager audioManager = new AudioManager();
AudioSound loopingSound = null;
String sourceName = 'Page';

String baseURL = 'http://127.0.0.1:3030/Users/johnmccutchan/workspace/simpleaudio/clips';
String clipName = 'Wilhelm';
String clipURL = '$baseURL/wilhelm.ogg';
String musicClipName = 'Deeper';
String musicClipURL = '$baseURL/deeper.ogg';

void main() {
  audioManager.makeClip(clipName);
  audioManager.makeClip(musicClipName);
  audioManager.findClip(clipName).loadFrom(clipURL);
  audioManager.findClip(musicClipName).loadFrom(musicClipURL);
  audioManager.makeSource(sourceName);

  query("#play_once")
    ..on.click.add(playOnce);
  query("#loop_start")
    ..on.click.add(startLoop);
  query("#loop_stop")
    ..on.click.add(stopLoop);
  query("#loop_pause")
    ..on.click.add(pauseLoop);

  query("#music_play")
    ..on.click.add(startMusic);
  query("#music_stop")
    ..on.click.add(stopMusic);
  query("#music_pause")
    ..on.click.add(pauseMusic);

  {
    InputElement ie;
    ie = query("#masterVolume");
    ie.on.change.add((e) => adjustVolume("master", ie));
  }
  {
    InputElement ie;
    ie = query("#musicVolume");
    ie.on.change.add((e) => adjustVolume("music", ie));
  }
  {
    InputElement ie;
    ie = query("#sourceVolume");
    ie.on.change.add((e) => adjustVolume("source", ie));
  }
}

void playOnce(Event event) {
  audioManager.playClipFromSource(sourceName, clipName);
}

void startLoop(Event event) {
  if (audioManager.findSource(sourceName).isPaused) {
   audioManager.findSource(sourceName).resume();
   print('resume');
  } else {
    loopingSound = audioManager.playClipFromSource(sourceName, clipName, true);
  }
}

void stopLoop(Event event) {
  loopingSound.stop();
}

void pauseLoop(Event event) {
  audioManager.pauseSource(sourceName);
}

void startMusic(Event event) {
  if (audioManager.music.paused) {
    audioManager.music.resume();
  } else {
    audioManager.music.play(audioManager.findClip(musicClipName));
  }

}

void stopMusic(Event event) {
  audioManager.music.stop();
}

void pauseMusic(Event event) {
  audioManager.music.pause();
}

void adjustVolume(String volume, InputElement el) {
  num val = el.valueAsNumber;
  if (volume == "master") {
    audioManager.masterVolume = val;
  } else if (volume == "music") {
    audioManager.musicVolume = val;
  } else if (volume == "source") {
    audioManager.sourceVolume = val;
  }
  print('$volume -> $val');
}