# これはチームで共通化や統一しておきたい設定を記述するファイルです。
# config.fishを個人的にカスタムする際には、このファイルを読み込むようにしてください。
#
# ~/.config/fish/config.fish に以下の行を追加してください：
# source ~/team.fish
#

# direnvを有効化
if command -v direnv >/dev/null 2>&1
    direnv hook fish | source
end
