apply_git_patch()
{
    echo "Importing patch: [$1]"
    git am "$1"
    git log | head -10
}

export_git_patch()
{
    git format-patch -n HEAD^
}

selected_model_name()
{
    echo "$(adb devices -l | grep $ANDROID_SERIAL | tr -s " " | cut -d ' ' -f 5 | cut -d ':' -f 2)"
}


alias gt='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git checkout'
alias cls=clear
alias space='df -h | grep /usr/local'
