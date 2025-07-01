{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { pkgs, ... }: {
        packages.default = pkgs.stdenv.mkDerivation rec {
          name = "lorads";
          version = "2.0.1-alpha";
          src = ./src;
          buildInputs = with pkgs; [
            cmake
            blas
            lapack
            arpack
          ];
          configurePhase = ''
            cmake .
          '';
          buildPhase = ''
            cmake --build .
          '';
          installPhase = ''
            mkdir -p $out/bin
            mv LoRADS* $out/bin/lorads
          '';
        };
      };
    };
}
