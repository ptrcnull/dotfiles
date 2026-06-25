#!/bin/sh

usage_header='[flags]'
usage=$'\nflags:'

args=""

add_arg() {
	local short="$1"
	local long="$2"
	local varname="$3"
	local collect="$4"
	local help="$5"

	if [ "$short" ]; then
		echo -n "-$short"
	fi

	if [ "$short" -a "$long" ]; then
		echo -n "|"
	fi

	if [ "$long" ]; then
		echo -n "--$long"
	else
		long="$short"
	fi

	echo -n ') '

	if [ "$collect" ]; then
		echo -n "$varname="'"$2"; shift; '
	elif [ "$varname" ]; then
		echo -n "$varname='$long'; "
	else
		echo -n "$(echo "$long" | tr '-' '_')="'"true"; '
	fi
	echo -n 'shift ;;'
}

get_usage() {
	local short="$1"
	local long="$2"
	local varname="$3"
	local collect="$4"
	local help="$5"

	if [ "$short" ]; then
		echo -n "-$short"
	fi

	if [ "$short" -a "$long" ]; then
		echo -n ", "
	fi

	if [ "$long" ]; then
		echo -n "--$long"
	fi

	if [ "$collect" ]; then
		echo -n " $collect"
	fi

	echo -n ": $help"
}

required=0

for arg; do
	case "$arg" in
	--*)
		long="$(echo "$arg" | cut -c3-)"
		;;
	-*)
		short="$(echo "$arg" | cut -c2-)"
		;;
	=*)
		collect="$(echo "$arg" | cut -c2-)"
		if [ ! "$varname" ]; then
			varname="$collect"
		fi
		;;
	">"*)
		varname="$(echo "$arg" | cut -c2-)"
		;;
	"<"*">")
		required=$(( required + 1 ))
		usage_header="$usage_header $arg"
		;;
	*)
		if [ "$long" -o "$short" ]; then
			args="$args"$'\n\t'$(add_arg "$short" "$long" "$varname" "$collect" "$arg")
			usage="$usage"$'\n\t'$(get_usage "$short" "$long" "$varname" "$collect" "$arg")
			short=""; long=""; varname=""
		else
			usage_header="$usage_header $arg"
		fi
		;;
	esac
done

usage="$usage_header"$'\n'"$usage"

cat << EOF
argparse_usage() { echo "usage: \$(basename "\$1") $usage"; };

for arg; do
	case "\$arg" in $args
	-h|--help) argparse_usage "\$0"; exit 0 ;;
	-*) argparse_usage "\$0"; exit 1 ;;
	*) set -- "\$@" "\$arg"; shift ;;
	esac
done
if [ "\$#" -lt "$required" ]; then argparse_usage "\$0"; exit 1; fi
EOF
