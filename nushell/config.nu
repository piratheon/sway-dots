# =========================
# Nushell configuration 
# =========================

# =========================
# Startup Commands
# =========================
# replace welcome banner with fastfetch
$env.config = ($env.config | default {} | merge { show_banner: false })
if (ps | any {|p| $p.name == 'sway'}) { fastfetch --config lite-config } else { fastfetch }

#if not (which fastfetch | is-empty) {
#    fastfetch
#}

# Virtual environment prompt behavior
$env.VIRTUAL_ENV_DISABLE_PROMPT = "1"

# Better man page viewer using vimcat
$env.MANPAGER = "sh -c 'col -bx | vimcat'"

# Done plugin (if available)
$env.__done_min_cmd_duration = "10000"
$env.__done_notification_urgency_level = "low"

# =========================
# Environment setup
# =========================

# Add ~/.local/bin to PATH if not already there
if ("~/.local/bin" | path expand | path exists) and (not ($env.PATH | split row (char esep) | any {|p| $p == ($nu.home-path | path join ".local/bin") })) {
    $env.PATH = ($env.PATH | split row (char esep) | prepend ($nu.home-path | path join ".local/bin") | str join (char esep))
}

# Add ~/.cargo/bin to PATH
if ("~/.cargo/bin" | path expand | path exists) and (not ($env.PATH | split row (char esep) | any {|p| $p == ($nu.home-path | path join ".cargo/bin") })) {
    $env.PATH = ($env.PATH | split row (char esep) | append ($nu.home-path | path join ".cargo/bin") | str join (char esep))
}

# Add ~/projects/.bin to PATH
if ("~/projects/.bin" | path expand | path exists) and (not ($env.PATH | split row (char esep) | any {|p| $p == ($nu.home-path | path join "projects/.bin") })) {
    $env.PATH = ($env.PATH | split row (char esep) | append ($nu.home-path | path join "projects/.bin") | str join (char esep))
}

# Add ~/Applications/1.bin to PATH
if ("~/Applications/1.bin" | path expand | path exists) and (not ($env.PATH | split row (char esep) | any {|p| $p == ($nu.home-path | path join "Applications/1.bin") })) {
    $env.PATH = ($env.PATH | split row (char esep) | append ($nu.home-path | path join "Applications/1.bin") | str join (char esep))
}

# Add ~/Applications/depot_tools to PATH
if ("~/Applications/depot_tools" | path expand | path exists) and (not ($env.PATH | split row (char esep) | any {|p| $p == ($nu.home-path | path join "Applications/depot_tools") })) {
    $env.PATH = ($env.PATH | split row (char esep) | append ($nu.home-path | path join "Applications/depot_tools") | str join (char esep))
}

# =========================
# Custom Definitions
# =========================

# Backup a file: backup <filename>
def backup [filename: string] {
    cp $filename $"($filename).bak"
}

# =========================
# Aliases
# =========================

# eza/ls aliases
alias ls = eza --icons --group-directories-first
alias ll = eza -la --icons --group-directories-first
alias la = eza -a --icons --group-directories-first
alias lt = eza -aT --icons --group-directories-first
alias l. = ls -a | where name =~ '^\.'

# Navigation
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..
alias ...... = cd ../../../../..

# Replacements
alias cat = vimcat
alias grep = rg
alias top = btop
alias yay = paru

# Pacman/Arch aliases
alias grubup = sudo update-grub
alias fixpacman = sudo rm /var/lib/pacman/db.lck
alias rmpkg = sudo pacman -Rdd
# Note: 'fish_update_completions' in 'upd' will fail. You may want to remove it from the command.
alias upd = ^sh -c 'sudo reflector --latest 5 --age 2 --fastest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && yay -Syu --noconfirm --cleanafter && sudo flatpak update && sudo ncu -g -u'
alias big = ^sh -c "expac -H M '%m\t%n' | sort -h | nl"
alias gitpkg = ^sh -c 'pacman -Q | grep -i "\-git" | wc -l'
alias mirror = sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist
alias mirrord = sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist
alias mirrors = sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist
alias mirrora = sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist
alias apt = man pacman
alias apt-get = man pacman
alias cleanup = ^sh -c 'sudo pacman -Rns (pacman -Qtdq)' # Use sh -c for subshell
alias jctl = journalctl -p 3 -xb
alias rip = ^sh -c "expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"


# Other tool aliases
alias gnedit = gnome-text-editor
alias tarnow = tar -acf
alias untar = tar -zxvf
alias wget = wget -c
alias psmem = ^sh -c 'ps auxf | sort -nr -k 4'
alias psmem10 = ^sh -c 'ps auxf | sort -nr -k 4 | head -10'
alias hw = hwinfo --short
alias n = nvim -O
alias helpme = curl cht.sh --shell
alias please = sudo
alias tb = nc termbin.com 9999
alias docker-stop-all = docker stop (^docker ps -a -q)

# =========================
# Editor and tools
# =========================

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.PAGER = "bat"

# =========================
# Additional Tools (optional)
# =========================

# Disable telemetry for various tools
$env.DENO_NO_UPDATE_CHECK = "1"
$env.DENO_NO_TELEMETRY = "1"
#$env.NO_COLOR = "1"

# =========================
# End of config
# =========================
