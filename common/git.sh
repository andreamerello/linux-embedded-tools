# (original version created with exprompt.net)
function parse_git_branch() {
    GIT_BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
}
