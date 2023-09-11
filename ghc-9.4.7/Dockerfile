# There are more recent versions of Alpine.
# However, they have a version of pkg-config which changed its output in a way cabal doesn't understand.
# See: https://github.com/haskell/cabal/issues/8923
# There is a workaround script, but I don't think it's worth it since alpine:3.16 is still maintained as of 9/2023.
# If you try to upgrade and have trouble building, it may be related to the above.

FROM alpine:3.16
# Install deps for:
# - ghc/cabal: curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev
# - repo clone: git
# - static builds: zlib-static HACK(broken-ghc-musl): ncurses-static
# - random haskell libraries with cbits (basement): binutils-gold
# - to use embedded binaries in development (ie themis): libc6-compat
# - for nix installation via github action cachix/install-nix-action: sudo
RUN apk --no-cache add binutils-gold curl gcc g++ git gmp-dev ncurses-dev ncurses-static libffi-dev make xz tar perl zlib-dev zlib-static bash sudo libc6-compat git-lfs

# Install system deps for FOSSA CLI:
RUN apk --no-cache add bash xz-libs xz-dev bzip2-dev bzip2-static upx curl jq

# manual installation of ghcup -- the install script doesn't work headless
RUN mkdir -p ~/.ghcup/bin && curl https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup > ~/.ghcup/bin/ghcup && chmod +x ~/.ghcup/bin/ghcup
ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:$PATH"

RUN ghcup install ghc 9.4.7

RUN ghcup set ghc 9.4.7
RUN ghcup install cabal 3.10.1.0

# Sets USER environment to overcome issue, as described in:
# https://github.com/cachix/install-nix-action/issues/122
ENV USER=guest
