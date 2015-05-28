
for p in $(pkgutil --pkgs | grep -v '^com\.apple\.')
do read -p "Delete $p? [ydN] " delete
   [ "$delete" != "y" ] && [ "$delete" != "d" ] && continue

   DIR="/$(pkgutil --pkg-info $p | perl -ne '/^location: (.*)/ && print $1')"
   echo cd '"'$DIR'"'
   [ "$delete" == "y" ] && cd "$DIR"

   pkgutil --only-files --files $p | while read f
   do echo rm '"'$f'"'
      [ "$delete" == "y" ] && rm "$f"
   done

   pkgutil --only-dirs --files $p | while read d
   do echo rmdir -p '"'$d'"'
      [ "$delete" == "y" ] && rmdir -p "$d" 2>/dev/null
   done

   if [ "$delete" == "y" ]
   then read -p "Forget $p? [yN] " forget
        [ "$forget" == "y" ] && pkgutil --forget $p
   fi
done
