if test (count $argv) -eq 0
    distrobox enter @containerName@
else
    distrobox enter @containerName@ -- $argv
end
