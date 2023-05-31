{ lib
, fetchFromGitHub
, glib-networking
, makeWrapper
, pkg-config
, stdenv
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation {
  pname = "hudkit";
  version = "unstable-2023-05-18";

  src = fetchFromGitHub {
    owner = "anko";
    repo = "hudkit";
    rev = "5554dccf541e2dc680934916a464e0e75a0084ed";
    sha256 = "sha256-TZtXuvvvcgebrohulRtxyvb3etEKEjITrfF5XodPCpQ=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
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
