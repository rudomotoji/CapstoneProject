import 'package:capstone_home_doctor/models/image_scanner_dto.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class TesseractOCRUtil {
  Future<String> convertImgToString(String path) async {
    var _extractText = await TesseractOcr.extractText(path, language: 'vie');

    // var newArrData = _extractText.split("\n");
    // var str_list = newArrData.where((s) => !s.isEmpty).toList();

    // String strSymptom = "";
    // String title = "";

    // for (var itemString in str_list) {
    //   if (itemString.contains('PHIẾU')) {
    //     title += itemString;
    //   } else if (itemString.contains('BỆNH ÁN')) {
    //     title = itemString;
    //   }
    //   if (title != "") {
    //     if (strSymptom.contains('Triệu')) {
    //       if (itemString.contains(' - ')) {
    //         strSymptom += itemString;
    //       } else if (itemString.contains('(')) {
    //         strSymptom += itemString;
    //       }
    //     }
    //     if (itemString.contains('Triệu ')) {
    //       strSymptom += itemString;
    //     }
    //   }
    // }

    return _extractText;
  }
}
