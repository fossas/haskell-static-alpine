# haskell-static-alpine

an alpine-based docker image to assist with building static haskell executables. It supplies GHC 8.8.2 and cabal-install v3

The image available at `quay.io/fossa/haskell-static-alpine`

Example usage (inside project directory):
```sh
cabal build -O2 --enable-executable-static
```

Make sure to run `strip` the resulting binary
