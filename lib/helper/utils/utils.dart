import 'package:excel/excel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webui/app_constant.dart';
import 'package:webui/helper/extensions/extensions.dart';

class Utils {
  static getDateStringFromDateTime(DateTime dateTime,
      {bool showMonthShort = false}) {
    String date =
        dateTime.day < 10 ? "0${dateTime.day}" : dateTime.day.toString();
    late String month;
    if (showMonthShort) {
      month = dateTime.getMonthName();
    } else {
      month = dateTime.month < 10
          ? "0${dateTime.month}"
          : dateTime.month.toString();
    }

    String year = dateTime.year.toString();
    String separator = showMonthShort ? " " : "/";
    return "$date$separator$month$separator$year";
  }

  static getTimeStringFromDateTime(
    DateTime dateTime, {
    bool showSecond = true,
  }) {
    String hour = dateTime.hour.toString();
    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    }

    String minute = dateTime.minute < 10
        ? "0${dateTime.minute}"
        : dateTime.minute.toString();
    String second = "";

    if (showSecond) {
      second = dateTime.second < 10
          ? "0${dateTime.second}"
          : dateTime.second.toString();
    }
    String meridian = "";
    meridian = dateTime.hour < 12 ? " AM" : " PM";

    return "$hour:$minute${showSecond ? ":" : ""}$second$meridian";
  }

  static String getDateTimeStringFromDateTime(DateTime dateTime,
      {bool showSecond = true,
      bool showDate = true,
      bool showTime = true,
      bool showMonthShort = false}) {
    if (showDate && !showTime) {
      return getDateStringFromDateTime(dateTime);
    } else if (!showDate && showTime) {
      return getTimeStringFromDateTime(dateTime, showSecond: showSecond);
    }
    return "${getDateStringFromDateTime(dateTime, showMonthShort: showMonthShort)} ${getTimeStringFromDateTime(dateTime, showSecond: showSecond)}";
  }

  static String getStorageStringFromByte(int bytes) {
    double b = bytes.toDouble(); //1024
    double k = bytes / 1024; //1
    double m = k / 1024; //0.001
    double g = m / 1024; //...
    double t = g / 1024; //...

    if (t >= 1) {
      return "${t.toStringAsFixed(2)} TB";
    } else if (g >= 1) {
      return "${g.toStringAsFixed(2)} GB";
    } else if (m >= 1) {
      return "${m.toStringAsFixed(2)} MB";
    } else if (k >= 1) {
      return "${k.toStringAsFixed(2)} KB";
    } else {
      return "${b.toStringAsFixed(2)} Bytes";
    }
  }

  static Future<void> createExcelFile(semuaInputan,
      {tipeInputan = "semuaorder"}) async {
    var excel = Excel.createExcel();
    var sheet = excel[excel.getDefaultSheet()!];

    // Add headers
    if (tipeInputan == "salesorder") {
      sheet.appendRow([
        "Tanggal Input",
        "Nama SP/SA/CSR",
        "Kode SP/SA/CSR",
        "Nama Perusahaan",
        "Alamat Perusahaan",
        "No HP",
        "Email",
        "Paket Yg Diinginkan",
        "Maps",
        "Status Input",
      ]);
    } else {
      sheet.appendRow([
        "Tanggal Input",
        "Inputer",
        "Nama SP/SA/CSR",
        "Kode SP/SA/CSR",
        "STO",
        "Datel",
        "Nama Perusahaan",
        "Alamat Perusahaan",
        "Koordinat",
        "ODP",
        "No HP",
        "No HP Alternatif",
        "Email",
        "Paket Yg Diinginkan",
        "NO SC",
        "Status SC",
        "Keterangan Status",
        "Keterangan Lain",
      ]);
    }

    // Add data
    if (tipeInputan == "salesorder") {
      for (var i = 0; i < semuaInputan.length; i++) {
        sheet.appendRow([
          dateFormatter.format(semuaInputan[i].createdAt),
          semuaInputan[i].namasaless,
          semuaInputan[i].kodesaless,
          semuaInputan[i].namausaha,
          semuaInputan[i].alamatt,
          semuaInputan[i].cp,
          semuaInputan[i].emaill,
          semuaInputan[i].pakett,
          semuaInputan[i].maps,
          semuaInputan[i].statusinput,
        ]);
      }
    } else {
      for (var i = 0; i < semuaInputan.length; i++) {
        sheet.appendRow([
          dateFormatter.format(semuaInputan[i].createdAt),
          semuaInputan[i].nama,
          semuaInputan[i].namasales,
          semuaInputan[i].kodesales,
          semuaInputan[i].sto,
          semuaInputan[i].datel,
          semuaInputan[i].namaperusahaan,
          semuaInputan[i].alamat,
          semuaInputan[i].koordinat,
          semuaInputan[i].odp,
          semuaInputan[i].nohp,
          semuaInputan[i].nohp2,
          semuaInputan[i].email,
          semuaInputan[i].paket,
          semuaInputan[i].nosc,
          semuaInputan[i].status,
          semuaInputan[i].ketstat,
          semuaInputan[i].ket,
        ]);
      }
    }

    for (var i = 0; i < 18; i++) {
      sheet.setColumnAutoFit(i);
    }

    excel.save(
        fileName: "Inputan_${dateTimeFormatter.format(DateTime.now())}.xlsx");
  }

  // ignore: no_leading_underscores_for_local_identifiers
  static Future<void> launchLink(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
