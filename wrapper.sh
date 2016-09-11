#!/bin/bash

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
else
	rm -rf ./$username'.txt'
	echo 'Usuário inválido'
fi