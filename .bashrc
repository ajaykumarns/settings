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

take_screenshot()
{
    if (( $# == 1)); then
        file_name=$1
    else
        file_name="screenshot_$(date +%s).png"
    fi

    if [[ $file_name != *.png ]]; then
        file_name="$file_name.png"
    fi

    file_path="/sdcard/$file_name"
    echo "Storing screenshot from $(selected_model_name) to $file_path"
    adb shell screencap -p "$file_path"
    adb pull "$file_path"
    echo "Locally stored at $(pwd)/$file_name"
}

join_images()
{
    if (( $# != 2 )); then
        echo "Need two arguments to join images"
        return
    fi

    convert $1 $2 +append "joined_$(date +%s).png"
}

alias gt='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git checkout'
alias cls=clear
alias space='df -h | grep /usr/local'
alias ji=join_images
alias ss='take_screenshot'
