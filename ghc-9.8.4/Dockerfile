FROM alpine:3.18
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

ENV GHC_VERSION="9.8.4"

ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:$PATH"

# There aren't official builds of ghcup that are built against musl for aarch64.
# So the following two steps do the install manually on that platform.
# They manually do the same steps that ghcup would.
# ghcup should have support for this soon: https://github.com/haskell/ghcup-hs/issues/1012#issuecomment-2294829976
# When that happens, you should be able to remove the 'else' branches and have the install work for all platforms.
RUN <<EOF
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
  export BOOTSTRAP_HASKELL_MINIMAL=1
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

  ghcup install ghc "$GHC_VERSION"
  ghcup set ghc "$GHC_VERSION"

  # Docs take up a lot of space in the image and aren't really necessary.
  rm -rf "$HOME/.ghcup/share/doc"
EOF

# Install cabal
RUN <<EOF
  ghcup install cabal 3.12.1.0
EOF

# Sets USER environment to overcome issue, as described in:
# https://github.com/cachix/install-nix-action/issues/122
ENV USER=guest
