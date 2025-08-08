{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    dream2nix.url = "github:nix-community/dream2nix";
  };

  outputs = { nixpkgs, flake-utils, ... }:
  let 
    inherit (flake-utils.lib) eachDefaultSystem;
  in
  eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.default = pkgs.mkShell {
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

      packages.default = pkgs.writeTextFile {
        name = "placeholder";
        text = "Build with dream2nix after init";
      };
    }
  );
}
