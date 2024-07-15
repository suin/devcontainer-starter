# ひとまず一番シンプルなイメージをFROMで指定。もっといいイメージがあるかもしれない。
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# ubuntuがUID=1000だが、ホスト側のユーザーがUID=1000のとき、このままだとDev Containerの設定値`updateRemoteUserUID`に関する操作が効かなくなってしまうため、ubuntuユーザーを削除しておく。また、`updateRemoteUserUID`の操作より先にUID, GIDを変更しておくことで、ビルド時間を2分程度短縮できる。
RUN userdel -r ubuntu \
    && groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME

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
