#              __           __
# .-----.-----|  |--.______|  |--.---.-.-----.-----.-----.----.
# |-- __|__ --|     |______|  _  |  _  |     |     |  -__|   _|
# |_____|_____|__|__|      |_____|___._|__|__|__|__|_____|__|
#                                      drkhsh <me@drkhsh.at>

# thx to yuhonas for inspiration and initial codebase <3

set -o pipefail

DEFAULT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/banner/" # trailing / is important
export ANSI_MOTD_ART_DIR="${ANSI_MOTD_ART_DIR:-$DEFAULT_DIR}"

# create directory if necessary
[ -d "$ANSI_MOTD_ART_DIR" ] || mkdir -p "$ANSI_MOTD_ART_DIR"

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
         --search-path "$ANSI_MOTD_ART_DIR" |\
         shuf -n 1
    else
      find "$ANSI_MOTD_ART_DIR" -type f \
       -iname '*.ans' -or \
       -iname '*.asc' |\
       shuf -n 1
    fi;
  else
  	# no shuf on OpenBSD
    find "$ANSI_MOTD_ART_DIR" -type f \
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
    viewer=(pv --quiet --rate-limit ${ANSI_MOTD_RATE_LIMIT_OUTPUT:-1T})
  fi

  if [ -n "$ansi_filename" ]; then
    # turn off automatic margins (a.k.a. line wrapping) if we've been told too
    # this is so it'll still render something usable even if the terminal is too narrow
    if [ -n "$ANSI_MOTD_DISABLE_LINE_WRAPPING" ]; then print -n '\e[?7l'; fi;

    # convert from the original character set (Code page 437)
    # see https://en.wikipedia.org/wiki/Code_page_437
    iconv -f 437 < $ansi_filename | ${viewer}

    # restore automatic margins if we've been told too
    if [ -n "$ANSI_MOTD_DISABLE_LINE_WRAPPING" ]; then print -n '\e[?7h'; fi;

    # record the filename in this session incase the user wants to find it later
    export ANSI_MOTD_FILENAME="$ansi_filename"
  else
    echo "\
zsh-banner.plugin.zsh:
I couldn't find any ansi art to display, I tried looking in '$ANSI_MOTD_ART_DIR' 😢
" >&2
  fi;
}

ansi_art_random

