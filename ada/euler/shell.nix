{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    gnat
    gnumake
    gprbuild
  ];

  shellHook = ''
    echo "Ada development environment loaded"
    echo "GNAT: $(gnatmake --version | head -n1)"
    echo "gprbuild: $(gprbuild --version | head -n1)"
    echo "Make: $(make --version | head -n1)"
  '';
}
