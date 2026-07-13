if command -v get-gh-token >/dev/null
    set -gx GH_TOKEN (get-gh-token)
end
if command -v get-claude-config-dir >/dev/null
    set -gx CLAUDE_CONFIG_DIR (get-claude-config-dir)
end

function __update_dir_env --on-variable PWD
    if command -v get-gh-token >/dev/null
        set -gx GH_TOKEN (get-gh-token)
    end
    if command -v get-claude-config-dir >/dev/null
        set -gx CLAUDE_CONFIG_DIR (get-claude-config-dir)
    end
end
