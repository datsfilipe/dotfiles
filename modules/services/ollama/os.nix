{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.ollama;

  modelfile = name: persona:
    pkgs.writeText "${name}.modelfile" ''
      FROM ${persona.model}
      ${concatStringsSep "\n" (mapAttrsToList (key: value: "PARAMETER ${key} ${value}") persona.parameters)}
      SYSTEM """
      ${persona.system}
      """
    '';
in {
  options.modules.services.ollama = {
    enable = mkEnableOption "Local large language model runtime";

    modelsDir = mkOption {
      type = types.str;
      default = "/var/lib/ollama/models";
      description = ''
        Directory holding model weights. Point this at another disk to move
        them; nothing else needs to change.
      '';
    };

    models = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["hermes3:70b"];
      description = ''
        Models pulled once the service is up. Names come from
        <https://ollama.com/library>.
      '';
    };

    personas = mkOption {
      default = {};
      description = ''
        Named models derived from a base model plus a fixed system prompt, built
        with `ollama create`. The prompt is baked into the model, so it survives
        every new conversation rather than being re-sent by the client.
      '';
      type = types.attrsOf (types.submodule {
        options = {
          model = mkOption {
            type = types.str;
            description = "Base model this persona is built on.";
          };

          system = mkOption {
            type = types.lines;
            description = "System prompt baked into the persona.";
          };

          parameters = mkOption {
            type = types.attrsOf types.str;
            default = {};
            example = {temperature = "0.7";};
            description = "Modelfile PARAMETER entries.";
          };
        };
      });
    };

    contextLength = mkOption {
      type = types.int;
      default = 16384;
      description = "Default context window, in tokens.";
    };

    keepAlive = mkOption {
      type = types.str;
      default = "30m";
      description = "How long an idle model stays resident before being unloaded.";
    };
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      modelsDir = cfg.modelsDir;
      loadModels = cfg.models;

      environmentVariables = {
        OLLAMA_IGPU_ENABLE = "1";
        OLLAMA_CONTEXT_LENGTH = toString cfg.contextLength;
        OLLAMA_KEEP_ALIVE = cfg.keepAlive;
      };
    };

    systemd.services.ollama-personas = mkIf (cfg.personas != {}) {
      description = "Build ollama personas";
      after = ["ollama-model-loader.service" "ollama.service"];
      requires = ["ollama.service"] ++ optional (cfg.models != []) "ollama-model-loader.service";
      wantedBy = ["multi-user.target"];

      environment = {
        OLLAMA_HOST = "${config.services.ollama.host}:${toString config.services.ollama.port}";
        OLLAMA_MODELS = cfg.modelsDir;
        HOME = "/run/ollama-personas";
      };

      path = [config.services.ollama.package];

      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectory = "ollama-personas";
      };

      script = concatStringsSep "\n" (mapAttrsToList (name: persona: ''
          if ollama show ${escapeShellArg persona.model} >/dev/null 2>&1; then
            ollama create ${escapeShellArg name} -f ${modelfile name persona}
          else
            echo "base model ${persona.model} is not pulled yet; skipping persona ${name}"
          fi
        '')
        cfg.personas);
    };
  };
}
