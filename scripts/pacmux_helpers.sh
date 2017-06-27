#!/usr/bin/env bash

ghost(){
  color[0]="yellow"
  color[1]="red"
  color[2]="brightcyan"
  color[3]="brightmagenta"
  echo "#[fg=${color[$1 % 4]},nobold]"
}
