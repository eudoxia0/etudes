{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    vala
    pkg-config
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = with pkgs; [
    gtk4
    glib
    gdk-pixbuf
    graphene
    pango
    cairo
    harfbuzz
  ];
}
