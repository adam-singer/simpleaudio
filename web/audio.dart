import 'dart:html';
import 'package:audio/simple_audio.dart';

AudioManager audioManager = new AudioManager();
AudioSound loopingSound = null;
String sourceName = 'Page';

String baseURL = null; // Automatically set.
String clipName = 'Wilhelm';
String clipURL = 'clips/wilhelm.ogg';
String musicClipName = 'Deeper';
String musicClipURL = 'clips/deeper.ogg';

void setBaseURL() {
  String location = window.location.href;
  location = location.substring(0, location.length-"audio.html".length);
  baseURL = location;
}

String urlFor(String clip) {
  return '$baseURL/$clip';
}

void main() {
  setBaseURL();
  audioManager.makeClip(clipName);
  audioManager.makeClip(musicClipName);
  audioManager.findClip(clipName).loadFrom(urlFor(clipURL));
  audioManager.findClip(musicClipName).loadFrom(urlFor(musicClipURL));
  audioManager.makeSource(sourceName);

  query("#clip_once")
    ..on.click.add(playOnce);
  query("#clip_once_delay")
  ..on.click.add(playOnceDelay);
  query("#clip_loop_start")
    ..on.click.add(startLoop);
  query("#clip_loop_stop")
    ..on.click.add(stopLoop);
  query("#pause_sources")
    ..on.click.add(pauseLoop);
  query("#pause_all")
    ..on.click.add(pauseAll);

  query("#music_play")
    ..on.click.add(startMusic);
  query("#music_stop")
    ..on.click.add(stopMusic);
  query("#pause_music")
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
  {
    InputElement ie;
    ie = query("#positionX");
    ie.on.change.add((e) => adjustPosition("x", "position", ie));
  }
  {
    InputElement ie;
    ie = query("#positionY");
    ie.on.change.add((e) => adjustPosition("y", "position", ie));
  }
  {
    InputElement ie;
    ie = query("#positionZ");
    ie.on.change.add((e) => adjustPosition("z", "position", ie));
  }
  {
    InputElement ie;
    ie = query("#orientationX");
    ie.on.change.add((e) => adjustPosition("x", "orientation", ie));
  }
  {
    InputElement ie;
    ie = query("#orientationY");
    ie.on.change.add((e) => adjustPosition("y", "orientation", ie));
  }
  {
    InputElement ie;
    ie = query("#orientationZ");
    ie.on.change.add((e) => adjustPosition("z", "orientation", ie));
  }
  {
    InputElement ie;
    ie = query("#velocityX");
    ie.on.change.add((e) => adjustPosition("x", "velocity", ie));
  }
  {
    InputElement ie;
    ie = query("#velocityY");
    ie.on.change.add((e) => adjustPosition("y", "velocity", ie));
  }
  {
    InputElement ie;
    ie = query("#velocityZ");
    ie.on.change.add((e) => adjustPosition("z", "velocity", ie));
  }
  
  query("#mute")
    ..on.click.add(muteEverything);
}

void playOnce(Event event) {
  audioManager.playClipFromSourceIn(0.0, sourceName, clipName);
}

void playOnceDelay(Event event) {
  audioManager.playClipFromSourceIn(2.0, sourceName, clipName);
}

void startLoop(Event event) {
  if (loopingSound != null) {
    loopingSound.stop();
  }
  loopingSound = audioManager.playClipFromSource(sourceName, clipName, true);
}

void stopLoop(Event event) {
  loopingSound.stop();
}

void pauseLoop(Event event) {
  audioManager.findSource(sourceName).pause = !audioManager.findSource(sourceName).pause;
}

void startMusic(Event event) {
  audioManager.music.play(audioManager.findClip(musicClipName));
}

bool _allPaused = false;
void pauseAll(Event event) {
  if (_allPaused) {
    audioManager.resumeAll();
    _allPaused = false;
  } else {
    audioManager.pauseAll();
    _allPaused = true;
  }
}

void stopMusic(Event event) {
  audioManager.music.stop();
}

void pauseMusic(Event event) {
  audioManager.music.pause = !audioManager.music.pause;
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

void adjustPosition(String axis, String control, InputElement el) {
  num val = el.valueAsNumber;
  num x,y,z;
  switch (axis) {
    case "x":
      x = val;
      y = query("#${control}Y").valueAsNumber;
      z = query("#${control}Z").valueAsNumber;
      break;
    case "y":
      y = val;
      x = query("#${control}X").valueAsNumber;
      z = query("#${control}Z").valueAsNumber;
      break;
    case "z":
      z = val;
      x = query("#${control}X").valueAsNumber;
      y = query("#${control}Y").valueAsNumber;
      break;
  }
  
  switch (control) {
    case "position":
      audioManager.setPosition(x, y, z);
      break;
    case "orientation":
      audioManager.setOrientation(x, y, z, 
          query("#${control}Xup").valueAsNumber, 
          query("#${control}Yup").valueAsNumber, 
          query("#${control}Zup").valueAsNumber);
      break;
    case "velocity":
      audioManager.setVelocity(x, y, z);
      break;
  }
  
}

void muteEverything(Event event) {
  audioManager.mute = !audioManager.mute;
}