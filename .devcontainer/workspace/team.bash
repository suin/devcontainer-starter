# これはチームで共通化や統一しておきたい設定を記述するファイルです。
# .bashrcを個人的にカスタムする際には、このファイルを読み込むようにしてください。
#
# ```bash:.bashrc
# source ~/team.bash
# ```
#

# direnvを有効化
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
