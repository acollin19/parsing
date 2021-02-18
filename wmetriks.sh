#!/bin/bash

# Check if no file is passed to the script
if [ "$#" -ne 1 ]; then
	echo Error: No log file given.
        echo "Usage: ./webmetrics.sh <logfile>"
        exit 1
		
# If file passed DNE
elif [ ! -f $1 ]; then
	echo Error: File "$1" does not exist.
        echo "Usage: ./webmetrics.sh <logfile>"
        exit 2

else 
	# Part 1 : Find each occurence of the word regardless of of how many times the match was found and report the count of the number of lines containing matches.
        echo Number of requests per web browser
        echo Safari,$( grep -o 'Safari' $1 | wc -l )
        echo Firefox,$( grep -o 'Firefox' $1 | wc -l )
        echo Chrome,$( grep -o "Chrome" $1 | wc -l )
        echo "   "

        # Part 2 : Isolate the dates in the files and sort by earliest date. Go through all the dates and display the number of disticnt users for each date.
        echo Number of distinct users per day
        date=$( awk '{print $4}' $1 | sed -e 's/^.//' -e 's/:.*//' | sort -u )

        for distinctDate in $date
        do
                echo $distinctDate,$( grep "$distinctDate" $1 | awk '{print $1}' | sort -u | wc -l )
        done
        echo "   "

	# Part 3 : Isolate the product ID from the file and for each product ID count the number of occurences.Then, rank the top 20 in order of which product ID occurs the most often ( sort by column)
        echo Top 20 popular product requests
        productID=$( awk '{print $7}' $1 | grep '^/product/' | sed -r 's/.{9}//' | sed -e 's/\/.*//' | grep -v '?' | grep  -v '%' )

	echo $productID | tr '[:space:]' '[\n*]' | sort | uniq -c | sort -nr -k1,1 -n -k2,2 | head -20 | awk '{print $2","$1}'
        exit 0


fi
