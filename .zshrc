#my aliases
alias ll='ls -alh'

# enable the default zsh completions!
autoload -Uz compinit && compinit

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '[%b]'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT=' %F{blue}%2~%f %# ${vcs_info_msg_0_} > '

#get a tree structure of the folders
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

#use python3 instead of default python2 when using python
alias python='python3'

#create virtual environment
alias crenv='python -m venv venv && source venv/bin/activate'
