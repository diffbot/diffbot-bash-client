#!/usr/bin/env bash
source t/TAP.sh
source Diffbot.sh

[ -z "$DIFFBOT_TOKEN" ] && done_testing '$DIFFBOT_TOKEN is not set'


URL=http://www.huffingtonpost.com/
REPLY=$(diffbot $URL "" api/frontpage)
ok "api/frontpage"
eq   "$(json_path "$REPLY" childNodes 0 childNodes 0 tagName)"          "title"
like "$(json_path "$REPLY" childNodes 0 childNodes 0 childNodes 0)"     "Huffington Post"
eq   "$(json_path "$REPLY" childNodes 1 type)"                          "STORY"


done_testing
