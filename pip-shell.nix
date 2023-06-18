# # shell.nix
# { pkgs ? import <nixpkgs> {} }:
# let
#   my-python-packages = p: with p; [
#     jupyter
#     pip
#     virtualenv
#   ];
#   my-python = pkgs.python3.withPackages my-python-packages;
# in pkgs.mkShell {
#   packages = [
#     pkgs.wget
#     my-python
#     # pkgs.glibc
#   ];
#   shellHook = ''
#     # Activate Python virtual environment
#     source .venv/bin/activate
#     source .env.local
#   '';
# }

let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  buildInputs = [
    pkgs.python310
    pkgs.python310.pkgs.requests
    pkgs.python310Packages.greenlet
  ];
  shellHook = ''
    # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
    # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
    export PIP_PREFIX=$(pwd)/_build/pip_packages
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"
    unset SOURCE_DATE_EPOCH
    source .venv/bin/activate
  '';
}