#!/bin/sh

usage_header='usage: $(basename "$0") [flags]'
usage=$'\nflags:'

args=""

add_arg() {
	local short="$1"
	local long="$2"
	local varname="$3"
	local help="$4"

	local lusage=""

	if [ "$short" ]; then
		echo -n "-$short"
		lusage="-$short"
	fi

	if [ "$short" -a "$long" ]; then
		echo -n "|"
		lusage="$lusage, "
	fi

	if [ "$long" ]; then
		echo -n "--$long"
		lusage="$lusage--$long"
	else
		long="$short"
	fi

	echo -n ') '

	if [ "$varname" ]; then
		echo -n "$varname="'"$2"; shift; '
		lusage="$lusage $varname"
	else
		echo -n "$(echo "$long" | tr '-' '_')="'"true"; '
	fi
	echo -n 'shift ;;'

	lusage="$lusage: $help"

	usage="$usage"$'\n\t'"$lusage"
}

get_usage() {
	local short="$1"
	local long="$2"
	local varname="$3"
	local help="$4"

	if [ "$short" ]; then
		echo -n "-$short"
	fi

	if [ "$short" -a "$long" ]; then
		echo -n ", "
	fi

	if [ "$long" ]; then
		echo -n "--$long"
	fi

	if [ "$varname" ]; then
		echo -n " $varname"
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
		varname="$(echo "$arg" | cut -c2-)"
		;;
	"<"*">")
		required=$(( required + 1 ))
		usage_header="$usage_header $arg"
		;;
	*)
		if [ "$long" -o "$short" ]; then
			args="$args"$'\n\t'$(add_arg "$short" "$long" "$varname" "$arg")
			usage="$usage"$'\n\t'$(get_usage "$short" "$long" "$varname" "$arg")
			short=""; long=""; varname=""
		else
			usage_header="$usage_header $arg"
		fi
		;;
	esac
done

usage="$usage_header"$'\n'"$usage"

cat << EOF
argparse_usage() { echo "$usage"; };

for arg; do
	case "\$arg" in $args
	-*)
		argparse_usage
		if [ "\$arg" = "-h" -o "\$arg" = "--help" ]; then
			exit 0
		else
			exit 1
		fi
		;;
	*) set -- "\$@" "\$arg"; shift ;;
	esac
done
if [ "\$#" -lt "$required" ]; then argparse_usage; exit 1; fi
EOF
