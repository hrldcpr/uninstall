
for p in $(pkgutil --pkgs | grep -v '^com\.apple\.pkg\.')
do read -p "Delete $p? [yN] " yn
   [ "$yn" != "y" ] && continue

   cd /$(pkgutil --pkg-info $p | awk '/^location: (.*)/ { print $2 }')
   echo $PWD
   
   pkgutil --only-files --files $p | while read f
				     do rm "$f" && echo $f
				     done
   pkgutil --only-dirs --files $p | while read d
				    do rmdir -p "$d" 2>/dev/null && echo $d
				    done
   read -p "Forget $p? [yN] " yn
   [ "$yn" == "y" ] && pkgutil --forget $p
done
