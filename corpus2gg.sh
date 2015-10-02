#!/usr/bin/env zsh
name="$1"
if [[ -e "$1" ]] ; then
	cat "$1" | $0 $(echo "$1" | sed 's/\.json$//;s/^.*\///;s/ /_/g')
	exit
fi
awk '
	/\[/ { 
		capture=1
	} 
	/\]/ { 
		capture=0 
	} 
	{ 
		if(capture) { 
			print $0 
		} 
	}' | grep -v '\[' | grep -v '{' | 
	sed '
		s/^[ \t]*"//;
		s/",*$//'  |
	tr '\n' ',' |
	sed '
		s/^/'"$name"':=/g;
		s/,$//'


