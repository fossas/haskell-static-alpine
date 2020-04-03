# ---------- HACK(bootstrap-cabal-3) ----------
# Bootstrap cabal-install 3.x with GHC 8.6.5 & cabal-install 2.4.x
#
# This is required because:
# 1. GHC 8.8 isn't supported by cabal-install 2.4.x
# 2. The cabal-install installed by `ghcup install-cabal` is dynamically-linked
#    against libc, so it doesn't work on alpine
#
# This is hopefully a temporary workaround until either:
# 1. cabal-install from apk upgrades to 3.x
# 2. `ghcup install-cabal` works on alpine
#
# We "install" cabal-install twice because cabal-install 2.4.x doesn't support
# --installdir or --install-method=copy. The second install is fast.
#
# ---------- HACK(broken-ghc-musl) ----------
# The 8.8 musl bindist from ghcup expects libtinfow.so.6. libtinfow is
# integrated into libncursesw.so.6 -- so we copy the libraries. We also copy
# the static library (libncursesw.a) so we can build static executables.
#
# We can remove the related workarounds if/when the ghc musl bindists link
# directly against ncurses again.

FROM alpine:3 as bootstrap
# Install deps for:
# - ghcup/ghc: curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev zlib-static
# - HACK(bootstrap-cabal-3): cabal
RUN apk add cabal curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev zlib-static

# Install ghcup/ghc
RUN ( mkdir -p ~/.ghcup/bin && curl https://gitlab.haskell.org/haskell/ghcup/raw/master/ghcup > ~/.ghcup/bin/ghcup && chmod +x ~/.ghcup/bin/ghcup) && echo "ghcup installed"
ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:$PATH"

# HACK(bootstrap-cabal-3)
RUN ghcup install 8.6.5 && ghcup set 8.6.5
RUN cabal v2-update && cabal v2-install cabal-install
RUN /root/.cabal/bin/cabal install cabal-install --installdir=/root/.ghcup/bin/ --install-method=copy
RUN strip /root/.ghcup/bin/cabal
RUN ghcup rm --force 8.6.5

# HACK(broken-ghc-musl)
RUN cp /usr/lib/libncursesw.so.6 /usr/lib/libtinfow.so.6

RUN ghcup install 8.8.2 && ghcup set 8.8.2

FROM alpine:3
# Install deps for:
# - ghc/cabal: curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev
# - repo clone: git
# - HACK(broken-ghc-musl): ncurses-static
RUN apk --no-cache add curl gcc g++ git gmp-dev ncurses-dev ncurses-static libffi-dev make xz tar perl zlib-dev

# Copy ghc and cabal-install binaries
COPY --from=bootstrap /root/.ghcup/bin/ /root/.ghcup/bin/
COPY --from=bootstrap /root/.ghcup/ghc/ /root/.ghcup/ghc/

# HACK(broken-ghc-musl)
RUN cp /usr/lib/libncursesw.so.6 /usr/lib/libtinfow.so.6
RUN cp /usr/lib/libncursesw.so.6 /usr/lib/libtinfow.so
RUN cp /usr/lib/libncursesw.a /usr/lib/libtinfow.a

ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:$PATH"
