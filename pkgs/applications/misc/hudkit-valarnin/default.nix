{ lib
, clang
, fetchFromGitHub
, glib-networking
, json_c
, keybinder3
, makeWrapper
, pkg-config
, stdenv
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation {
  pname = "hudkit";
  version = "unstable-2021-11-20";

  src = fetchFromGitHub {
    owner = "valarnin";
    repo = "hudkit";
    rev = "6e05a079152333b60cf24b69fbb3f63585a7865d";
    sha256 = "sha256-rt6nOfHL+iRDM20fFtEHIApd/NQQJDopczwtd2xl948=";
  };

  sourceRoot = "source/webkit";

  nativeBuildInputs = [
    clang
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    json_c.dev
    keybinder3
    webkitgtk.dev
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin hudkit
    wrapProgram $out/bin/hudkit \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"

    runHook postInstall
  '';
}
