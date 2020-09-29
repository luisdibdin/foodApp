class UserModel {
  String uid;
  String username;
  String avatarUrl;
  int totalQuestions;
  int score;
  int weekTotal;
  int weekScore;

  UserModel({this.uid, this.username, this.avatarUrl, this.totalQuestions, this.score, this.weekTotal, this.weekScore});

  String calculateExpertiseTitle() {
    if (score == null) {
      return 'Naive';
    }
    if (score > 1000) {
      return (calculateAccuracy() + ' Master');
    }
    if (score > 500) {
      return (calculateAccuracy() + ' Expert');
    }
    if (score > 200) {
      return (calculateAccuracy() + ' Journeyman');
    }
    if (score > 100) {
      return (calculateAccuracy() + ' Apprentice');
    }
    if (score > 50) {
      return (calculateAccuracy() + ' Initiate');
    }
    if (score > 15) {
      return (calculateAccuracy() + ' Novice');
    }
    return 'Naive';
  }

  String calculateAccuracy() {
    double percentAccuracy = score/totalQuestions;

    if (percentAccuracy > 0.25 && percentAccuracy < 0.5) {
      return 'Improving';
    }
    if (percentAccuracy >= 0.50 && percentAccuracy < 0.75) {
      return 'Proficient';
    }
    if (percentAccuracy >= 0.75 && percentAccuracy < 0.90) {
      return 'Exceptional';
    }
    if (percentAccuracy >= 0.90) {
      return 'Extraordinary';
    }
    return 'Learning';
  }
}