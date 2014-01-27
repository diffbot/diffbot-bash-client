TAP_i=0
done_testing()
{
        echo 1..$TAP_i ${1:+# SKIP $1}
        exit 0
}
ok()
{
        local res=${?#0}
        TAP_i=$((TAP_i+1))
        echo ${res:+not} ok $TAP_i ${1:+- $1}
}
notok()
{
        [ $? -ne 0 ]
        ok "$1"
}
like()
{
        echo "$1" | grep -q -- "$2"
        ok "${3:-match: $2}"
}
eq()
{
        echo "$1" | grep -q -- "^$2$"
        ok "${3:-exact: $2}"
}
