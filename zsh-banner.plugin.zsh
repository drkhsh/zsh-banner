#              __           __
# .-----.-----|  |--.______|  |--.---.-.-----.-----.-----.----.
# |-- __|__ --|     |______|  _  |  _  |     |     |  -__|   _|
# |_____|_____|__|__|      |_____|___._|__|__|__|__|_____|__|
#                                      drkhsh <me@drkhsh.at>

# thx to yuhonas for inspiration and initial codebase <3

set -o pipefail

DEFAULT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/banner/" # trailing / is important
export ZSH_BANNER_DIR="${ZSH_BANNER_DIR:-$DEFAULT_DIR}"

# create directory if necessary
[ -d "$ZSH_BANNER_DIR" ] || mkdir -p "$ZSH_BANNER_DIR"

# find a random piece of ansi art to display
function ansi_art_random_file {
  if (( $+commands[shuf] )); then
    # if fd is installed let's use that, it's faster (at least in my testing)
    # https://github.com/sharkdp/fd
    if (( $+commands[fd] )); then
      fd --extension ans \
         --extension asc \
         --absolute-path \
         --type f \
         --search-path "$ZSH_BANNER_DIR" |\
         shuf -n 1
    else
      find "$ZSH_BANNER_DIR" -type f \
       -iname '*.ans' -or \
       -iname '*.asc' |\
       shuf -n 1
    fi;
  else
  	# no shuf on OpenBSD
    find "$ZSH_BANNER_DIR" -type f \
     -iname '*.ans' -or \
     -iname '*.asc' |\
     sort -R |\
     head -n 1
  fi;
}

# display random art piece
function ansi_art_random {
  ansi_filename="$(ansi_art_random_file)"

  # optional use pv to limit rate we output
  viewer=(cat)
  if (( $+commands[pv] )); then
    viewer=(pv --quiet --rate-limit ${ZSH_BANNER_RATE_LIMIT_OUTPUT:-1T})
  fi

  if [ -n "$ansi_filename" ]; then
    # turn off automatic margins (a.k.a. line wrapping) if we've been told too
    # this is so it'll still render something usable even if the terminal is too narrow
    if [ -n "$ZSH_BANNER_DISABLE_LINE_WRAPPING" ]; then print -n '\e[?7l'; fi;

    # convert from the original character set (Code page 437)
    # see https://en.wikipedia.org/wiki/Code_page_437
    # also remove \r
    iconv -f 437 < $ansi_filename | tr -d '\r' | ${viewer}

    # restore automatic margins if we've been told too
    if [ -n "$ZSH_BANNER_DISABLE_LINE_WRAPPING" ]; then print -n '\e[?7h'; fi;

    # record the filename in this session incase the user wants to find it later
    export ZSH_BANNER_FILENAME="$ansi_filename"
  else
    echo "\
zsh-banner.plugin.zsh:
Couldn't find any ansi/ascii art to display in '$ZSH_BANNER_DIR' ... 😢
" >&2
  fi;
}

ansi_art_random
