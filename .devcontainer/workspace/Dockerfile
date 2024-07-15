# ひとまず一番シンプルなイメージをFROMで指定。もっといいイメージがあるかもしれない。
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# ホストマシンのユーザーIDが1000なので、コンテナーのユーザーのUIDも1000にすることで、マウントしたボリュームのファイルの所有権問題を起きにくくする
RUN userdel -r ubuntu \
    && groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME

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
