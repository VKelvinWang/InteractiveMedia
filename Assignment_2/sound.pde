void sound() {
  String audioFilePath = sketchPath() + "/leftclicksound.wav";
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFilePath));
  
  Envelope rate = new Envelope(ac, 1);
  player.setRate(rate);
  //rate.addSegment(1.5, 200);

  Panner p = new Panner(ac, 0);
  Gain g = new Gain(ac, 2, 0.1);

  p.addInput(player);
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}
