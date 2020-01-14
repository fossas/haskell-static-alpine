FROM alpine:3 as bootstrap
# Install deps for:
# - ghcup/ghc: curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl
# - cabal-install: cabal (to bootstrap) zlib-dev
RUN apk add cabal curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev

# Install ghcup/ghc
RUN ( mkdir -p ~/.ghcup/bin && curl https://gitlab.haskell.org/haskell/ghcup/raw/master/ghcup > ~/.ghcup/bin/ghcup && chmod +x ~/.ghcup/bin/ghcup) && echo "ghcup installed"
ENV PATH="/root/.ghcup/bin:$PATH"
RUN ghcup install 8.6.5 && ghcup set 8.6.5

# Install cabal-install v3 using cabal-install v2 (installed via apk)
RUN cabal v2-update && cabal v2-install cabal-install


FROM alpine:3
# Install deps for:
# - ghc: curl gcc g++ gmp-dev ncurses-dev libffi-dev make xz tar perl
# - cabal-install: zlib-dev
# - repo clone: git
RUN apk --no-cache add curl gcc g++ git gmp-dev ncurses-dev libffi-dev make xz tar perl zlib-dev

# Copy ghc and cabal-install binaries
COPY --from=bootstrap /root/.ghcup/bin/ /root/.ghcup/bin/
COPY --from=bootstrap /root/.ghcup/ghc/ /root/.ghcup/ghc/
COPY --from=bootstrap /root/.cabal/ /root/.cabal/
ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:$PATH"
