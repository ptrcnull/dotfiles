# URL Tools
# Adds handy command line aliases useful for dealing with URLs
#
# Taken from:
# https://ruslanspivak.com/2010/06/02/urlencode-and-urldecode-from-a-command-line/
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/urltools

if command -v node >/dev/null; then
    alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'
    alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'
elif command -v python3 >/dev/null; then
    alias urlencode='python3 -c "import sys; del sys.path[0]; import urllib.parse as up; print(up.quote_plus(sys.argv[1]))"'
    alias urldecode='python3 -c "import sys; del sys.path[0]; import urllib.parse as up; print(up.unquote_plus(sys.argv[1]))"'
elif command -v python2 >/dev/null; then
    alias urlencode='python2 -c "import sys; del sys.path[0]; import urllib as ul; print ul.quote_plus(sys.argv[1])"'
    alias urldecode='python2 -c "import sys; del sys.path[0]; import urllib as ul; print ul.unquote_plus(sys.argv[1])"'
elif command -v xxd >/dev/null; then
    function urlencode() {echo $@ | tr -d "\n" | xxd -plain | sed "s/\(..\)/%\1/g"}
    function urldecode() {printf $(echo -n $@ | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"}
elif command -v ruby >/dev/null; then
    alias urlencode='ruby -r cgi -e "puts CGI.escape(ARGV[0])"'
    alias urldecode='ruby -r cgi -e "puts CGI.unescape(ARGV[0])"'
elif command -v php >/dev/null; then
    alias urlencode='php -r "echo rawurlencode(\$argv[1]); echo \"\n\";"'
    alias urldecode='php -r "echo rawurldecode(\$argv[1]); echo \"\\n\";"'
elif command -v perl >/dev/null; then
    if perl -MURI::Encode -e 1&> /dev/null; then
        alias urlencode='perl -MURI::Encode -ep "uri_encode($ARGV[0]);"'
        alias urldecode='perl -MURI::Encode -ep "uri_decode($ARGV[0]);"'
    elif perl -MURI::Escape -e 1 &> /dev/null; then
        alias urlencode='perl -MURI::Escape -ep "uri_escape($ARGV[0]);"'
        alias urldecode='perl -MURI::Escape -ep "uri_unescape($ARGV[0]);"'
    else
        alias urlencode="perl -e '\$new=\$ARGV[0]; \$new =~ s/([^A-Za-z0-9])/sprintf(\"%%%02X\", ord(\$1))/seg; print \"\$new\n\";'"
        alias urldecode="perl -e '\$new=\$ARGV[0]; \$new =~ s/\%([A-Fa-f0-9]{2})/pack(\"C\", hex(\$1))/seg; print \"\$new\n\";'"
    fi
fi
