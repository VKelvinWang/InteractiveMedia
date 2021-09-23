void sound() {
  Envelope rate = new Envelope(ac, 1);
  samplePlayers.get("LeftClickSound").setRate(rate);
  //rate.addSegment(1.5, 200);

  Panner p = new Panner(ac, 0);
  Gain g = new Gain(ac, 2, 0.1);

  p.addInput(samplePlayers.get("LeftClickSound"));
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}
