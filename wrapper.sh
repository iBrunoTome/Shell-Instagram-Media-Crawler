#!/bin/bash

################################################################################################
# @author Bruno Tomé
# @email ibrunotome@gmail.com
#
# Repository on GitHub: https://github.com/iBrunoTome/Shell-Instagram-Media-Wrapper
################################################################################################

# Function to download images by urls in txt file
function downloadImages {
    while read url; do
        if [ $maxPics -gt $countDownloaded ]; then
            echo Salvando $url
            wget -q $url
            echo ' '
            ((countDownloaded++))
        else
            break
        fi
    done < ./urls.txt

    # Remove auxiliar txt
    rm -rf ./urlsAux.txt
    rm -rf ./urls.txt
}

# Function to call methots to save pictures
function getPictures {
    ################################################
    # 
    # Thumbnail
    #
    ################################################

    echo Salvando imagens thumbnail
    echo " "

    # Enter inside thumbnail directory
    cd thumbnail

    # Set the type of image to download
    imageType=thumbnail

    # Call the parseJSON function
    parseJSON

    # Call the function to download images
    downloadImages

    # Reset countDownloaded variable
    countDownloaded=0

    ################################################
    # 
    # Low resolution
    #
    ################################################

    echo Salvando imagens low_resolution
    echo " "

    # Enter inside low_resolution directory
    cd ../low_resolution

    # Set the type of image to download
    imageType=low_resolution

    # Call the parseJSON function
    parseJSON

    # Call the function to download images
    downloadImages

    # Reset countDownloaded variable
    countDownloaded=0

    ################################################
    # 
    # Standard resolution
    #
    ################################################

    echo Salvando imagens standard_resolution

    # Enter inside standard_resolution directory
    cd ../standard_resolution

    # Set the type of image to download
    imageType=standard_resolution

    # Call the parseJSON function
    parseJSON

    # Call the function to download images
    downloadImages

    cd ../
}

function checkJSONExists {
    temp=`cat json |
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
        grep -w items`

    echo ${temp}
}

function getNextJSON {
    temp=`cat json |
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
        grep -w id |
        grep _`

    echo ${temp} | awk -F " " '{print $NF}'
}

# Parse JSON string into a txt containing image links
function parseJSON {
    temp=`cat ../json |
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

    	echo ${temp} |
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
			}' > urlsAux.txt

		# Remove blank lines
		sed '/^$/d' urlsAux.txt > urls.txt
}

# Check if parameters doesn't exists, if doesn't, get user from keyboard
if [ $# -eq 0 ]; then
	echo -n 'Digite seu @usuario no Instagram: '
	read username
	username=$(echo $username | sed 's/@//g')
    echo -n 'Quantidade de fotos para baixar: '
    countDownloaded=0
    read maxPics
elif [ $# -eq 1 ]; then
	username=$(echo $1 | sed 's/@//g')
    maxPics=1000000
    countDownloaded=0
elif [ $# -eq 2 ]; then 
    username=$(echo $1 | sed 's/@//g')
    maxPics=$2
    countDownloaded=0
else
    echo 'Quantidade de parâmetros inválida'
    exit
fi

# If user exists do the wget, if not, remove the files and finish the execution
if curl -sSf https://www.instagram.com/$username/media/ > json; then

	rm -rf ./$username
    mkdir $username
    cd $username
    mkdir thumbnail
    mkdir low_resolution
    mkdir standard_resolution

    cd ../

    mv json $username

    cd $username

    getPictures

    size=$(checkJSONExists)
    size=${#size}

    while [ $size -gt 10 ]
    do
        if [ $maxPics -gt $countDownloaded ]; then
            max_id=$(getNextJSON)
            nextUrl='https://www.instagram.com/'$username'/media/?max_id='$max_id
            curl -sSf $nextUrl > json
            getPictures
            size=$(checkJSONExists)
            size=${#size}
        else
            break
        fi
    done

	rm -rf ./json
else
	rm -rf ./json
	echo 'Usuário inválido'
fi