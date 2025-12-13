{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
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
}
