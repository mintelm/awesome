#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run picom --vsync --config ~/.config/picom.conf
run nm-applet
run redshift-gtk
