class Zodiac {
  String? getZodiac( String date) {
    var birth = DateTime.tryParse(date);
    var day = birth!.day;
    var month = birth.month;
    if (month == 3) {
      if (day >= 21) {
        return "Aries";
      } else {
        return "Pisces";
      }
    } else if (month == 4) {
      if (day <= 19) {
        return "Aries";
      } else {
        return "Taurus";
      }
    } else if (month == 5) {
      if (day <= 20) {
        return "Taurus";
      } else {
        return "Gemini";
      }
    } else if (month == 6) {
      if (day <= 21) {
        return "Gemini";
      } else {
        return "Cancer";
      }
    } else if (month == 7) {
      if (day <= 22) {
        return "Cancer";
      } else {
        return "Leo";
      }
    } else if (month == 8) {
      if (day <= 22) {
        return "Leo";
      } else {
        return "Virgo";
      }
    } else if (month == 9) {
      if (day <= 22) {
        return "Virgo";
      } else {
        return "Libra";
      }
    } else if (month == 10) {
      if (day <= 23) {
        return "Libra";
      } else {
        return "Scorpio";
      }
    } else if (month == 11) {
      if (day <= 21) {
        return "Scorpio";
      } else {
        return "Sagittarius";
      }
    } else if (month == 12) {
      if (day <= 21) {
        return "Sagittarius";
      } else {
        return "Capricorn";
      }
    } else if (month == 1) {
      if (day <= 19) {
        return "Capricorn";
      } else {
        return "Aquarius";
      }
    } else if (month == 2) {
      if (day <= 18) {
        return "Aquarius";
      } else {
        return "Pisces";
      }
    } else {
      return "";
    }
  }
}
