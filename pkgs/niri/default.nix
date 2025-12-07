{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  cairo,
  dbus,
  libGL,
  libdisplay-info,
  libinput,
  seatd,
  libxkbcommon,
  libgbm,
  pango,
  wayland,
  pipewire,
  systemd,
  udev,
  ...
}: let
  waylandRsSrc = fetchFromGitHub {
    owner = "Smithay";
    repo = "wayland-rs";
    rev = "b04967be632bc739eab7d49154a7d6c4397e974f";
    hash = "sha256-OJh0ZAXGdPM74wHqziZRebsYmTYUy5Y3gpwJ0OR6Vn4=";
  };

  niriSrc = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "v25.11";
    hash = "sha256-FC9eYtSmplgxllCX4/3hJq5J3sXWKLSc7at8ZUxycVw=";
  };
in
  rustPlatform.buildRustPackage {
    pname = "niri-custom";
    version = "25.11.0-patched";

    src = niriSrc;

    cargoHash = "sha256-X28M0jyhUtVtMQAYdxIPQF9mJ5a77v8jw1LKaXSjy7E=";

    postPatch = ''
      patchShebangs resources/niri-session
      substituteInPlace resources/niri.service \
        --replace-fail '/usr/bin' "$out/bin"

      rm Cargo.lock

      cat >> Cargo.toml <<EOF

      [patch."https://github.com/Smithay/wayland-rs"]
      wayland-backend = { path = "${waylandRsSrc}/wayland-backend" }
      wayland-client = { path = "${waylandRsSrc}/wayland-client" }
      wayland-cursor = { path = "${waylandRsSrc}/wayland-cursor" }
      wayland-egl = { path = "${waylandRsSrc}/wayland-egl" }
      wayland-scanner = { path = "${waylandRsSrc}/wayland-scanner" }
      wayland-server = { path = "${waylandRsSrc}/wayland-server" }
      wayland-sys = { path = "${waylandRsSrc}/wayland-sys" }
      EOF

      echo "Searching for vendor Cargo.lock..."
      vendor_lock=$(find /build -maxdepth 2 -path "*-vendor/Cargo.lock" | head -n 1)

      if [ -n "$vendor_lock" ]; then
        echo "Found vendor lockfile at: $vendor_lock"
        cp "$vendor_lock" Cargo.lock
      else
        echo "WARNING: Could not find vendor Cargo.lock in /build. This is expected during vendor generation, but will fail during the main build."
      fi
    '';

    nativeBuildInputs = [
      rustPlatform.bindgenHook
      pkg-config
      installShellFiles
    ];

    buildInputs = [
      cairo
      dbus
      libGL
      libdisplay-info
      libinput
      seatd
      libxkbcommon
      libgbm
      pango
      wayland
      pipewire
      systemd
      udev
    ];

    buildFeatures = ["dbus" "systemd" "xdp-gnome-screencast"];

    env = {
      RUSTFLAGS = toString [
        "-C link-arg=-Wl,--push-state,--no-as-needed"
        "-C link-arg=-lEGL"
        "-C link-arg=-lwayland-client"
        "-C link-arg=-Wl,--pop-state"
      ];
    };

    checkFlags = ["--skip=::egl"];

    preCheck = ''
      export XDG_RUNTIME_DIR="$(mktemp -d)"
    '';

    postInstall = ''
      installShellCompletion --cmd niri \
        --bash <($out/bin/niri completions bash) \
        --fish <($out/bin/niri completions fish) \
        --nushell <($out/bin/niri completions nushell) \
        --zsh <($out/bin/niri completions zsh)

      install -Dm644 resources/niri.desktop -t $out/share/wayland-sessions
      install -Dm644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
      install -Dm755 resources/niri-session $out/bin/niri-session
      install -Dm644 resources/niri{.service,-shutdown.target} -t $out/share/systemd/user
    '';

    meta = {
      description = "Scrollable-tiling Wayland compositor (Patched)";
      homepage = "https://github.com/YaLTeR/niri";
      license = lib.licenses.gpl3Only;
      mainProgram = "niri";
      platforms = lib.platforms.linux;
    };
  }
