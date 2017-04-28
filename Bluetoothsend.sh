#!/bin/bash
x=`hcitool scan`
x=${x:14}
x=(${x// / })
size_x=${#x[@]}
for ((i=1;i<size_x;i+=2));do
echo  ${x[i]}
done
export X=$x
echo  "x=$x"
