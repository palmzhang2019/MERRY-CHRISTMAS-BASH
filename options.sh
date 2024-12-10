#!/bin/bash

# Step 1: 输入用户的姓名
user_name=$(osascript <<EOF
set response to text returned of (display dialog "请输入您的姓名：" default answer "" buttons {"OK"} default button "OK")
return response
EOF
)

# Step 2: 选择用户的性别
user_gender=$(osascript <<EOF
set response to button returned of (display dialog "请选择性别：" buttons {"Male", "Female"} default button "Male")
return response
EOF
)

# Step 3: 选择用户使用的语言
user_language=$(osascript <<EOF
set response to (choose from list {"English", "简体中文", "繁体中文", "越南语", "印度尼西亚语", "日语"} with prompt "请选择您使用的语言：")
if response is false then
    return "未选择语言"
else
    return response as text
end if
EOF
)

# Step 4: 输入用户拥有的品质
user_quality=$(osascript <<EOF
set response to text returned of (display dialog "请输入您拥有的一项品质：" default answer "" buttons {"OK"} default button "OK")
return response
EOF
)

# 输出用户的选择结果
echo "用户信息如下："
echo "姓名: $user_name"
echo "性别: $user_gender"
echo "语言: $user_language"
echo "品质: $user_quality"

# 根据选择执行操作
echo "感谢您输入信息，$user_name"
