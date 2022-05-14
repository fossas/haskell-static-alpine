# ---------- HACK(broken-ghc-musl) ----------
# The 8.8 musl bindist from ghcup expects libtinfow.so.6. libtinfow is
# integrated into libncursesw.so.6 -- so we copy the libraries. We also copy
# the static library (libncursesw.a) so we can build static executables.
#
# We can remove the related workarounds if/when the ghc musl bindists link
# directly against ncurses again.
#
# ---------- HACK(cabal-3) ----------
# using edge because its repo has cabal-install 3.x
FROM alpine:edge
# Install cabal-install
# Install deps for:
# - ghc/cabal: curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev
# - repo clone: git
# - static builds: zlib-static HACK(broken-ghc-musl): ncurses-static
RUN apk --no-cache add cabal curl gcc g++ git gmp-dev ncurses-dev ncurses-static libffi-dev make xz tar perl zlib-dev zlib-static bash

RUN mkdir -p ~/.ghcup/bin && curl https://gitlab.haskell.org/haskell/ghcup/raw/master/ghcup > ~/.ghcup/bin/ghcup && chmod +x ~/.ghcup/bin/ghcup
ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:$PATH"

# HACK(broken-ghc-musl)
RUN cp /usr/lib/libncursesw.so.6 /usr/lib/libtinfow.so.6
RUN cp /usr/lib/libncursesw.so.6 /usr/lib/libtinfow.so
RUN cp /usr/lib/libncursesw.a /usr/lib/libtinfow.a

RUN ghcup install 8.8.4 && ghcup set 8.8.4
