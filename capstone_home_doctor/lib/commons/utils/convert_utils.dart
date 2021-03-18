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
    var ViTri = [0, 0, 0, 0, 0, 0];
    if (int.parse(soTien) < 0) return "Số tiền âm !";
    if (int.parse(soTien) == 0) return "Không đồng !";
    if (int.parse(soTien) > 0) {
      so = int.parse(soTien);
    } else {
      so = -int.parse(soTien);
    }
    if (so > 8999999999999999) {
      //soTien = 0;
      return "Số quá lớn!";
    }

    ViTri[5] = (so / 1000000000000000).floor();
    if ((ViTri[5]).isNaN) ViTri[5] = 0;
    so = so - ViTri[5] * 1000000000000000;
    ViTri[4] = (so / 1000000000000).floor();
    if ((ViTri[4]).isNaN) ViTri[4] = 0;
    so = so - int.parse(ViTri[4].toString()) * 1000000000000;
    ViTri[3] = (so / 1000000000).floor();
    if ((ViTri[3]).isNaN) ViTri[3] = 0;
    so = so - int.parse(ViTri[3].toString()) * 1000000000;
    ViTri[2] = (so / 1000000).floor();
    if ((ViTri[2]).isNaN) ViTri[2] = 0;
    ViTri[1] = ((so % 1000000) / 1000).floor();
    if ((ViTri[1]).isNaN) ViTri[1] = 0;
    ViTri[0] = (so % 1000).floor();
    if ((ViTri[0]).isNaN) ViTri[0] = 0;
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
    return KetQua +
        'đồng'; //.substring(0, 1);//.toUpperCase();// + KetQua.substring(1);
  }

  //Hàm đọc số có ba chữ số;
  _docSo3ChuSo(int baso) {
    var tram;
    var chuc;
    var donvi;
    var KetQua = "";
    tram = (baso / 100).floor();
    chuc = ((baso % 100) / 10).floor();
    donvi = (baso % 10).floor();
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
}
