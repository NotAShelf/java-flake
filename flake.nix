{
  # why would you work with multiple java projects? hells, why would you even use java?
  # why would I do that? WHY DID I DO THAT
  description = "A Nix flake for working with multiple Java projects.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {
        self',
        pkgs,
        ...
      }: let
        inherit (pkgs) callPackage mkShell;
      in {
        packages = {
          compileAll = callPackage ./pkgs/compileAll.nix {};

          default = self'.packages.compileAll;
        };

        devShells.default = mkShell {
          JAVA_HOME = pkgs.openjdk17.home;
          M2_HOME = ./. + "/maven";

          buildInputs = with pkgs; [
            openjdk17
            gradle
            maven
            self'.packages.compileAll
          ];
        };
      };

      flake = {};
    };
}
