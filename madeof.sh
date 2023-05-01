function nilstr { echo "$1"\!; }
function isnil { [ "$1" = \! ]; }
function reststr { echo "$1" | cut -c 2-; }
function begstr { echo "$1" | cut -c -1; }
function ins { echo "$2"| grep "$1"; }
function remove-first { echo "$2" | sed 's/'"$1"'//'; }

function can-be-made-of-nil {
    arg="$1"
    set="$2"

    if isnil "$arg">/dev/null;then
	echo "t"
    elif isnil "$set">/dev/null;then
	echo "f"
    else
	if ins "$(begstr "$arg")" "$set" >/dev/null;then
	    can-be-made-of-nil "$(reststr $arg)" "$(remove-first "$(begstr "$arg")" "$set")"
	else
	    echo "f"
	fi
    fi
}

function can-be-made-of { can-be-made-of-nil "$1"\! "$2"\!; }

function words-from-set {
    wordsize="$1"
    letterset="$2"
    IFS=$'\n'

    for x in $(cat ~/scripts/projects/madeof/words.txt|tr A-Z a-z| grep -E '^['"$letterset"']+$'| grep -E '^.{'"$wordsize"'}$' ) ;do
	if [ "$(can-be-made-of "$x" "$letterset")" = "t" ];then
	    echo "$x"
	fi
    done
}

function words-from-set-stdin {
    letterset="$1"

    for x in $(cat -) ;do
	if [ "$(can-be-made-of "$x" "$letterset")" = "t" ];then
	    echo "$x"
	fi
    done

    IFS=''

}

#$(cat /usr/share/dict/british-english| grep -E '^['"$letterset"']+$'| grep -E '^.{'"$wordsize"'}$' )
words-from-set "$1" "$2"
