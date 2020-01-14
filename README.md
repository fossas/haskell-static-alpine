# haskell-static-alpine

simple alpine-based docker image for building static haskell executables

It currently supplies GHC 8.6.5 and cabal-install v3

Example usage (inside project directory):
```sh
cabal install -O2 --enable-executable-static --enable-executable-stripping --install-method=copy --installdir=result
```

This will place built executables in `result/`
