{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];
      systems = ["x86_64-linux"];
      perSystem = {
        self',
        pkgs,
        ...
      }: {
        packages = {
          default = self'.packages.compileAll;
          compileAll = pkgs.callPackage ./pkgs/compileAll.nix {};
        };

        devShells.default = pkgs.mkShell {
          JAVA_HOME = pkgs.openjdk17.home;
          M2_HOME = ./.;

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
