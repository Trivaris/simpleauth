{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  let
    eachSystem = nixpkgs.lib.genAttrs flake-utils.lib.defaultSystems;
  in {
    devShells = eachSystem (system:
    let pkgs = import nixpkgs { inherit system; };
    in {
      default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit (pkgs)
            nodejs_20
            pnpm
            ;
          inherit (pkgs.nodePackages)
            typescript-language-server
            prettier
            ;
        };
      };
    });

    packages = eachSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      default = import ./default.nix pkgs;
    });

    apps = eachSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        runner = pkgs.writeShellScriptBin "simpleauth" ''
          set -euo pipefail
          export NODE_ENV=production
          : ''${HOST:=0.0.0.0}
          : ''${PORT:=3000}
          exec ${pkgs.nodejs_20}/bin/node ${self.packages.${system}.default}/index.js
        '';
      in {
        default = {
          type = "app";
          program = "${runner}/bin/simpleauth";
        };
      }
    );
  };
}
