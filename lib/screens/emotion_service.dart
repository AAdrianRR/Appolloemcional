class EmotionService {
  static bool isUserSad = false;
  static double currentSmileProb = 0.0;

  static void updateEmotion(double smileProb) {
    currentSmileProb = smileProb;
    if (smileProb < 0.15) {
      isUserSad = true;
    } else {
      isUserSad = false;
    }
  }
}
