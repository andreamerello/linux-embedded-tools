GREEN='\033[92m'
RED='\033[91m'
YELLOW='\033[93m'
BLUE='\033[94m'
BOLD='\033[44m'
UNDERLINE='\033[4m'

function colorecho() {
    echo -en $1
    echo ${@:2}
    tput sgr0
}
