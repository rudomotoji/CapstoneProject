import 'dart:math';

class ConvertUtils {
  ConvertUtils();

  var ChuSo = [
    " không ",
    " một ",
    " hai ",
    " ba ",
    " bốn ",
    " năm ",
    " sáu ",
    " bảy ",
    " tám ",
    " chín "
  ];
  var Tien = ["", " nghìn", " triệu", " tỷ", " nghìn tỷ", " triệu tỷ"];

  String num2Word2(dynamic soTien) {
    var lan = 0;
    var i = 0;
    var so = 0;
    var KetQua = "";
    var tmp = "";
    var ViTri = List();
    if (int.parse(soTien) < 0) return "Số tiền âm !";
    if (int.parse(soTien) == 0) return "Không đồng !";
    if (int.parse(soTien) > 0) {
      so = int.parse(soTien);
    } else {
      so = -int.parse(soTien);
    }
    if (soTien > 8999999999999999) {
      //soTien = 0;
      return "Số quá lớn!";
    }
    ViTri[5] = (so / 1000000000000000).floor();
    if ((ViTri[5]).isNaN) ViTri[5] = "0";
    so = so - int.parse(ViTri[5].toString()) * 1000000000000000;
    ViTri[4] = (so / 1000000000000).floor();
    if ((ViTri[4]).isNaN) ViTri[4] = "0";
    so = so - int.parse(ViTri[4].toString()) * 1000000000000;
    ViTri[3] = (so / 1000000000).floor();
    if ((ViTri[3]).isNaN) ViTri[3] = "0";
    so = so - int.parse(ViTri[3].toString()) * 1000000000;
    ViTri[2] = (so / 1000000).floor();
    if ((ViTri[2]).isNaN) ViTri[2] = "0";
    ViTri[1] = ((so % 1000000) / 1000).floor();
    if ((ViTri[1]).isNaN) ViTri[1] = "0";
    ViTri[0] = (so % 1000).floor();
    if ((ViTri[0]).isNaN) ViTri[0] = "0";
    if (ViTri[5] > 0) {
      lan = 5;
    } else if (ViTri[4] > 0) {
      lan = 4;
    } else if (ViTri[3] > 0) {
      lan = 3;
    } else if (ViTri[2] > 0) {
      lan = 2;
    } else if (ViTri[1] > 0) {
      lan = 1;
    } else {
      lan = 0;
    }
    for (i = lan; i >= 0; i--) {
      tmp = _docSo3ChuSo(ViTri[i]);
      KetQua += tmp;
      if (ViTri[i] > 0) KetQua += Tien[i];
      if ((i > 0) && (tmp.length > 0))
        KetQua += ','; //&& (!string.IsNullOrEmpty(tmp))
    }
    if (KetQua.substring(KetQua.length - 1) == ',') {
      KetQua = KetQua.substring(0, KetQua.length - 1);
    }
    KetQua = KetQua.substring(1, 2).toUpperCase() + KetQua.substring(2);
    return KetQua; //.substring(0, 1);//.toUpperCase();// + KetQua.substring(1);
  }

  //Hàm đọc số có ba chữ số;
  _docSo3ChuSo(baso) {
    var tram;
    var chuc;
    var donvi;
    var KetQua = "";
    tram = int.parse(baso / 100);
    chuc = int.parse((baso % 100) / 10);
    donvi = baso % 10;
    if (tram == 0 && chuc == 0 && donvi == 0) return "";
    if (tram != 0) {
      KetQua += ChuSo[tram] + " trăm ";
      if ((chuc == 0) && (donvi != 0)) KetQua += " linh ";
    }
    if ((chuc != 0) && (chuc != 1)) {
      KetQua += ChuSo[chuc] + " mươi";
      if ((chuc == 0) && (donvi != 0)) KetQua = KetQua + " linh ";
    }
    if (chuc == 1) KetQua += " mười ";
    switch (donvi) {
      case 1:
        if ((chuc != 0) && (chuc != 1)) {
          KetQua += " mốt ";
        } else {
          KetQua += ChuSo[donvi];
        }
        break;
      case 5:
        if (chuc == 0) {
          KetQua += ChuSo[donvi];
        } else {
          KetQua += " lăm ";
        }
        break;
      default:
        if (donvi != 0) {
          KetQua += ChuSo[donvi];
        }
        break;
    }
    return KetQua;
  }

  // String convertPriceToText(String price) {
  //   String s = price;
  //   List<String> so = [
  //     "không",
  //     "một",
  //     "hai",
  //     "ba",
  //     "bốn",
  //     "năm",
  //     "sáu",
  //     "bảy",
  //     "tám",
  //     "chín"
  //   ];
  //   List<String> hang = ["", "nghìn", "triệu", "tỷ"];
  //   int i, j, donvi, chuc, tram;
  //   String str = " ";
  //   bool booAm = false;
  //   int decS = 0;

  //   try {
  //     decS = int.parse(s.toString());
  //   } catch (e) {
  //     print('ERROR IN CONVERT PRICE TO TEXT: $e');
  //   }

  //   if (decS < 0) {
  //     decS = -decS;
  //     s = decS.toString();
  //     booAm = true;
  //   }

  //   i = s.length;
  //   if (i == 0) {
  //     str = so[0] + str;
  //   } else {
  //     j = 0;
  //     while (i > 0) {
  //       donvi = int.parse(s.substring(i - 1, 1));
  //       i--;
  //       if (i > 0)
  //         chuc = int.parse(s.substring(i - 1, 1));
  //       else
  //         chuc = -1;

  //       i--;

  //       if (i > 0)
  //         tram = int.parse(s.substring(i - 1, 1));
  //       else
  //         tram = -1;

  //       i--;

  //       if ((donvi > 0) || (chuc > 0) || (tram > 0) || (j == 3)) {
  //         str = hang[j] + str;
  //       }
  //       j++;
  //       if (j > 3) j = 1;
  //       if ((donvi == 1) && (chuc > 1))
  //         str = "một " + str;
  //       else {
  //         if ((donvi == 5) && (chuc > 0))
  //           str = "lăm " + str;
  //         else if (donvi > 0) str = so[donvi] + " " + str;
  //       }

  //       if (chuc < 0)
  //         break;
  //       else {
  //         if ((chuc == 0) && (donvi > 0)) str = "lẻ " + str;
  //         if (chuc == 1) str = "mười " + str;
  //         if (chuc > 1) str = so[chuc] + " mươi " + str;
  //       }

  //       if (tram < 0)
  //         break;
  //       else {
  //         if ((tram > 0) || (chuc > 0) || (donvi > 0))
  //           str = so[tram] + " trăm " + str;
  //       }
  //       str = " " + str;
  //     }
  //   }
  //   if (booAm) str = "Âm " + str;
  //   return str + "đồng chẵn";
  // }
}
