//Updates deltatime making timers frame independent.
void calculateDeltaTime() {
  long currentTime = millis();
  deltaTime = (currentTime - time) * 0.001f;
  time = currentTime;
}
