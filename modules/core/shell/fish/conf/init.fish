set -gx CLAUDE_CONFIG_DIR "$HOME/.claude-org"
if command -v get-gh-token >/dev/null
    set -gx GH_TOKEN (get-gh-token)
end

function __update_dir_env --on-variable PWD
    if command -v get-gh-token >/dev/null
        set -gx GH_TOKEN (get-gh-token)
    end
end
