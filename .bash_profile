DEFAULT="\[\033[0m\]"
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
MAGENTA="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
LTGRAY="\[\033[0;37m\]"

GRAY="\[\033[1;30m\]"
LTRED="\[\033[1;31m\]"
LTGREEN="\[\033[1;32m\]"
LTYELLOW="\[\033[1;33m\]"
LTBLUE="\[\033[1;34m\]"
LTMAGENTA="\[\033[1;35m\]"
LTCYAN="\[\033[1;36m\]"
WHITE="\[\033[1;37m\]"

#parse_git_branch() {
#  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[git:\1]/'
#}
function parse_git_branch {
    git rev-parse --git-dir > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        git_status="$(git status 2> /dev/null)"
        branch_pattern="^On branch ([^${IFS}]*)"
        detached_branch_pattern="Not currently on any branch"
        remote_pattern="Your branch is (.*) with"
        diverge_pattern="Your branch and (.*) have diverged"
        untracked_pattern="Untracked files:"
        new_pattern="new file:"
        not_staged_pattern="Changes not staged for commit"

        #files not staged for commit
        if [[ ${git_status} =~ ${not_staged_pattern} ]]; then
            state=" ✔ "
        fi
        # add an else if or two here if you want to get more specific
        # show if we're ahead or behind HEAD
        if [[ ${git_status} =~ ${remote_pattern} ]]; then
            if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
                remote=" ↑ "
            elif [ ${BASH_REMATCH[1]} != "up-to-date"  ]; then
                remote=" ↓ "
            fi
        fi
        #new files
        if [[ ${git_status} =~ ${new_pattern} ]]; then
            remote=" + "
        fi
        #untracked files
        if [[ ${git_status} =~ ${untracked_pattern} ]]; then
            remote=" ✖ "
        fi
        #diverged branch
        if [[ ${git_status} =~ ${diverge_pattern} ]]; then
            remote=" ↕ "
        fi
        #branch name
        if [[ ${git_status} =~ ${branch_pattern} ]]; then
            branch=${BASH_REMATCH[1]}
        #detached branch
        elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
            branch=" NO BRANCH "
        fi

        echo "[${branch}${state}${remote}]"
    fi
    return
}

#return value visualisation
#PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "
PS1="$CYAN\$(parse_git_branch)$RED[\d]$GREEN[\t]$YELLOW[\u@\h]$MAGENTA[\w]\n-> $DEFAULT"

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

## Random aliases
alias whatismyip='dig +short myip.opendns.com @resolver1.opendns.com'
alias ll='ls -alF'
alias tcp_dns='sudo tcpdump -vvv -s 0 -l -n port 53'
alias tcp_full='sudo tcpdump -nnvvXSs 1514'
alias restart_bluetooth="sudo killall coreaudiod"
## alias flush_dns='sudo discoveryutil udnsflushcaches' #going away with OSX 10.10.4
alias flush_dns='sudo killall -HUP mDNSResponder' ## Activate when upgraded to 10.10.4
alias dns_resolvers='scutil --dns'
## Tree
alias tree='tree -C'
alias treed='tree -dC'
alias treef='tree -fsh'
alias src='source ~/py2.7/bin/activate'

## Path Changes
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH:/usr/local/sbin"

# The next line updates PATH for the Google Cloud SDK.
source '/Users/kylekuemmerle/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/kylekuemmerle/google-cloud-sdk/completion.bash.inc'

# Shit I'm testing

function bitch {
  echo "You're a bitch!"
}
