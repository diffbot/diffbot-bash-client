#!/usr/bin/env bash
source t/TAP.sh
source Diffbot.sh

[ -z "$DIFFBOT_TOKEN" ] && done_testing '$DIFFBOT_TOKEN is not set'


REPLY=$(diffbot 2>&1)
notok "bad usage"
like "$REPLY" Usage

REPLY=$(diffbot http://example.com/ 2>&1)
notok "bad usage"
like "$REPLY" Usage

REPLY=$(diffbot http://example.com/ "" 2>&1)
notok "bad usage"
like "$REPLY" Usage

REPLY=$(diffbot http://example.com/ "" "" 2>&1)
notok "API url point to existing web page"
like "$REPLY" EXPECTED "not a JSON"

REPLY=$(diffbot http://example.com/ "" "nosuch" 2>&1)
notok "API url point to non-existing web page"
like "$REPLY" EXPECTED "not a JSON"

REPLY=$(diffbot http://example.com/ "" "v2/nosuch" 2>&1)
ok "API url point to non-existing api"
like "$(json_path "$REPLY" error)" "Invalid API"
like "$(json_path "$REPLY" errorCode)" 500

REPLY=$(diffbot http://diffbot.com/nosuch "" "v2/article" 2>&1)
ok "URL point to non-existing web page"
like "$(json_path "$REPLY" error)" 404
like "$(json_path "$REPLY" errorCode)" 500      # should be 404?

REPLY=$(diffbot http://diffbot.com/nosuch "BADTOKEN" "v2/article" 2>&1)
ok "Wrong token"
like "$(json_path "$REPLY" error)" "Not authorized"
like "$(json_path "$REPLY" errorCode)" 401


done_testing
