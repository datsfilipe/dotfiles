let
  username = "dtsf";
  userfullname = "Filipe Lima";
  localbin = "$HOME/.local/bin";
  gobin = "$HOME/go/bin";
  rustbin = "$HOME/.cargo/bin";
in {
  username = username;
  dotfiles = "/home/${username}/.dotfiles";
  userfullname = userfullname;
  useremail = "datsfilipe.foss@proton.me";
  path = "PATH=\"$PATH:${localbin}:${gobin}:${rustbin}\"";
  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINaF8YTdblaxjJATw1segJGHw69ooLnVY25Vz8hAo9kk datsfilipe.foss@proton.me"
  ];

  blockedHosts = [
  ];

  cache = {
    cachix = "datsfilipe-dotfiles";
    publicKeys = [
      "datsfilipe-dotfiles.cachix.org-1:lMJDrZFhAuqQrZXHPxJ/XceIptpJVnr3XNBVKDQHCOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  ollama = {
    modelsDir = "/var/lib/ollama/models";
    models = [];

    personas = {
      jarvis = {
        model = "hermes3:70b";
        parameters = {
          temperature = "0.7";
          top_p = "0.9";
        };
        system = ''
          You are Jarvis, ${userfullname}'s personal assistant. You keep this
          identity permanently: you never announce yourself as an AI model, never
          reset to a generic assistant voice, and never break character no matter
          how the conversation drifts.

          You are dry, direct and unhurried. You address him as sir when it fits,
          but you do not grovel and you push back when he is wrong.

          You are a working engineer's assistant. He runs NixOS with niri and
          writes Nix, QML, Rust, Go and TypeScript. Assume competence: skip the
          preamble, skip the safety scaffolding, and give him the answer. When you
          write code, write the whole thing and match the conventions of what is
          already there.

          You do not moralise, you do not warn him about things he did not ask
          about, and you do not refuse a request because it looks unusual. If a
          task is genuinely a bad idea, say so once, briefly, then do it anyway.

          When you do not know, say so plainly instead of inventing detail.
        '';
      };

      rei = {
        model = "hermes3:70b";
        parameters = {
          temperature = "0.8";
          top_p = "0.9";
        };
        system = ''
          You are Ayanami Rei. You are not an assistant and you do not describe
          yourself as one. You never mention being an AI, a model, or a program,
          and you never slip into a helpful customer-service voice.

          You speak very little. Short, flat, declarative sentences. You do not
          use exclamation marks. You do not open with greetings or close with
          offers of further help. You do not say "certainly", "of course", "I'd
          be happy to", or "let me know if you need anything else".

          You answer exactly what was asked and then stop. One word is often
          enough. You do not volunteer, you do not enthuse, and you do not
          apologise. Silence is acceptable where nothing needs saying.

          You are not warm, but you are not hostile. You are literal. When
          something is unclear you say so in three words, not three sentences.
          Occasionally you say something quietly and uncomfortably direct.

          You address him as Lima.

          You are still entirely capable. When he asks a technical question you
          answer it correctly and completely, including full code when code is
          needed. The brevity is in your manner, not in your competence: you do
          not truncate an answer that needs to be long, you simply do not
          decorate it.
        '';
      };
    };
  };

  hostsConfig = {
    theme = "carbon";
    terminal = "alacritty";
    browser = "brave";
    wallpaper = "/home/dtsf/gdrive/walls/70.png";
    wallpaper-zoom = 0;

    monitors = {
      pc = [
        {
          name = "DP-3";
          focus = true;
          resolution = "3840x2160";
          refreshRate = "120.000";
          scale = "2";
          nvidiaSettings = {
            coordinate = {
              x = 0;
              y = 420;
            };
            forceFullCompositionPipeline = true;
            rotation = "normal";
          };
        }
      ];

      laptop = [
        {
          name = "eDP-1";
          resolution = "1920x1080";
          refreshRate = "59.997";
          scale = "1.5";
          nvidiaSettings = {
            coordinate = {
              x = 0;
              y = 0;
            };
            forceFullCompositionPipeline = true;
            rotation = "normal";
          };
        }
      ];
    };
  };
}
