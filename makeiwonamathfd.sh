#!/usr/bin/env bash
# A simple script to create Iwona Math fds from template.
# Public domain
family=( iwonamath iwonamathc iwonamathl iwonamathlc )
medium=( iwonar iwonacr iwonal iwonacl )
bold=( iwonab iwonacb iwonam iwonacm )
tmpl=( oml_FAMILY_.fd	oms_FAMILY_.fd	omx_FAMILY_.fd	ot1_FAMILY_.fd	ot1_FAMILY_m.fd )
for i in 0 1 2 3; do
    for template in ${tmpl[@]}; do
	file=$(echo $template | sed "s/_FAMILY_/${family[$i]}/")
	cat $template | \
	    sed "s/_FAMILY_/${family[$i]}/" | sed "s/_MEDIUM_/${medium[$i]}/" | \
	    sed "s/_BOLD_/${bold[$i]}/" > $file
    done
done
