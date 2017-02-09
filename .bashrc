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

select_model()
{
    mapfile -t devices < <(adb devices -l)
    len=$(expr ${#devices[@]} - 1)
    if ((len > 0)); then
        echo "Found the following devices: "
        for (( i=1; i<len; ++i));
        do
            echo "    [$i] ${devices[$i]}"
        done

        printf "Enter number to select device: "
        read selection

        if [[ $selection = *[[:digit:]]* ]]; then
            export ANDROID_SERIAL=$(echo "${devices[$selection]}" | cut -d " " -f 1)
            echo "Selected '$(echo ${devices[$selection]} | cut -d " " -f 5 | cut -d ":" -f 2)' as the target device"
            echo "Export ANDROID_SERIAL=$ANDROID_SERIAL"
        else
            echo "Not a valid number: $selection"
        fi
    else
        echo "No devices attached"
    fi
}
export MYPS='$(echo -n "${PWD/#$HOME/~}" | awk -F "/" '"'"'{
if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF;
else if (NF>3) print $1 "/" $2 "/.../" $NF;
else print $1 "/.../" $NF; }
else print $0;}'"'"')'
PS1='$(selected_model_for_bash) \[\033[32m\]$(eval "echo ${MYPS}")\[\033[0m\]$ '
#add bin folder to path
if [[ -n $(echo "$PATH" | grep -q "$HOME/bin" && echo "yes") ]]; then
    export PATH=$PATH:$HOME/bin
fi

alias gt='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git checkout'
alias cls=clear
alias space='df -h | grep /usr/local'
alias ji=join_images
alias ss='take_screenshot'
alias sd=select_model
