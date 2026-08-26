if test (count $argv) -eq 0
    echo "Usage: cfd <port|url> [cloudflared options]" >&2
    return 2
end

set -l target $argv[1]
if string match --quiet --regex '^[0-9]+$' $target
    set target "http://localhost:$target"
end

cloudflared tunnel --url $target $argv[2..-1]
