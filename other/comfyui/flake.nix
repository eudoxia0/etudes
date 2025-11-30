{
  description = "Stable Diffusion environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python311
          python311Packages.pip
          python311Packages.virtualenv
          wget
          rocmPackages.rocm-core
          rocmPackages.rocm-runtime
          zstd
        ];

        shellHook = ''
          export HSA_OVERRIDE_GFX_VERSION=10.3.0
          export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.lib.getLib pkgs.zstd}/lib:$LD_LIBRARY_PATH
        '';
      };
    };
}
