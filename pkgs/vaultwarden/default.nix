{
  vaultwarden,
  fetchFromGitHub,
  rustPlatform,
  dbBackend ? "sqlite",
}: let
  source = builtins.fromJSON (builtins.readFile ./conf/source.json);

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    tag = source.version;
    hash = source.srcHash;
  };
in
  (vaultwarden.override {inherit dbBackend;}).overrideAttrs (_: {
    version = source.version;
    inherit src;

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = source.cargoHash;
    };
  })
