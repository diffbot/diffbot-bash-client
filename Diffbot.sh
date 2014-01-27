diffbot()
{
	if [ $# -lt 3 ]; then
		echo "Usage: diffbot URL TOKEN API [api_param value ...]" >&2
		exit 1
	fi
	local -a PARAMS=(
		--data-urlencode url="$1"
		--data-urlencode token="${2:-$DIFFBOT_TOKEN}"
	)
	local API="${3#/}"
	shift 3
	# accept any extra params except "format" (API version 1) and
	# "callback" (API version 2) because they set format of result
	while [ $# -ne 0 ]
	do
		if [ "$1" != "format" -a "$1" != "callback" ]; then
			PARAMS+=( --data-urlencode "$1=$2" )
		fi
		shift 2
	done
	local HOST=api.diffbot.com
	if [ "${API:0:4}" == "api/" ]; then
		HOST=www.diffbot.com
		# force "format=json" for API version 1
		PARAMS+=( --data-urlencode "format=json" )
	fi

	curl -s -G "${PARAMS[@]}" "http://$HOST/$API" | JSON.sh -b
}

json_path()
{
	local JSON="$1"
	shift

	local -a JSONPATH
	while [ $# -ne 0 ]
	do
		JSONPATH+=('"\?'"$1"'"\?')
		shift
	done

	local IFS=,
	local RES=$(echo "$JSON" | grep -- "^\[${JSONPATH[*]}\]" | sed 's/^\S\+\s\+//')
	if [ "$RES" == "" ]; then
		return 1
	fi

	if [ "${RES:0:1}" == '"' ]; then
		RES="${RES:1:-1}"
		printf "${RES//%/%%}" | sed 's,\\/,/,g'
	else
		echo "$RES"
	fi
}
