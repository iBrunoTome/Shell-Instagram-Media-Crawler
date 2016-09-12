#!/bin/bash

# Função para parsear o JSON de acordo com o atributo requisitado
function parseJSON {
    temp=`cat $username'.txt' | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $imageType`
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

# Se o usuário existir realiza o wget, se não existir, remove arquivos e termina a execução
if curl -sSf 'https://www.instagram.com/'$username'/media/' > $username'.txt'; then
	rm -rf ./$username
    mkdir $username
    cd $username;
    mkdir low_resolution
    mkdir thumbnail
    mkdir standard_resolution
    cd ../
    imageType='low_resolution'
	parseJSON
else
	rm -rf ./$username'.txt'
	echo 'Usuário inválido'
fi