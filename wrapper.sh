#!/bin/bash

function jsonval {
    temp=`cat $username'.txt' | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop`
    echo ${temp##*|}
}

# Checa se não existe parâmetros, se não houver, pede a entrada via teclado
if [ $# -eq 0 ]; then
	echo -n 'Digite seu @usuario no Instagram: '
	read username
	username=$(echo $username | sed 's/@//g')
else # Preenche o usuário como 1º parâmetro 
	username=$(echo $1 | sed 's/@//g')
fi

if curl -sSf 'https://www.instagram.com/'$username'/media/' > $username'.txt'; then
	rm -rf ./$username
    mkdir $username
    cd $username;
    mkdir low_resolution
    mkdir thumbnail
    mkdir standard_resolution
    cd ../
    prop='low_resolution'
	jsonval
else
	rm -rf ./$username'.txt'
	echo 'Usuário inválido'
fi