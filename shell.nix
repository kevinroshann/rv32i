{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # Define the packages you need
  buildInputs = [
    pkgs.iverilog
    pkgs.gnumake
    pkgs.gtkwave
    pkgs.git
  ];

  # Optional: Set up environment variables if needed
  # shellHook = ''
  #   echo Entering a Nix shell with iverilog and gtkwave
  # '';
}


