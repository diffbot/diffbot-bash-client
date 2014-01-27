diffbot-bash
============

Diffbot API Bash Client Library 

## Installation

1. Install JSON.sh (see https://github.com/dominictarr/JSON.sh).
2. Download Diffbot.sh into your project directory.

```sh
npm install -g JSON.sh
curl https://raw.github.com/powerman/diffbot-bash/master/Diffbot.sh -o Diffbot.sh
```

## Configuration

To use Diffbot API you'll need "developer token". You can either provide
it in `diffbot` command's second parameter or save it in environment
variable `$DIFFBOT_TOKEN` and use empty second parameter.

## Examples

### Call the Analyze API

```sh
source Diffbot.sh

REPLY=$(diffbot "http://tcrn.ch/Jw7ZKw" "YOUR_TOKEN_HERE" v2/analyze)
echo Author is:       $(json_path "$REPLY" author)
echo Resolved url is: $(json_path "$REPLY" resolved_url)
```

### Call the Article API

```sh
source Diffbot.sh

export DIFFBOT_TOKEN="YOUR_TOKEN_HERE"

URL=http://blog.diffbot.com/diffbots-new-product-api-teaches-robots-to-shop-online/
REPLY=$(diffbot "$URL" "" v2/article timeout 15000)
echo Author is:          $(json_path "$REPLY" author)
echo Second tag name is: $(json_path "$REPLY" supertags 1 name)
```

## Documentation

### Make request to API

```sh
REPLY=$( diffbot URL TOKEN API [API_PARAM1 VALUE1 …] )
```

- `TOKEN` can be empty string if you've set `$DIFFBOT_TOKEN`
- `API` should be path on diffbot.com website like `v2/article` or
  `api/frontpage`
- if error happens while sending request to API or parsing reply it will
  be printed to STDERR, `$REPLY` will be empty and `diffbot` exit status
  will be non-zero
- if API will return error you'll get it in `$REPLY` and can get it using
  `json_path "$REPLY" error` and `json_path "$REPLY" errorCode`

### Process data returned by API

```sh
VALUE=$(json_path "$REPLY" NODE1 …)
```

When asking for non-existing path will exit with non-zero status.

You can simple print contents of `$REPLY` to find out path (`NODE1 …`) to
needed data. For example, if `echo "$REPLY"` will output something like
this:

```
["author"]	"Sarah Perez"
["title"]	"Diffbot Raises $2 Million Angel Round For Web Content Extraction Technology"
["images",0,"primary"]	"true"
["images",0,"url"]	"http://tctechcrunch2011.files.wordpress.com/2012/05/diffbot_9.png?will=300"
["images",1,"caption"]	"npr-v3"
["images",1,"url"]	"http://tctechcrunch2011.files.wordpress.com/2012/05/npr-v3.gif?w=640&h=686"
["date"]	"Thu, 31 May 2012 07:00:00 GMT"
["type"]	"article"
```

then you can get individual values using:

```sh
AUTHOR=$( json_path "$REPLY" author )
SECOND_IMAGE_CAPTION=$( json_path "$REPLY" images 1 caption )
```

or find amount of images by looking for element with absent url:

```sh
i=0
while json_path "$REPLY" images $i url >/dev/null; do
    i=$((i+1))
done
echo Got $i images
```

-Initial commit by Alex Efros-
