# ひとまず一番シンプルなイメージをFROMで指定。もっといいイメージがあるかもしれない。
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode

# ubuntuがUID=1000だが、ホスト側のユーザーがUID=1000のとき、このままだとDev Containerの設定値`updateRemoteUserUID`に関する操作が効かなくなってしまうため、ubuntuユーザーを削除しておく。
RUN userdel -r ubuntu

USER $USERNAME

# マウントするボリュームのディレクトリを作成しておく。マウントしたときに所有者がrootになるのを防ぐため。
RUN mkdir -p \
			/home/vscode/.ssh \
			/home/vscode/.config/gh \
			/home/vscode/.local/share \
      /home/vscode/.cache \
			/home/vscode/.cursor-server \
			/home/vscode/.vscode-server \
			/home/vscode/.config/JetBrains \
			/home/vscode/.local/share/nvim \
    && chmod 700 /home/vscode/.ssh

# ログインしたときにコードベースに直行できるようにしておく
WORKDIR /workspace
