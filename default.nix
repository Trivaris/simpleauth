pkgs:
pkgs.buildNpmPackage {
  pname = "simpleauth";
  version = "0.0.1";
  src = ./app;
  
  npmDepsHash = "sha256-/XJKgWoJZnwkCbbvA2HzW7bKU2ZIJPQ+x44f0jMViyk=";
  npmInstallFlags = [ "--prefer-offline" "--include=dev" ];
  npmBuild = "npm run build";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    # copy the *contents* of the build dir to $out so `node $out` works
    cp -r build/* "$out/"
    runHook postInstall
  '';

  nativeBuildInputs = [ pkgs.nodejs_20 ];
}