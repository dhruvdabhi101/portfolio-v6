{ pkgs ? import <nixpkgs> { } }:

let
  nodejs = pkgs.nodejs_20;
  npm = nodejs.pkgs.npm;
in
pkgs.buildNpmPackage {
  pname = "portfolio";
  version = "0.1.0";

  src = ./.;

  npmDepsHash = ""; # Run with --impure to generate hash, then replace this

  nativeBuildInputs = [
    nodejs
  ];

  # Next.js build configuration
  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  # Install phase - copy built files
  installPhase = ''
    runHook preInstall
    
    # Create output directory
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

  # Meta information
  meta = with pkgs.lib; {
    description = "Personal portfolio website built with Next.js";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
