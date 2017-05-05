#!/bin/sh

if [ ! -n "$1" ]; then

echo "svn icon路径为空，本次构建不做替换操作"

else
  cd $new_icon_path
  svn checkout $2
  echo "下拉后icon资源路径为$new_icon_path"
  cd icon
  cp -rf ${new_icon_path}icon/* $new_icon_path
fi



if [ ! -n "$1" ]; then
  echo "下拉后icon资源路径为"

  else
    echo "svn icon路径为空，本次构建不做替换操作"
fi
