#!/bin/bash

if curl -sSf 'https://www.instagram.com/'$1'/media/' > $1'.txt'; then
	rm -rf ./$1
    mkdir $1
else
	rm -rf ./$1'.txt'
	echo 'Usuário inválido'
fi