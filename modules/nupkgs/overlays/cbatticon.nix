self: super: let
  cbatticonSrc = super.fetchgit {
    url = "https://github.com/valr/cbatticon.git";
    rev = "b27965cb1ce4b80f23d26f87c08f7823ffb50f30";
    sha256 = "<replace-me>";
  };
in {
  cbatticon = super.cbatticon.overrideAttrs (old: {
    src = cbatticonSrc;
  });
}
