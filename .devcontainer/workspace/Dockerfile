# ひとまず一番シンプルなイメージをFROMで指定。もっといいイメージがあるかもしれない。
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode

# ubuntuがUID=1000だが、ホスト側のユーザーがUID=1000のとき、このままだとDev Containerの設定値`updateRemoteUserUID`に関する操作が効かなくなってしまうため、ubuntuユーザーを削除しておく。
RUN userdel -r ubuntu

USER $USERNAME

# マウントするボリュームのディレクトリを作成しておく。マウントしたときに所有者がrootになるのを防ぐため。
RUN mkdir -p \
			~/.ssh \
			~/.config/gh \
			~/.local/share \
      ~/.cache \
			~/.cursor-server \
			~/.vscode-server \
			~/.config/JetBrains \
			~/.local/share/nvim \
    && chmod 700 ~/.ssh

# ログインしたときにコードベースに直行できるようにしておく
WORKDIR /workspace
