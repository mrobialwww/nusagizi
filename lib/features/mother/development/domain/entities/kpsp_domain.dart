/// Domain kategori soal KPSP
enum KpspDomain {
  motorikKasar,
  motorikHalus,
  bicaraBahasa,
  sosialisasiKemandirian;

  String get label {
    switch (this) {
      case KpspDomain.motorikKasar:
        return 'Motorik Kasar';
      case KpspDomain.motorikHalus:
        return 'Motorik Halus';
      case KpspDomain.bicaraBahasa:
        return 'Bicara & Bahasa';
      case KpspDomain.sosialisasiKemandirian:
        return 'Sosialisasi & Kemandirian';
    }
  }
}
