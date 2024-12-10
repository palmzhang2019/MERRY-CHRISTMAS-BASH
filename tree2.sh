#!/bin/bash
#!/bin/bash

# Step 1: 输入用户的姓名
user_name=$(osascript <<EOF
set response to text returned of (display dialog "input your name please：" default answer "" buttons {"OK"} default button "OK")
return response
EOF
)

# Step 2: 选择用户的性别
user_gender=$(osascript <<EOF
set response to button returned of (display dialog "input your gender please：" buttons {"Male", "Female"} default button "Male")
return response
EOF
)

# Step 3: 选择用户使用的语言
user_language=$(osascript <<EOF
set response to (choose from list {"English", "简体中文", "繁体中文", "Tiếng Việt", "Bahasa Indonesia", "日本語", "বাংলা ভাষা"} with prompt "select your language please：")
if response is false then
    return "未选择语言"
else
    return response as text
end if
EOF
)

# Step 4: 输入用户拥有的品质
user_quality=$(osascript <<EOF
set response to text returned of (display dialog "input your personality" default answer "" buttons {"OK"} default button "OK")
return response
EOF
)


trap "tput reset; tput cnorm; exit" 2
clear
tput civis
lin=2
col=$(($(tput cols) / 2))
c=$((col-1))
color=0
tput setaf 2; tput bold

# Tree
for ((i=1; i<20; i+=2))
{
    tput cup $lin $col
    for ((j=1; j<=i; j++))
    {
        echo -n \*
    }
    let lin++
    let col--
    sleep 0.05 
}

tput sgr0; tput setaf 3

# Trunk
for ((i=1; i<=2; i++))
{
    tput cup $((lin++)) $c
    echo 'mWm'
}
new_year=$(date +'%Y')
let new_year++
tput setaf 0; tput bold
tput setaf 1; tput bold; 
tput cup $lin $((c - 6)); echo "MERRY CHRISTMAS"
tput cup $((lin + 1)) $((c - 13)); echo And lots of Happiness in $new_year
let c++

# Star positions
declare -a star_row star_col

# Generate stars
generate_stars() {
    for ((s=1; s<=10; s++)) {
        # Star row: Ensure stars stay below `show_message` content
        min_row=3                # Start generating stars from row 3
        max_row=$((lin - 5))     # The maximum row for stars
        star_row[$s]=$((RANDOM % (max_row - min_row + 1) + min_row))  # Keep stars within safe rows

        if ((RANDOM % 2 == 0)); then
            # Left side: columns far left of the tree
            star_col[$s]=$((c - 12 - RANDOM % 10))
        else
            # Right side: columns far right of the tree
            star_col[$s]=$((c + 12 + RANDOM % 10))
        fi
        tput setaf $((RANDOM % 8)); tput bold
        tput cup ${star_row[$s]} ${star_col[$s]}
        echo "*"
    }
}

# Remove stars
remove_stars() {
    for ((s=1; s<=10; s++)) {
        tput cup ${star_row[$s]} ${star_col[$s]}
        echo " "  # Clear the star
    }
}

# Show message after 5 seconds
show_message() {
    if [ "$user_gender" = "Female" ]; then
        title="Miss"
    else
        title="Mr"
    fi
    sleep 1
    tput cup 0 $((c - 16))  # Position message at the top center
    tput setaf 2; tput bold
    echo "$title $user_name, You have a $user_quality."
    tput cup 1 $((c - 30))
    if [ "$user_language" = "简体中文" ]; then
        echo "非常开心和你一起工作，祝你健康，快乐，平安，幸福。"
    elif [ "$user_language" = "繁体中文" ]; then
        echo "非常開心和你一起工作，祝你健康，快樂，平安，幸福。"
    elif [ "$user_language" = "English" ]; then
        echo "I’m very happy to work with you. Wishing you health, happiness, peace, and joy."
    elif [ "$user_language" = "日本語" ]; then
        echo "一緒に仕事ができて本当に嬉しいです。健康で、幸せで、平和で、楽しい日々をお過ごしください。"
    elif [ "$user_language" = "Tiếng Việt" ]; then
        echo "Tôi rất vui khi được làm việc cùng bạn. Chúc bạn sức khỏe, hạnh phúc, bình an và niềm vui."
    elif [ "$user_language" = "Bahasa Indonesia" ]; then
        echo "Saya sangat senang bekerja bersama Anda. Semoga Anda sehat, bahagia, damai, dan sejahtera."
    elif [ "$user_language" = "বাংলা ভাষা" ]; then
        echo "তোমার সঙ্গে কাজ করতে পেরে আমি খুব খুশি। তোমার সুস্বাস্থ্য, সুখ, শান্তি এবং সমৃদ্ধি কামনা করি।"
    else
        echo "语言未被识别。"
    fi
}

show_message &

# Lights and decorations
generate_stars  # Generate initial stars

while true; do
    remove_stars   # Remove stars
    sleep 0.2      # Wait for 0.2 seconds (off state)
    generate_stars # Regenerate stars
    sleep 0.3      # Wait for 0.3 seconds (on state)

    for ((i=1; i<=35; i++)) {
        li=$((RANDOM % 9 + 3))
        start=$((c-li+2))
        co=$((RANDOM % (li-2) * 2 + 1 + start))
        tput setaf $color; tput bold   # Switch colors
        tput cup $li $co
        echo o
        color=$(((color+1)%8))

        # Flashing text
        sh=-2
        for l in H a p p i n e s s
        do
            tput cup $((lin+1)) $((c+sh))
            echo $l
            let sh++
            sleep 0.01
        done
    }
done
