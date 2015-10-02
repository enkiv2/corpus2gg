#!/usr/bin/env zsh

function convert() {
	name="$1"
	tr -d '\r' |
	sed '
		s/{/\n{\n/g;
		s/}/\n}\n/g;
		s/\[/\n\[\n/g;
		s/\]/\n\]\n/g' | 
	grep -v '" *:'|
	grep '[^ \t]' |
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
		}' | grep -v '\[' | grep -v '{' | grep -v '\]' | grep -v '}' |
		sed '
			s/^[ \t]*"//;
			s/" *,* *$//'  |
		tr '\n' ',' |
		sed '
			s/^/'"$name"':=/g;
			s/,$//'
}

for x in "$@" ; do
	if [[ -e "$x" ]] ; then
		echo "# Converted by corpus2gg from $x"
		cat "$x" | convert $(echo "$x" | sed 's/\.json$//;s/^.*\///;s/ /_/g;s/-/_/g;s/^/corpus_/')
		echo
	else
		convert "$x"
	fi
done

