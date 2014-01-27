#!/usr/bin/env bash
source t/TAP.sh
source Diffbot.sh

[ -z "$DIFFBOT_TOKEN" ] && done_testing '$DIFFBOT_TOKEN is not set'


URL=http://blog.diffbot.com/diffbots-new-product-api-teaches-robots-to-shop-online/
REPLY=$(diffbot $URL "" v2/article callback willbeignored)
ok "v2/article"
eq   "$(json_path "$REPLY" author)"             "John Davi"
like "$(json_path "$REPLY" title)"              $'Diffbot\u2019s New Product API'
eq   "$(json_path "$REPLY" url)"                "$URL"
eq   "$(json_path "$REPLY" supertags 1 name)"   "Intrusion detection system"
eq   "$(json_path "$REPLY" supertags 2 id)"     "" "only 2 supertags"

URL=http://www.statesymbolsusa.org/National_Symbols/National_flower.html
REPLY=$(diffbot $URL "" v2/image)
ok "v2/image"
eq   "$(json_path "$REPLY" title)"              "The National Flower"
eq   "$(json_path "$REPLY" url)"                "$URL"
like "$(json_path "$REPLY" images 1 caption)"   "Yellow rose"

URL=http://store.livrada.com/collections/all/products/before-i-go-to-sleep
REPLY=$(diffbot $URL "" v2/product)
ok "v2/product"
eq   "$(json_path "$REPLY" products 0 title)"   "Before I Go To Sleep"
eq   "$(json_path "$REPLY" url)"                "$URL"

URL=http://tcrn.ch/Jw7ZKw
REPLY=$(diffbot $URL "" v2/analyze)
ok "v2/analyze"
eq   "$(json_path "$REPLY" type)"               "article"
eq   "$(json_path "$REPLY" author)"             "Sarah Perez"
eq   "$(json_path "$REPLY" url)"                "$URL"
like "$(json_path "$REPLY" resolved_url)"       "techcrunch.com"
i=0; while json_path "$REPLY" images $i url >/dev/null; do i=$((i+1)); done
eq $i 2 "got 2 images"

done_testing
