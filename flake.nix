{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # devShells.default = with pkgs;
        #   mkShell {
        #     packages = [ enchant pkg-config ];
        #   };

        packages.default =
          with pkgs;
          stdenv.mkDerivation {
            pname = "jinx-mod";
            version = self.shortRev or self.dirtyShortRev or self.lastModifiedDate or "unknown";
            src = ./.;
            nativeBuildInputs = [ pkg-config ];
            buildInputs = [ enchant ];
            buildPhase = ''
              $CC -I. -O2 -Wall -Wextra -fPIC -shared -o jinx-mod.dylib jinx-mod.c $($PKG_CONFIG --cflags --libs enchant-2)
              mkdir -p $out/lib
              mv jinx-mod.dylib $out/lib/
            '';
          };
      }
    );
}
