#!/usr/bin/env bash
set -euo pipefail

echo "== C =="
(
  cd c
  gcc bs1.c  -o bs1c  -I/usr/include/apr-1.0 -lapr-1
  gcc bs2.c  -o bs2c  -I/usr/include/apr-1.0 -lapr-1
)

echo "== C++ =="
(
  cd cpp
  g++ bs1.cpp -pipe -O3 -fomit-frame-pointer -march=ivybridge -std=gnu++17 -ltbb -o bs1cpp
  g++ bs2.cpp -pipe -O3 -fomit-frame-pointer -march=ivybridge -std=gnu++17 -ltbb -o bs2cpp
)

echo "== Haskell =="
(
  cd haskell
  ghc -O2 -threaded -rtsopts -with-rtsopts="-N" -package parallel -package ghc-compact bs1.hs -o bs1hs
  ghc -O2 -threaded -rtsopts -with-rtsopts="-N" -package parallel -package ghc-compact bs2.hs -o bs2hs
)

echo "== Zig =="
(
  cd zig/bs1
  zig build -Doptimize=ReleaseFast
  # Only bs1 exists here—zig-out/bin/bs1
)

echo "Compilation complete."
