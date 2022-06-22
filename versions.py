from collections import OrderedDict

class Package:
  def __init__(self, name, version, url, md5):
    self.name = name
    self.version = version
    self.url = url
    self.md5 = md5

  def __str__(self):
    return self.name + "(" + self.version + ", " + self.url + ", " + self.md5 + ")"

def all_deps_ordered():
   packages = OrderedDict()
   
   version_exiv2 = "0.27.5"
   packages["exiv2"] = Package(
        "exiv2", 
        version_exiv2,
        "https://github.com/Exiv2/exiv2/archive/refs/tags/v{}.tar.gz".format(version_exiv2), 
        "612b1b9ad1701120aef6ae1b6bab56bf"
   )
   
   
   return packages
   
"""
    VERSION_expat="2.4.8"
    URL_expat="https://github.com/libexpat/libexpat/releases/download/R_${VERSION_expat//./_}/expat-${VERSION_expat}.tar.gz".format()
    MD5_expat="ce5fa3fa4d866d83ab0cfb00bb95b77a"

    VERSION_freexl="1.0.2"
    URL_freexl="http://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-${VERSION_freexl}.tar.gz".format()
    MD5_freexl="9954640e5fed76a5d9deb9b02b0169a0"

    VERSION_gdal="3.1.3"
    URL_gdal="http://download.osgeo.org/gdal/$VERSION_gdal/gdal-${VERSION_gdal}.tar.gz".format()
    MD5_gdal="4094633f28a589a7b4b483aa51beb37c"

    VERSION_geodiff="1.0.6"
    URL_geodiff="https://github.com/merginmaps/geodiff/archive/${VERSION_geodiff}.tar.gz".format()
    MD5_geodiff="8f6408b19f9a8d4b6f636b2302bbac22"

    # NOTE: if changed, update also qgis's recipe
    VERSION_geos="3.9.1"
    URL_geos="https://github.com/libgeos/geos/archive/${VERSION_geos}.tar.gz".format()
    MD5_geos="ea4ced8ff19533e8b527b7316d7010bb"

    # NOTE: macOS uses SYSTEM iconv
    VERSION_iconv="1.14"
    URL_iconv="http://ftpmirror.gnu.org/gnu/libiconv/libiconv-${VERSION_iconv}.tar.gz".format()
    MD5_iconv="e34509b1623cec449dfeb73d7ce9c6c6"

    VERSION_libspatialindex="1.9.3"
    URL_libspatialindex="https://github.com/libspatialindex/libspatialindex/archive/${VERSION_libspatialindex}.tar.gz".format()
    MD5_libspatialindex="b0cad679ee475cce370d8731d47b174a"

    VERSION_libspatialite="4.3.0a"
    URL_libspatialite="http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-${VERSION_libspatialite}.tar.gz".format()
    MD5_libspatialite="6b380b332c00da6f76f432b10a1a338c"

    VERSION_libtasn1="4.13"
    URL_libtasn1="https://gitlab.com/gnutls/libtasn1/-/archive/libtasn1_4_13/libtasn1-libtasn1_4_13.tar.gz".format()
    MD5_libtasn1="349a320d12721227e29a9122bdaddea9"

    VERSION_libzip="1-5-2"
    URL_libzip="https://github.com/nih-at/libzip/archive/rel-${VERSION_libzip}.zip".format()
    MD5_libzip="e5d917a79134eba8f982f7a32435adc4"

    VERSION_qca="2.3.1"
    URL_qca="https://github.com/KDE/qca/archive/v${VERSION_qca}.tar.gz".format()
    MD5_qca="96c4769d51140e03087266cf705c2b86"

    VERSION_qgis="3.22.6"
    URL_qgis="https://github.com/qgis/QGIS/archive/refs/tags/final-${VERSION_qgis//./_}.tar.gz".format()
    MD5_qgis="484584d5a9150ed9ab3e9cf3a021d63c"

    VERSION_qtkeychain="0.13.2"
    URL_qtkeychain="https://github.com/frankosterfeld/qtkeychain/archive/v${VERSION_qtkeychain}.tar.gz".format()
    MD5_qtkeychain="4622bf9f4bb73fb72ea9eae272c49235"

    VERSION_postgresql="11.2"
    URL_postgresql="https://ftp.postgresql.org/pub/source/v${VERSION_postgresql}/postgresql-${VERSION_postgresql}.tar.bz2".format()
    MD5_postgresql="19d43be679cb0d55363feb8926af3a0f"

    VERSION_proj="6.3.2"
    URL_proj="https://github.com/OSGeo/PROJ/releases/download/$VERSION_proj/proj-$VERSION_proj.tar.gz".format()
    MD5_proj="2ca6366e12cd9d34d73b4602049ee480"

    VERSION_protobuf="3.11.4"
    URL_protobuf="https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION_protobuf}/protobuf-cpp-${VERSION_protobuf}.tar.gz".format()
    MD5_protobuf="44fa1fde51cc21c79d0e64caef2d2933"

    VERSION_sqlite_MAJOR="3"
    VERSION_sqlite_MINOR="35"
    VERSION_sqlite_PATCH="2"
    VERSION_sqlite3="${VERSION_sqlite_MAJOR}.${VERSION_sqlite_MINOR}.${VERSION_sqlite_PATCH}".format()
    URL_sqlite3_BASE="$(printf "%d%02d%02d00" $VERSION_sqlite_MAJOR $VERSION_sqlite_MINOR $VERSION_sqlite_PATCH)".format()
    URL_sqlite3="https://sqlite.org/2021/sqlite-autoconf-${URL_sqlite3_BASE}.tar.gz".format()
    MD5_sqlite3="454e0899d99a7b28825db3d807526774"

    VERSION_zxing="1.1.1"
    URL_zxing="https://github.com/nu-book/zxing-cpp/archive/v${VERSION_zxing}.tar.gz".format()
    MD5_zxing="4b1cc29387c0318405f9042d7c657159"

    VERSION_qtlocation="$QT_VERSION"
    URL_qtlocation="https://github.com/qt/qtlocation/archive/v${VERSION_qtlocation}.tar.gz".format()
    MD5_qtlocation="c5068213cf3b8fa6a2ee54a4d82cbecc"

    VERSION_curl="7.81.0"
    URL_curl="https://github.com/curl/curl/archive/curl-${VERSION_curl//./_}.tar.gz".format()
    MD5_curl="3b2d1ed46e8f1786a5559179411e48eb"

    # not on macOS
    VERSION_iconv="1.14"
    URL_iconv="http://ftpmirror.gnu.org/gnu/libiconv/libiconv-${VERSION_iconv}.tar.gz".format()
    MD5_iconv="e34509b1623cec449dfeb73d7ce9c6c6"

    # VERSION_libpng <- we use internal GDAL libpng
    # VERSION_libjpeg <- we use internal GDAL libjpeg

    VERSION_webp="1.1.0"
    URL_webp="https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${VERSION_webp}.tar.gz".format()
    MD5_webp="7e047f2cbaf584dff7a8a7e0f8572f18"

    # iOS/macOS Apple's SecureTransport
    # OpenSSL 1.1.x has new API compared to 1.0.2
    # We need to stick with the version of SSL that is
    # compatible with Qt's binaries, otherwise
    # you got (runtime)
    # "qt.network.ssl: QSslSocket::connectToHostEncrypted: TLS initialization failed"
    # https://blog.qt.io/blog/2019/06/17/qt-5-12-4-released-support-openssl-1-1-1/
    # see https://wiki.qt.io/Qt_5.12_Tools_and_Versions
    # see https://wiki.qt.io/Qt_5.14.0_Known_Issues
    # Qt 5.12.3 OpenSSL 1.0.2b
    # Qt 5.12.4 OpenSSL 1.1.1
    # Qt 5.13.0 OpenSSL 1.1.1
    # Qt 5.14.1 OpenSSL 1.1.1d
    # Qt 5.14.2 OpenSSL 1.1.1f
    VERSION_openssl="1.1.1j"
    URL_openssl="https://github.com/openssl/openssl/archive/OpenSSL_${VERSION_openssl//./_}.tar.gz".format()
    MD5_openssl="2913df113ecd2a396a171d9234556ea1"
"""


if __name__ == "__main__":
    deps = all_deps_ordered()
    for key, package in deps.items():
        print(package)

