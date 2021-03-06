# ENV vars
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PYTHONBREAKPOINT ipdb.set_trace
set -gx GPG_TTY (tty)
set -gx ASDF_DATA_DIR ~/.asdf
set -gx DENO_INSTALL ~/.deno
set -gx GOPATH $HOME/go

# Abbr/Aliases
abbr --add senv 'source env/bin/activate.fish'
abbr --add d deactivate
abbr --add vim nvim
abbr --add n nvim
abbr --add e $EDITOR
abbr --add src 'source ~/.config/fish/config.fish'
abbr --add ch chezmoi
abbr --add rd 'rm -r'
abbr --add c z

# External Configs
set -g fish_user_paths /usr/local/opt/luajit-openresty/bin $fish_user_paths
set -g fish_user_paths /usr/local/sbin $fish_user_paths
set -g fish_user_paths "$HOME/.local/bin" $fish_user_paths
set -g fish_user_paths "$HOME/.cargo/bin" $fish_user_paths
set -g fish_user_paths "$DENO_INSTALL/bin" $fish_user_paths
set -g fish_user_paths "$GOPATH/bin" $fish_user_paths
set -g fish_user_paths /usr/local/opt/llvm/bin $fish_user_paths
if test -f /usr/local/opt/asdf/asdf.fish
    source /usr/local/opt/asdf/asdf.fish
end

# TokyoNight Color Palette
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_storm.fish
set -l foreground c0caf5
set -l selection 364A82
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
