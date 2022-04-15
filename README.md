# haskell-static-alpine

`haskell-static-alpine` is an Alpine-based Docker image that contains GHC and `cabal`, for building static Haskell executables.

## Why do I need this?

Normally, Haskell binaries are dynamically linked, and require `glibc` and `gmp` at runtime. These libraries are unavailable in some environments, such as Alpine Docker images.

(Note that _even if_ you specify `--enable-executable-static`, GHC will still dynamically link against `glibc`, much like `cgo`.)

If you deploy Haskell binaries in these environments, you need a fully statically linked executable. You can construct such an executable using this Docker image.

This Docker image uses the Alpine distribution of GHC, which will statically link generated executables against `musl` when provided `--enable-executable-static`.

## Usage

### Pulling the image

This image is automatically published on [Docker Hub](https://hub.docker.com/r/fossa/haskell-static-alpine). To pull it, run:

```sh
docker pull fossa/haskell-static-alpine:$VERSION
```

Supported versions are:

- `ghc-8.8.2`
- `ghc-8.10.3`
- `ghc-8.10.4`
- `ghc-8.10.7`
- `ghc-9.0.2`

### Building your executable

You should use this container as a base image for your own build containers.

Within a container, run:

```sh
cabal build --enable-executable-static
```

This will build a statically linked Haskell binary. Make sure to `strip` the binary afterwards to reduce size.
