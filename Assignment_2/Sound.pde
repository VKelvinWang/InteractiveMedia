void sound() {
  samplePlayers.put("keyboardtypingsound", new SamplePlayer(ac, SampleManager.sample(sketchPath() + "/keyboardtypingsound.mp3")));
  Envelope rate = new Envelope(ac, 1);
  samplePlayers.get("keyboardtypingsound").setRate(rate);
  //rate.addSegment(1.5, 200);

  Panner p = new Panner(ac, 0);
  Gain g = new Gain(ac, 2, 0.1); //volume control between 0.0-1.0

  p.addInput(samplePlayers.get("keyboardtypingsound"));
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}
