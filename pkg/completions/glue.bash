# shellcheck shell=bash

_glue_get_wd() {
	while [[ ! -f "glue.toml" && "$PWD" != / ]]; do
		cd ..
	done

	if [[ $PWD == / ]]; then
		return
	fi

	printf "%s" "$PWD"
}

_glue() {
	local -ra listPreSubcommandOptions=(--help -h --version -v)
	local -ra listSubcommands=(sync list run-action run-task run-file)

	local -ra listSyncOptions=(--all --reverse)
	local -ra listListOptions=(--force --color)
	local -ra listRunActionOptions=(--force)

	local -r currentWord="${COMP_WORDS[COMP_CWORD]}"

	# TODO: to support nested subcommands, we should pop everything before the subcommand, and pass
	# it into a function similar to this
	# Loop over 'COMP_WORDS', and extract first subcommand found (nested subcommands is NOT supported)
	# ':1' is added so the first element (command name) in COMP_WORDS is skipped (ex. ls)
	local subcommand=
	local -i subcommandIndex=1
	for word in "${COMP_WORDS[@]:1}"; do
		case "$word" in
			-*) ;;
			*)
				subcommand="$word"
				break
				;;
		esac

		(( subcommandIndex++ ))
	done

	# If the current word index is less than the subcommand index, it means we are completing something before
	# the subcommand. This can happen if we are completing an option first (before completing a subcommand)
	if (( COMP_CWORD < subcommandIndex )); then
		mapfile -t COMPREPLY < <(IFS=' ' compgen -W "${listPreSubcommandOptions[*]}" -- "$currentWord")

	# If the current word index is the same as the subcommand index, it means we are completing the subcommand
	elif (( COMP_CWORD == subcommandIndex )); then
		# Sometimes, Bash thinks the word we are completing is the subcommand, even though it doesn't look like it
		# For example, if after our cursor, is a space, and then the subcommand, it will still think we are completing
		# the subcommand, instead of options that precede the subcommand
		# To remedy this, we get the index of the subcommand from the currently completed line. If our cursor (COMP_POINT)
		# is before it, then the aforementioned caveat applies, and we only try to complete options before the subcommand
		# We add a space before '$subcommand' to ensure it only matches real subcommands (which always have a preceding space)
		subcommand=" $subcommand"
		local rest="${COMP_LINE#*$subcommand}"
		local stringIndexOfSubcommand=$((${#COMP_LINE} - ${#rest} - ${#subcommand}))
		if (( COMP_POINT <= stringIndexOfSubcommand )); then
			mapfile -t COMPREPLY < <(IFS=' ' compgen -W "${listPreSubcommandOptions[*]}" -- '')
			return
		fi

		subcommand="${subcommand# }"

		# Now, we are really completing a subcommand. Add 'listPreSubcommandOptions' because this branch is ran even when the
		# $currentWord is empty. Of course, when we enter in a subcommand to be completed, none of the 'listPreSubcommandOptions'
		# will show because they all start with a hyphen
		mapfile -t COMPREPLY < <(IFS=' ' compgen -W "${listPreSubcommandOptions[*]} ${listSubcommands[*]}" -- "$currentWord")

	# If the current word index is greater than the subcommand index, it means that we have already completed the subcommand and
	# we are completion options for a particular subcommand
	elif (( COMP_CWORD > subcommandIndex )); then
		case "$subcommand" in
			sync)
				;;
			list)
				;;
			run-action)
				local glueWd
				glueWd="$(_glue_get_wd)"
				mapfile -td $'\0' glueFiles < <(find "$glueWd"/.glue/actions/{,auto/} -ignore_readdir_race -mindepth 1 -maxdepth 1 -type f -printf '%f\0' 2>/dev/null)
				mapfile -t COMPREPLY < <(IFS=' ' compgen -W "${glueFiles[*]}" -- "$currentWord")
				;;
			run-task)
				local glueWd
				glueWd="$(_glue_get_wd)"
				mapfile -td $'\0' glueFiles < <(find "$glueWd"/.glue/tasks/{,auto/} -ignore_readdir_race -mindepth 1 -maxdepth 1 -type f -printf '%f\0' 2>/dev/null)
				mapfile -t COMPREPLY < <(IFS=' ' compgen -W "${glueFiles[*]}" -- "$currentWord")
				;;
			run-file)
				;;
		esac
	fi

	return 0
}

complete -F _glue glue
