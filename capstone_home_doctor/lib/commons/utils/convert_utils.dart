class ConvertUtils {
  ConvertUtils();

  String convertPriceToText(String price) {
    String s = price;
    List<String> so = [
      "không",
      "một",
      "hai",
      "ba",
      "bốn",
      "năm",
      "sáu",
      "bảy",
      "tám",
      "chín"
    ];
    List<String> hang = ["", "nghìn", "triệu", "tỷ"];
    int i, j, donvi, chuc, tram;
    String str = " ";
    bool booAm = false;
    int decS = 0;

    try {
      decS = int.parse(s.toString());
    } catch (e) {
      print('ERROR IN CONVERT PRICE TO TEXT: $e');
    }

    if (decS < 0) {
      decS = -decS;
      s = decS.toString();
      booAm = true;
    }

    i = s.length;
    if (i == 0) {
      str = so[0] + str;
    } else {
      j = 0;
      while (i > 0) {
        print(s);
        print('===================');
        print(s.substring(i - 1));
        donvi = int.parse(s.substring(i - 1, 1));
        i--;
        if (i > 0)
          chuc = int.parse(s.substring(i - 1, 1));
        else
          chuc = -1;

        i--;

        if (i > 0)
          tram = int.parse(s.substring(i - 1, 1));
        else
          tram = -1;

        i--;

        if ((donvi > 0) || (chuc > 0) || (tram > 0) || (j == 3)) {
          str = hang[j] + str;
        }
        j++;
        if (j > 3) j = 1;
        if ((donvi == 1) && (chuc > 1))
          str = "một " + str;
        else {
          if ((donvi == 5) && (chuc > 0))
            str = "lăm " + str;
          else if (donvi > 0) str = so[donvi] + " " + str;
        }

        if (chuc < 0)
          break;
        else {
          if ((chuc == 0) && (donvi > 0)) str = "lẻ " + str;
          if (chuc == 1) str = "mười " + str;
          if (chuc > 1) str = so[chuc] + " mươi " + str;
        }

        if (tram < 0)
          break;
        else {
          if ((tram > 0) || (chuc > 0) || (donvi > 0))
            str = so[tram] + " trăm " + str;
        }
        str = " " + str;
      }
    }
    if (booAm) str = "Âm " + str;
    return str + "đồng chẵn";
  }
}
