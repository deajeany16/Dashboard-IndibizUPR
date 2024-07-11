import 'dart:math';

class Images {
  //----------------WebLogo----------------
  static String logoIcon = 'assets/images/logo/logo_icon_dark.png';

  static String ethLogoIcon = 'assets/images/logo/ethereum-eth-logo.png';

  static String googleLogo = 'assets/images/dummy/google.png';

  //----------------Dummy Images----------------

  static List<String> avatars = List.generate(
      12, (index) => 'assets/images/dummy/avatar${index + 1}.png');

  static List<String> login =
      List.generate(6, (index) => 'assets/images/dummy/login${index + 1}.jpg');

  static List<String> landscapeImages =
      List.generate(4, (index) => 'assets/images/dummy/l${index + 1}.jpg');

  static List<String> squareImages =
      List.generate(15, (index) => 'assets/images/dummy/${index + 1}.jpg');

  static List<String> portraitImages =
      List.generate(3, (index) => 'assets/images/dummy/p${index + 1}.jpg');

  static List<String> marketplaceImages =
      List.generate(3, (index) => 'assets/images/dummy/m-${index + 1}.jpg');

  static List<String> nft =
      List.generate(3, (index) => 'assets/images/dummy/nft${index + 1}.jpeg');

  static List<String> success =
      List.generate(1, (index) => 'assets/images/dummy/s-${index + 1}.jpg');

  static List<String> landing = List.generate(
      5, (index) => 'assets/images/dummy/landing-${index + 1}.jpg');

  static List<String> brand =
      List.generate(8, (index) => 'assets/images/dummy/brand-${index + 1}.jpg');

  static List<String> error =
      List.generate(5, (index) => 'assets/images/dummy/error-${index + 1}.jpg');

  static List<String> comingSoon = List.generate(
      1, (index) => 'assets/images/dummy/coming_soon-${index + 1}.jpg');

  static List<String> maintenance = List.generate(
      1, (index) => 'assets/images/dummy/maintenance-${index + 1}.jpg');

  static List<String> social = List.generate(
      5, (index) => 'assets/images/dummy/social-${index + 1}.jpg');

  static List<String> shopping =
      List.generate(7, (index) => 'assets/images/dummy/h${index + 1}.jpg');

  static List<String> shoes =
      List.generate(1, (index) => 'assets/images/dummy/shoes.png');

  static String randomImage(List<String> images) {
    return images[Random().nextInt(images.length)];
  }
}
