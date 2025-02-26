{ mixRelease
, fetchMixDeps
, erlang
}: mixRelease rec {
  pname = "lexical";
  version = "development";

  src = ./..;

  mixFodDeps = fetchMixDeps {
    inherit pname;
    inherit version;

    src = ./..;

    sha256 = "sha256-a715z1ti1J0kKzLcIS1UuFpPAMEx2VlFpkmZrRTSWh4=";
  };

  installPhase = ''
    runHook preInstall

    mix release lexical --no-deps-check --path "$out"

    runHook postInstall
  '';

  preFixup = ''
    for script in $out/releases/*/elixir; do
      substituteInPlace "$script" --replace 'ERL_EXEC="erl"' 'ERL_EXEC="${erlang}/bin/erl"'
    done

    wrapProgram $out/bin/lexical --set RELEASE_COOKIE lexical
  '';
}
