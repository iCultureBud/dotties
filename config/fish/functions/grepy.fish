function grepy
	set count (grep -rnw "$argv[1]" | wc -l)

	if test "$count" -gt 0
		echo Found (set_color red)$count(set_color normal) occurrences:
		grep -rnw "$argv[1]"
		read -l -P "Do you want to replace all items? [y/N] " confirm

		if test "$confirm" = "y"
			read -l -P "Replacement: " new_value
			# echo $new_value
			# echo (string replace "*" "" $argv)
			grep -rl "$argv[1]" | xargs sed -i "s/"(string replace "*" "" $argv[1])"/$new_value/g"
		end
	else
		echo (set_color yellow) Nothing found.
	end
end
