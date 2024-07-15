# Dev Container Starter

このリポジトリは、新規のプロジェクトや既存のプロジェクトにDev Containerを導入するためのスターターキットです。

## 特徴

- SSH経由でコンテナにログインできる
- エディタの起動高速化: VS Code, JetBrains IDE, Cursor, Neovimの設定をキャッシュしているので、2回目以降の起動が高速化される
- [Chezmoi]がすぐ使える
- [Nix]がすぐ使える
- GitHub CLI([gh])がログイン済み状態で使い出せる

[Chezmoi]: https://www.chezmoi.io/
[Nix]: https://nixos.org/
[gh]: https://cli.github.com

## 必要なもの

### macOS上だけで完結したい場合

- [Docker Desktop for Mac]や[OrbStack]などのDocker環境

[Docker Desktop for Mac]: https://www.docker.com/products/docker-desktop
[OrbStack]: https://orbstack.dev/

### リモートのLinux上のDocker環境を使いたい場合

- リモートのLinuxでDockerが利用できる状態になっていること
- リモートのLinuxにSSHでログインできること
- [Dev Container CLI]がインストールされていること

[Dev Container CLI]: https://github.com/devcontainers/cli

## 導入方法

このリポジトリの `.devcontainer` ディレクトリをコピーして、自分のプロジェクトのルートディレクトリに配置する。

## ホストマシン側の準備

### SSHで公開鍵認証を使う場合 (推奨)

ホストマシン側の `~/.ssh/authroized_keys` に公開鍵を追加しておく。

### ghの認証情報をコンテナに引き継ぎたい場合

ホストマシンで `gh auth login` しておく。

### ホストマシンのChezmoiの設定をコンテナに引き継ぎたい場合

ホストマシンの `~/.local/share/chezmoi` ディレクトリにChezmoiの設定ファイルを配置しておく。

## 起動方法 (リモートのLinux上のDocker環境を使う場合)

ホストマシン上で以下のコマンドを実行する。

```bash
devcontainer up --workspace-folder .
```

## 起動方法 (macOS上で完結+JetBrains系IDE)

TODO

## 起動方法 (macOS上で完結+VS Code)

TODO

## 起動方法 (macOS上で完結+Cursor)

TODO

## コンテナへのログイン方法

### ホストマシンから直接ログイン (DevContainer CLIが使える場合)

```bash
devcontainer exec --workspace-folder . bash
```

この方法だと、SSHエージェントが使えないので、コンテナ内でプライベートリポジトリに対してgitの操作ができない。通常の開発作業ではSSH経由でログインすることをお勧めする。

### ホストマシンから直接ログイン (DevContainer CLIが使えない場合)

`docker ps` でコンテナのIDを調べて、以下のコマンドを実行する。

```bash
docker exec -it <container-id> bash
```

この方法だと、SSHエージェントが使えないので、コンテナ内でプライベートリポジトリに対してgitの操作ができない。通常の開発作業ではSSH経由でログインすることをお勧めする。


### SSH経由でログイン (推奨)

```bash
ssh -p 2222 vscode@127.0.0.1
```

基本的な設定は以下の通り。

```
Host devcontainer
  HostName 127.0.0.1
  Port 2222
  User vscode
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
```

これに加えて、SSHエージェントの転送を有効化しておくと、コンテナ内でプライベートリポジトリに対してgitの操作ができる。

鍵を使わない場合、上の「直接ログイン」の方法でログインし、`sudo passwd vscode`でパスワードを設定しておく必要がある。開発環境として使うわけですが、セキュリティ的には望ましくないと思うので、鍵を使うことをお勧めする。

コンテナへのログインは以下の通り。

```bash
ssh devcontainer
```

## Dev Containerイメージの再ビルド

```bash
devcontainer build --workspace-folder .
```

## ワークスペースコンテナーの停止

コンテナを停止するには以下のコマンドを使う。

```bash
docker ps
docker rm -f <container-id>
```

## Dev Containerの削除

`devcontainer down`コマンドは未実装なので、代わりに次の手順を行う。

`docker compose ls`で当該プロジェクト名を調べる。

見つかったプロジェクト名を使って以下のコマンドを実行する。

```bash
docker compose --project-name <project-name> down
```

ただこの方法だと削除されるのはコンテナとネットワークだけなので、イメージやボリュームもまとめて削除したい場合は以下のコマンドを実行する。

```bash
docker compose --project-name <project-name> down --volumes --rmi all --remove-orphans
```

このコマンドの詳細は[《滅びの呪文》Docker Composeで作ったコンテナ、イメージ、ボリューム、ネットワークを一括完全消去する便利コマンド #docker-compose - Qiita](https://qiita.com/suin/items/19d65e191b96a0079417)を参照。

## Chezmoiの適用

dotfilesを[Chezmoi]で管理している場合は、すでに`chezmoi`コマンドが使える状態になっているので、Dev Container内で以下のコマンドを実行する。

```bash
chezmoi init --apply
```

## Nixの適用

Dev Containerには`nix`コマンドがインストールされているので、Nixの設定ファイルを持っている場合は、Dev Container内で以下のコマンドを実行する。

```bash
nix develp # など
```

## 複数のプロジェクトを同時に起動したいとき

複数のプロジェクトを同時に起動しようとすると、ポートの競合が発生する。

`.devcontainer/.env`の`HOST_ADDR`をプロジェクトごとにIPアドレスを変えることで、一応ポートの競合を回避できる。

ただ、この方法は開発者個々人がIPアドレスを自由に決める裁量がないため、チーム開発には向いていない可能性がある。開発者ごとに携わっているプロジェクト数が異なる可能性があるため。このへんの改善は今後の課題とする。
