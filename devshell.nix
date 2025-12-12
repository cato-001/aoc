{ pkgs }:
pkgs.mkShell {
  packages = [
    pkgs.zig
    pkgs.python3
    pkgs.hyperfine
  ];
}
