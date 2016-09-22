#!/bin/bash

# Function to download images by urls in txt file
function downloadImages {
	while read url ; do
		echo Salvando $url
		wget -q $url
		echo ' '
	done < ./urls.txt

	# Remove auxiliar txt
	rm -rf ./urlsAux.txt
	rm -rf ./urls.txt
}

# Parse JSON string into a txt containing image links
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
			}' > urlsAux.txt

		# Remove blank lines
		sed '/^$/d' urlsAux.txt > urls.txt
}

# Check if parameters doesn't exists, if doesn't, get user from keyboard
if [ $# -eq 0 ]; then
	echo -n 'Digite seu @usuario no Instagram: '
	read username
	username=$(echo $username | sed 's/@//g')
else # Fill the user like first parameter 
	username=$(echo $1 | sed 's/@//g')
fi

# If user exists do the wget, if not, remove the files and finish the execution
if curl -sSf https://www.instagram.com/$username/media/ > $username.txt; then

	rm -rf ./$username
    mkdir $username
    cd $username
    mkdir thumbnail
    mkdir low_resolution
    mkdir standard_resolution

    ################################################
    # 
    # Thumbnail
    #
    ################################################

    # Enter inside thumbnail directory
    cd thumbnail

    # Set the type of image to download
    imageType=thumbnail

    # Call the parseJSON function
	parseJSON

	# Call the function to download images
	downloadImages

	echo " "

	################################################
    # 
    # Low resolution
    #
    ################################################

    # Enter inside low_resolution directory
    cd ../low_resolution

    # Set the type of image to download
    imageType=low_resolution

    # Call the parseJSON function
	parseJSON

	# Call the function to download images
	downloadImages

	echo " "

	################################################
    # 
    # Standard resolution
    #
    ################################################

    # Enter inside standard_resolution directory
    cd ../standard_resolution

    # Set the type of image to download
    imageType=standard_resolution

    # Call the parseJSON function
	parseJSON

	# Call the function to download images
	downloadImages

	cd ../../

	rm -rf ./$username.txt
else
	rm -rf ./$username.txt
	echo 'Usuário inválido'
fi