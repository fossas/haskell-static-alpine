# haskell-static-alpine

simple alpine-based docker image for building static haskell executables. It supplies GHC 8.6.5 and cabal-install v3

The image available at `quay.io/fossa/haskell-static-alpine`

Example usage (inside project directory):
```sh
cabal install -O2 --enable-executable-static --enable-executable-stripping --install-method=copy --installdir=result
```

This will place built executables in `result/`
