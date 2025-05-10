# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes cargo bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# set PATH so it includes gem if it exists
if [ -d "$HOME/.gem/ruby/2.5.0/bin" ] ; then
  export PATH="$HOME/.gem/ruby/2.5.0/bin:$PATH"
fi

# set PATH so it includes gem if it exists
if [ -d "$HOME/.gem/ruby/2.6.0/bin" ] ; then
  export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
fi

# set PATH so it includes gem if it exists for vimgolf
if [ -d "$HOME/.gem/ruby/2.7.0/bin" ] ; then
  export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
fi

# set PATH so it includes flamegraph if it exists
if [ -d "$HOME/repos/flamegraph" ] ; then
  export PATH="$HOME/repos/flamegraph:$PATH"
fi

if [ -d "$HOME/.poetry/bin" ] ; then
  export PATH="$HOME/.poetry/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ] ; then
  export PATH="$HOME/go/bin:$PATH"
fi

if [ -d "$HOME/../linuxbrew" ] ; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if [ -f "/opt/homebrew/bin/brew" ] ; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
