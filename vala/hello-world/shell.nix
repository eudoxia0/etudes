{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    vala
    pkg-config
  ];

  buildInputs = with pkgs; [
    glib
  ];
}
