#!/bin/sh
rm -rf deploy/
mkdir deploy
cp -r templates/ deploy/

file="vars/"$1".txt"

while IFS='' read -r line || [[ -n "$line" ]]; do
	# printf '%s\n' "$line"
	name=`echo "$line" | head -n1 | awk '{print $1;}'`
	value=`echo "$line" | awk '{sub($1 FS,"" );print}'`
	find ./deploy -name "*yaml" -type f -print0 | xargs -0 sed -i '' 's|{{'"$name"'}}|'"$value"'|g'
done <"$file"