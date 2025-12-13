{
  description = "Personal portfolio website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        nodejs = pkgs.nodejs_20;

        portfolio = pkgs.buildNpmPackage {
          pname = "portfolio";
          version = "0.1.0";

          src = ./.;

          npmDepsHash = ""; # Run: nix build --impure to generate hash

          nativeBuildInputs = [
            nodejs
          ];

          buildPhase = ''
            runHook preBuild
            npm run build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            
            mkdir -p $out
            
            # Copy built Next.js application
            cp -r .next $out/.next
            cp -r public $out/public
            cp -r app $out/app
            cp -r components $out/components
            cp -r lib $out/lib
            cp -r posts $out/posts
            cp package.json $out/
            cp package-lock.json $out/
            cp next.config.ts $out/
            cp tsconfig.json $out/
            
            # Create a wrapper script to run the app
            mkdir -p $out/bin
            cat > $out/bin/portfolio <<EOF
            #!${pkgs.bash}/bin/bash
            cd $out
            export NODE_ENV=production
            ${nodejs}/bin/node ${nodejs}/lib/node_modules/next/dist/bin/next start
            EOF
            chmod +x $out/bin/portfolio
            
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Personal portfolio website built with Next.js";
            license = licenses.mit;
            maintainers = [ ];
            platforms = platforms.all;
          };
        };
      in
      {
        packages.default = portfolio;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            nodejs_20.pkgs.npm
            nodejs_20.pkgs.typescript
          ];

          shellHook = ''
            echo "Portfolio development environment"
            echo "Node.js version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo ""
            echo "Available commands:"
            echo "  npm run dev    - Start development server"
            echo "  npm run build  - Build for production"
            echo "  npm run start  - Start production server"
            echo "  npm run lint   - Run linter"
          '';
        };
      });
}
