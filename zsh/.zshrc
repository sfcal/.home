export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
export KUBECONFIG=~/.kube/configs/dev.yaml:~/.kube/configs/prod.yaml

ZSH_THEME="robbyrussell"
plugins=(git 1password fluxcd fzf kubectl)

source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/oh-my-zsh.sh

# Alias
alias fd="fdfind"
alias flush-dns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo 'DNS cache flushed'"

# Functions
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# Find In File All, will search and extract zips, pdfs, etc
fifa() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="50%:wrap"
    )"

    local fzf_exit_status="$?"  # Capture the exit status of FZF

    # Check if selection was canceled (exit status 1)
    if [[ "$fzf_exit_status" == "1" ]]; then
        echo "Selection canceled."
        return 1
    fi

    # Continue with processing if a file was selected
    if [[ -n "$file" ]]; then
        local filename=$(basename "$file")
        local name="${filename%.*}"
        local extension="${file##*.}"
        local extract_dir="/tmp/extracts"

        if [[ ! -e "$extract_dir/$name" ]]; then
            mkdir -p "$extract_dir"
            case "$extension" in
                "gz")
                    echo "Extracting $file..."
                    gunzip "--keep" "--stdout" "$file" > "$extract_dir/$name"
                    ;;
                *)
                    echo "$file is not compressed or its compression format is not supported."
                    ;;
            esac
        else
            echo "$name has already been extracted. Skipping extraction."
        fi

        echo "Opening $filename"
        if [[ -e "$extract_dir/$name" ]]; then
            code "$extract_dir/$name"
        else
            code "$file"
        fi
    fi
}

hl() {
 docker run --rm \
        --network host \
        -v "$HOME/.ssh:/home/devops/.ssh" \
        -v "$HOME/.kube:/home/devops/.kube" \
        -v "$PWD:/workspace" \
        -v "$HOME/.home:/home/devops/.home" \
        -v "$HOME/.gitconfig:/home/devops/.gitconfig" \
	    -v "$HOME/.config/sops/age/keys.txt:/home/devops/.config/sops/age/keys.txt" \
        -e ENV="${ENV:-dev}" \
        -e SOPS_AGE_KEY_FILE="/home/devops/.config/sops/age/keys.txt" \
        homelab-exe "$@"
}

# For zoxide
eval "$(zoxide init zsh)"
. "$HOME/.local/bin/env"
