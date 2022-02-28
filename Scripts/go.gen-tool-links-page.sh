grep label *md|cut -f 2- -d ":"|grep -v "All tools"| cut -f 2- -d ")"|sed "s/\[/\n\[/g"|sort -u
