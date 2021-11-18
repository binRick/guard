#!/bin/bash
names(){
  ./guard list | jq '.[].id' -Mrc
}

I=wg599
P=12321
H=0.0.0.0
A=1.2.3.4
cmd="./guard create -a $A -e $H:$P $I"
ansi --yellow --italic "$cmd"
