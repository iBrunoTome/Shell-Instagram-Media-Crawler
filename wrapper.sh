#!/bin/bash

# Função para parsear o JSON de acordo com o atributo requisitado
function parseJSON {
    temp=`cat ../../$username.txt |
    	sed 's/\\\\\//\//g' |
    	sed 's/[{}]//g' |
    	awk -v k="text" '
    		{
    				n=split($0,a,",");
    				for (i=1; i<=n; i++) 
    					print a[i]
    		}' | 
    	sed 's/\"\:\"/\|/g' |
    	sed 's/[\,]/ /g' |
    	sed 's/\"//g' |
    	grep -w $imageType`

    	echo ${temp##*|} |
    	sed 's/thumbnail: //g' |
    	sed 's/low_resolution: //g' |
    	sed 's/standard_resolution: //g' |
    	sed 's/images: //g' |
    	sed 's/videos: //g' |
    	sed 's/url: //g' |
    	sed 's/\?ig_cache_key[^ .]*\.2//g' |
    	sed 's/\.c / /g' |
    	sed 's/\.l / /g' |
    	awk '
			{ 
			  split($0, chars, " ")
			  for (i=1; i <= length($0); i++) {
			    printf("%s\n", chars[i])
			  }
			}' > $imageType.txt

		while read url ; do
		    wget -nc $url
		done < ./$imageType.txt

		rm -rf ./$imageType.txt
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
if curl -sSf https://www.instagram.com/$username/media/ > $username'.txt'; then
	rm -rf ./$username
    mkdir $username
    cd $username
    mkdir thumbnail
    mkdir low_resolution
    mkdir standard_resolution

    cd thumbnail
    imageType=thumbnail
	parseJSON

	echo " "

	cd ../low_resolution
	imageType=low_resolution
	parseJSON

	echo " "

	cd ../standard_resolution
	imageType=standard_resolution
	parseJSON

	cd ../../

	rm -rf ./$username.txt
else
	rm -rf ./$username.txt
	echo 'Usuário inválido'
fi