{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piped";
  version = "0-unstable-2026-08-13";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "15f7e8a23b0f048e8110a449fa3720902ffed308";
    hash = "sha256-zQqkF+MFDokN0DPBWfJfEhqaYzQkIGT/0ityYXMi5PM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist "$out"

    runHook postInstall
  '';

  strictDeps = true;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-mBEzm+GzF/V3W/6JPOn81YawAMaSTw8THtOUb3qtmvc=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ ];
    license = lib.licenses.agpl3Plus;
  };

})
