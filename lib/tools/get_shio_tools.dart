class Shio {
  String? getShio(String date) {
    var birth = DateTime.tryParse(date);
    var year = birth!.year;
    if (year == 1960 ||
        year == 1972 ||
        year == 1984 ||
        year == 1996 ||
        year == 2008 ||
        year == 2020) {
      return "Rat";
    } else if (year == 1961 ||
        year == 1973 ||
        year == 1985 ||
        year == 1997 ||
        year == 2009 ||
        year == 2021) {
      return "Buffalo";
    } else if (year == 1962 ||
        year == 1974 ||
        year == 1986 ||
        year == 1998 ||
        year == 2010 ||
        year == 2022) {
      return "Tiger";
    } else if (year == 1963 ||
        year == 1975 ||
        year == 1987 ||
        year == 1999 ||
        year == 2011 ||
        year == 2023) {
      return "Rabbit";
    } else if (year == 1964 ||
        year == 1976 ||
        year == 1988 ||
        year == 2000 ||
        year == 2012) {
      return "Dragon";
    } else if (year == 1965 ||
        year == 1977 ||
        year == 1989 ||
        year == 2001 ||
        year == 2013) {
      return "Snake";
    } else if (year == 1966 ||
        year == 1978 ||
        year == 1990 ||
        year == 2002 ||
        year == 2014) {
      return "Horse";
    } else if (year == 1967 ||
        year == 1979 ||
        year == 1991 ||
        year == 2003 ||
        year == 2015) {
      return "Goat";
    } else if (year == 1968 ||
        year == 1980 ||
        year == 1992 ||
        year == 2004 ||
        year == 2016) {
      return "Monkey";
    } else if (year == 1969 ||
        year == 1981 ||
        year == 1993 ||
        year == 2005 ||
        year == 2017) {
      return "Chicken";
    } else if (year == 1970 ||
        year == 1982 ||
        year == 1994 ||
        year == 2006 ||
        year == 2018) {
      return "Dog";
    } else if (year == 1971 ||
        year == 1983 ||
        year == 1995 ||
        year == 2007 ||
        year == 2019) {
      return "Pig";
    } else {
      return "";
    }
  }
}
