#!/usr/bin/env bash
# Thomas Hackl, thackl@lim4.de, 2018-03-26

usage(){
cat <<EOF
Usage:
  treemmer-animate tree.nwk

Create a animation (gif, etc) of a tree being trimmed by treemmer
EOF
exit 0;
}

[[ $# -eq 0 ]] && usage

TREEMMER=~/software/Treemmer/Treemmer.py
TREEMMER_OPT="-mc 5 -lm ../treemmer-lm.csv"
TREE=$1
FROM=$( grep -o "," $TREE | wc -l )
BY=20
TO=$BY

mkdir -p frames
(cd frames
 X=$FROM
 ln -sf ../$TREE tree.nwk_trimmed_tree_X_$X
 ln -sf tree.nwk_trimmed_tree_X_$X tree.nwk
 while [ $X -gt $TO ]; do
     X=$(($X-$BY)) 
     python $TREEMMER $TREEMMER_OPT -X $X tree.nwk
     ln -sf tree.nwk_trimmed_tree_X_$X tree.nwk
 done;
 rm tree.nwk
)


