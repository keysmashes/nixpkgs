{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "actual";
  version = "24.7.0";
  src = fetchurl {
    url = "https://github.com/actualbudget/actual/releases/download/v${version}/Actual-linux.AppImage";
    sha256 = "sha256-aU7ZYjcIPv/AByIqfSiUZHjHF4l2wFUWXt8kbPFNjiI=";
  };
  extracted = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${extracted}/desktop-electron.desktop $out/share/applications/actual.desktop
    sed -i s@^Exec=.\*@Exec=actual@g $out/share/applications/actual.desktop
    sed -i s@^Icon=desktop-electron@Icon=actual@g $out/share/applications/actual.desktop

    cp -r ${extracted}/usr/share/icons -t $out/share/
    chmod -R +w $out/share/icons
    find $out/share/icons -name desktop-electron.png -execdir mv {} actual.png \;
  '';

  meta = with lib; {
    description = "An Electron-based envelope budgeting app";
    homepage = "https://actualbudget.org";
    downloadPage = "https://github.com/actualbudget/actual/releases";
    license = licenses.mit;
    mainProgram = "actual";
    platforms = platforms.linux;
    maintainers = with maintainers; [ sersorrel ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
