```
              __           __
 .-----.-----|  |--.______|  |--.---.-.-----.-----.-----.----.
 |-- __|__ --|     |______|  _  |  _  |     |     |  -__|   _|
 |_____|_____|__|__|      |_____|___._|__|__|__|__|_____|__|
```

# zsh-banner

A zsh plugin to display ANSI/ASCII art on shell startup.

This is a simplified/slightly adapted and maintained fork of
[yuhonas/zsh-ansimotd](https://github.com/yuhonas/zsh-ansimotd).

## Installation

### Dependencies

* [zsh](https://www.zsh.org/)

#### Optional
* [shuf]( https://en.wikipedia.org/wiki/Shuf) which is part of gnu
  [coreutils](https://formulae.brew.sh/formula/coreutils)
* [fd](https://github.com/sharkdp/fd) a modern `find` replacement, it will use
  this preferentially if it's installed otherwise fallback to `find`.
* [pv](https://www.ivarch.com/programs/pv.shtml) a pipe viewer which can limit
  the art rendering speed to emulate the feel of an old skool BBS.

### Install using your favourite plugin manager or not

```
# for zinit
zinit light drkhsh/zsh-banner

# for znap
znap source yuhonas/zsh-ansimotd

# for antigen
antigen bundle yuhonas/zsh-ansimotd

# for zplug
zplug "yuhonas/zsh-ansimotd"

# manually
# Clone the repository and source it in your shell's rc file
```

### Getting some awesome ansi art to display

After installation you'll need to download some ansi art for it to randomly
display, I suggest a few places:

#### 16colo.rs

Head over to [16colo.rs](https://16colo.rs/) and if you find a year(s) you like
you can download everything from that year using their rsync mirror.

eg. to download everything from [1996](https://16colo.rs/year/1996/) to the
`ZSH_BANNER_DIR`:

```
rsync -azvhP --include '*/' --include '*.ANS' --exclude '*' rsync://16colo.rs/pack/1996 "$ZSH_BANNER_DIR"
```

#### artscene.textfiles.com

Find a pack you like at [artscene](http://artscene.textfiles.com/artpacks/) and
unpack it into the ansi motd config directory.

You can do this by copying any `.ans`, or `.asc` files containg ansi art into
your `ZSH_BANNER_DIR` directory which is derived from
`${XDG_CONFIG_HOME:-$HOME/.config}/ansimotd` (the plugin performs a recursive
search for art so any directory nesting is fine).

### Configuration / Settings

The plugin exports the following useful variables to the session

* `ZSH_BANNER_DIR`  - the full path to the config directory where the plugin
  will search for ansi art
* `ZSH_BANNER_FILENAME` - the full file path to the last shown peice of ansi art,
  if you want to do something with it, laud over it, delete it etc

There's also a handful of ENV variables you can use to configure the plugin
(these will need to be set prior to plugin instantiation).

#### The real BBS experience

To buffer the ansi art output at a fixed speed you can set the
`ZSH_BANNER_RATE_LIMIT_OUTPUT` ENV variable.

eg. to limit the ansi art rendering rate to a data rate of 8k:

```
export ZSH_BANNER_RATE_LIMIT_OUTPUT="8k"
```

#### Small screens

If you happen to be running on a small fixed screen perhaps on something like
[termux](https://termux.dev/en/) you can set the following environemnt variable
to truncate the art to screen width:

```
export ZSH_BANNER_DISABLE_LINE_WRAPPING=1
```

### Note

Art to be displayed is assumed to use the
[Code Page 437]( https://en.wikipedia.org/wiki/Code_page_437 ) character set.


### License

This project is licensed under the [MIT](./LICENSE) license.

