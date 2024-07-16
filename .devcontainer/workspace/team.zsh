# これはチームで共通化や統一しておきたい設定を記述するファイルです。
# .zshrcを個人的にカスタムする際には、このファイルを読み込むようにしてください。
#
# ```zsh:.zshrc
# source ~/team.zsh
# ```
#

# direnvを有効化
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
