import 'en.dart';
import 'hi.dart';

class AppLocalizations {

  static String language = "English";

  static String text(String key){

    if(language=="Hindi"){

      return hi[key] ?? key;

    }

    return en[key] ?? key;

  }

}