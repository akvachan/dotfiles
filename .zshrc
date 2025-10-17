#!/usr/bin/zsh

# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Define key bindings.
z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
z4h bindkey redo Option+/            # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# Custom functions
#
# Define a widget that opens nvim in the current directory
function nvim_cwd() {
  BUFFER="nvim ."
  zle accept-line
}
zle -N nvim_cwd
bindkey '^O' nvim_cwd

# Function to cd into projects
function fzf-proj() {
  local selected_dir
  selected_dir=$(find ~/Development -maxdepth 4 -type d \( -name ".venv" -o -name ".git" -o -name "node_modules" \) -prune -o -type d -print 2>/dev/null \
    | fzf --prompt="Select directory: " --height=40%)
  if [[ -n "$selected_dir" ]]; then
    BUFFER="cd \"$selected_dir\""
    zle accept-line
  else
    zle push-input -w
    zle clear-screen -w
  fi
}
zle -N fzf-proj
bindkey '^G' fzf-proj

# Function to fg into last halted process 
function fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

function ghcs() {
	FUNCNAME="$funcstack[1]"
	TARGET="shell"
	local GH_DEBUG="$GH_DEBUG"
	local GH_HOST="$GH_HOST"

	read -r -d '' __USAGE <<-EOF
	Wrapper around \`gh copilot suggest\` to suggest a command based on a natural language description of the desired output effort.
	Supports executing suggested commands if applicable.

	USAGE
	 $FUNCNAME [flags] <prompt>

	FLAGS
	 -d, --debug           Enable debugging
	 -h, --help            Display help usage
	     --hostname        The GitHub host to use for authentication
	 -t, --target target   Target for suggestion; must be shell, gh, git
	                       default: "$TARGET"

	EXAMPLES

	- Guided experience
	 $ $FUNCNAME

	- Git use cases
	 $ $FUNCNAME -t git "Undo the most recent local commits"
	 $ $FUNCNAME -t git "Clean up local branches"
	 $ $FUNCNAME -t git "Setup LFS for images"

	- Working with the GitHub CLI in the terminal
	 $ $FUNCNAME -t gh "Create pull request"
	 $ $FUNCNAME -t gh "List pull requests waiting for my review"
	 $ $FUNCNAME -t gh "Summarize work I have done in issues and pull requests for promotion"

	- General use cases
	 $ $FUNCNAME "Kill processes holding onto deleted files"
	 $ $FUNCNAME "Test whether there are SSL/TLS issues with github.com"
	 $ $FUNCNAME "Convert SVG to PNG and resize"
	 $ $FUNCNAME "Convert MOV to animated PNG"
	EOF

	local OPT OPTARG OPTIND
	while getopts "dht:-:" OPT; do
		if [ "$OPT" = "-" ]; then     # long option: reformulate OPT and OPTARG
			OPT="${OPTARG%%=*}"       # extract long option name
			OPTARG="${OPTARG#"$OPT"}" # extract long option argument (may be empty)
			OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
		fi

		case "$OPT" in
			debug | d)
				GH_DEBUG=api
				;;

			help | h)
				echo "$__USAGE"
				return 0
				;;

			hostname)
				GH_HOST="$OPTARG"
				;;

			target | t)
				TARGET="$OPTARG"
				;;
		esac
	done

	# shift so that $@, $1, etc. refer to the non-option arguments
	shift "$((OPTIND-1))"

	TMPFILE="$(mktemp -t gh-copilotXXXXXX)"
	trap 'rm -f "$TMPFILE"' EXIT
	if GH_DEBUG="$GH_DEBUG" GH_HOST="$GH_HOST" gh copilot suggest -t "$TARGET" "$@" --shell-out "$TMPFILE"; then
		if [ -s "$TMPFILE" ]; then
			FIXED_CMD="$(cat $TMPFILE)"
			print -s -- "$FIXED_CMD"
			echo
			eval -- "$FIXED_CMD"
		fi
	else
		return 1
	fi
}

function ghce() {
	FUNCNAME="$funcstack[1]"
	local GH_DEBUG="$GH_DEBUG"
	local GH_HOST="$GH_HOST"

	read -r -d '' __USAGE <<-EOF
	Wrapper around \`gh copilot explain\` to explain a given input command in natural language.

	USAGE
	 $FUNCNAME [flags] <command>

	FLAGS
	 -d, --debug      Enable debugging
	 -h, --help       Display help usage
	     --hostname   The GitHub host to use for authentication

	EXAMPLES

	# View disk usage, sorted by size
	$ $FUNCNAME 'du -sh | sort -h'

	# View git repository history as text graphical representation
	$ $FUNCNAME 'git log --oneline --graph --decorate --all'

	# Remove binary objects larger than 50 megabytes from git history
	$ $FUNCNAME 'bfg --strip-blobs-bigger-than 50M'
	EOF

	local OPT OPTARG OPTIND
	while getopts "dh-:" OPT; do
		if [ "$OPT" = "-" ]; then     # long option: reformulate OPT and OPTARG
			OPT="${OPTARG%%=*}"       # extract long option name
			OPTARG="${OPTARG#"$OPT"}" # extract long option argument (may be empty)
			OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
		fi

		case "$OPT" in
			debug | d)
				GH_DEBUG=api
				;;

			help | h)
				echo "$__USAGE"
				return 0
				;;

			hostname)
				GH_HOST="$OPTARG"
				;;
		esac
	done

	# shift so that $@, $1, etc. refer to the non-option arguments
	shift "$((OPTIND-1))"

	GH_DEBUG="$GH_DEBUG" GH_HOST="$GH_HOST" gh copilot explain "$@"
}

command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

# z 
. /opt/homebrew/etc/profile.d/z.sh

# Custom aliases
alias zshrc="nvim ~/.zshrc"
alias asrc="nvim ~/.config/aerospace/aerospace.toml"
alias nvimrc="nvim ~/.config/nvim/init.lua"
alias kittyrc="nvim ~/.config/kitty/kitty.conf"
alias brewrc="nvim ~/.config/brew/Brewfile"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias icat="kitten icat"
alias ssh="kitten ssh"
alias ttd="tt -csv >> ~/.wpm.csv"
alias quote="curl http://api.quotable.io/random|jq '[.text=.content|.attribution=.author]'|tt -quotes -"
alias qwen="llama-cli -m ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_Qwen2.5-Omni-7B-Q4_K_M.gguf"
alias qwen-server="llama-server -m ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_Qwen2.5-Omni-7B-Q4_K_M.gguf --mmproj ~/Library/Caches/llama.cpp/unsloth_Qwen2.5-Omni-7B-GGUF_mmproj-F16.gguf"
alias phi="llama-cli -m ~/Library/Caches/llama.cpp/unsloth_Phi-4-reasoning-plus-GGUF_Phi-4-reasoning-plus-Q4_K_M.gguf"
alias phi-server="llama-server -m ~/Library/Caches/llama.cpp/unsloth_Phi-4-reasoning-plus-GGUF_Phi-4-reasoning-plus-Q4_K_M.gguf"
alias l="ls -la"
alias suggest="gh copilot suggest"
alias explain="gh copilot explain"
alias rnotes="cd '$HOME/Library/CloudStorage/GoogleDrive-arsenii@kvachan.com/My Drive/Obsidian' && nvim ."

# Custom exports
export VISUAL='nvim'
export EDITOR='nvim'
export PATH=$HOME/Development/Flutter/SDK/flutter/bin:$PATH
export PATH="/Users/arseniikvachan/.rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
