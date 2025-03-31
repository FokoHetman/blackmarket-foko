{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fokquote";
  version = "1";

  src = fetchFromGitHub {
    owner = "fokohetman";
    repo = "fok-quote";
    rev = "1b1eff029cede838d82effcf3817bcb97dee903b";
    hash = "sha256-DdvCtzDlKtpqnhUL7VpNxv/cAXoYe6UVlHV0B+TWwDU=";
  };
  installPhase = let
    config = import (import src).config;
    quotes = builtins.concatStringsSep ""
      (["["]
      ++ (lib.lists.forEach config.quotes (x: "[\\\"" + toString (builtins.elemAt x 0) + "\\\" \\\"" + toString (builtins.elemAt x 1) + "\\\"]"))
      ++ ["]"]);
    plush = builtins.concatStringsSep "" (#"\\\"" + config.plush + "\\\"";
      ["["]
      ++ (lib.lists.forEach (lib.strings.splitString "\n" config.plush) (x: "\"" + toString x + "\""))
      ++ ["]"]);
  in
    ''
      echo "AAAAAAAAAA"
      export PLUSH='${plush}'
      echo "BBBBBBBBBB"
      mkdir -p "$out/bin"
      export CONFIG="{ quotes=${quotes}; plush=$PLUSH }"
      echo "===================="
      echo $CONFIG
      echo "===================="
      rustc $src/src/fok-quote.rs -o $out/bin/fokquote
    '';

  buildInputs = [ pkgs.rustc pkgs.gcc ];
}
