FROM alpine:3.17
# Install deps for:
# - ghc/cabal: curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev
# - repo clone: git
# - static builds: zlib-static HACK(broken-ghc-musl): ncurses-static
# - random haskell libraries with cbits (basement): binutils-gold
# - to use embedded binaries in development (ie themis): libc6-compat
# - for nix installation via github action cachix/install-nix-action: sudo
RUN apk --no-cache add binutils-gold curl gcc g++ git gmp-dev ncurses-dev ncurses-static libffi-dev make xz xz-static tar perl zlib-dev zlib-static bash sudo libc6-compat git-lfs

# Install system deps for FOSSA CLI:
RUN apk --no-cache add bash xz-libs xz-dev bzip2-dev bzip2-static upx curl jq

ENV GHC_VERSION="9.8.2"

ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:$PATH"

# There aren't official builds of ghcup that are built against musl for aarch64.
# So the following two steps do the install manually on that platform.
# They manually do the same steps that ghcup would.
# ghcup should have support for this soon: https://github.com/haskell/ghcup-hs/issues/1012#issuecomment-2294829976
# When that happens, you should be able to remove the 'else' branches and have the install work for all platforms.
RUN <<EOF
  if [ $(uname -m) != "aarch64" ] ; then
    export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
    export BOOTSTRAP_HASKELL_MINIMAL=1
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

    ghcup install ghc "$GHC_VERSION"
    ghcup set ghc "$GHC_VERSION"
  else
    mkdir /tmp/ghc
    curl "https://downloads.haskell.org/~ghc/$GHC_VERSION/ghc-$GHC_VERSION-aarch64-alpine3_18-linux.tar.xz" | tar --strip-components=1 -xJC /tmp/ghc
    cd /tmp/ghc
    ./configure --prefix="$HOME/.ghcup" && make install && rm -rf /tmp/ghc
  fi

  # Docs take up a lot of space in the image and aren't really necessary.
  rm -rf "$HOME/.ghcup/share/doc"

EOF

# Install cabal
RUN <<EOF
  if [ $(uname -m) != "aarch64" ] ; then
    ghcup install cabal 3.10.3.0
  else
    curl https://downloads.haskell.org/~ghcup/unofficial-bindists/cabal/3.10.3.0/cabal-install-3.10.3.0-aarch64-alpine3_20.tar.xz | tar -xJC "$HOME/.ghcup/bin/"
    chmod 755 "$HOME/.ghcup/bin/cabal"
    rm "$HOME/.ghcup/bin/plan.json"
  fi
EOF

# Sets USER environment to overcome issue, as described in:
# https://github.com/cachix/install-nix-action/issues/122
ENV USER=guest
