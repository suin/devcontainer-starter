# Dev Container Starter

このリポジトリは、新規のプロジェクトや既存のプロジェクトにDev Containerを導入するためのスターターキットです。

## 特徴

- SSH経由でコンテナにログインできます。
- エディタの起動高速化: VS Code、JetBrains IDE、Cursor、Neovimの設定をキャッシュしているので、2回目以降の起動が高速化されます。
- [Chezmoi]がすぐ使えます。
- [Nix]がすぐ使えます。Nixで導入したツールがVS Codeでも使えます。
- GitHub CLI([gh])がログイン済み状態で使い始められます。
- [Direnv]がすぐに使えます。
- `.bashrc`、`.zshrc`、`config.fish`を「チームで共通化したい」vs「個人でカスタムしたい」が両立可能です。

[Chezmoi]: https://www.chezmoi.io/
[Nix]: https://nixos.org/
[gh]: https://cli.github.com
[Direnv]: https://direnv.net/

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

このリポジトリの `.devcontainer` ディレクトリをコピーして、自分のプロジェクトのルートディレクトリに配置します。[リリースページ](https://github.com/suin/dev-container-starter/releases)に`.devcontainer`ディレクトリをダウンロード&展開するワンライナーがあるので、それを使うと便利です。

## ホストマシン側の準備

### SSHで公開鍵認証を使う場合 (推奨)

ホストマシン側の `~/.ssh/authorized_keys` に公開鍵を追加しておきます。

### ghの認証情報をコンテナに引き継ぎたい場合

ホストマシンで `gh auth login` しておきます。

### ホストマシンのChezmoiの設定をコンテナに引き継ぎたい場合

ホストマシンの `~/.local/share/chezmoi` ディレクトリにChezmoiの設定ファイルを配置しておきます。

## 起動方法 (リモートのLinux上のDocker環境を使う場合)

ホストマシン上で以下のコマンドを実行します。

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

この方法では、SSHエージェントが使えないため、コンテナ内でプライベートリポジトリに対してgitの操作ができません。通常の開発作業ではSSH経由でログインすることをお勧めします。

### ホストマシンから直接ログイン (DevContainer CLIが使えない場合)

`docker ps` でコンテナのIDを調べて、以下のコマンドを実行します。

```bash
docker exec -it <container-id> bash
```

この方法では、SSHエージェントが使えないため、コンテナ内でプライベートリポジトリに対してgitの操作ができません。通常の開発作業ではSSH経由でログインすることをお勧めします。

### SSH経由でログイン (推奨)

```bash
ssh -p 2222 vscode@127.0.0.1
```

基本的な設定は以下の通りです。

```
Host devcontainer
  HostName 127.0.0.1
  Port 2222
  User vscode
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
```

`StrictHostKeyChecking no` と `UserKnownHostsFile /dev/null` は、セキュリティ的には望ましくない設定ですが、開発環境として使うためには便利です。
Dev Containerは日々破棄と構築が繰り返されることが前提であるため、フィンガープリントがちょくちょく変わることがあります。
これらをセットしておかないと、`~/.ssh/known_hosts` を日々メンテナンスする必要が出てきます。
したがって以上の設定をしておき、フィンガープリントの確認をスキップする設定にしておいたほうが、開発体験が向上します。

これに加えて、SSHエージェントの転送を有効化しておくと、コンテナ内でプライベートリポジトリに対してgitの操作ができます。

TODO: SSHエージェントの転送の設定方法を追記する

鍵を使わない場合、上の「直接ログイン」の方法でログインし、`sudo passwd vscode`でパスワードを設定しておく必要があります。開発環境として使うため、セキュリティ的には望ましくないと思われるので、鍵を使うことをお勧めします。

コンテナへのログインは以下の通りです。

```bash
ssh devcontainer
```

## Dev Containerイメージの再ビルド

```bash
devcontainer build --workspace-folder .
```

起動中のDev Containerを削除しつつ、再ビルド、再起動まで一度に行う場合は次のコマンドを実行します。

```bash
devcontainer up --workspace-folder . --remove-existing-container
```

## Dev Containerの削除

`devcontainer down`コマンドは未実装のため、代わりに次の手順を行います。

`docker compose ls`で当該プロジェクト名を調べます。

見つかったプロジェクト名を使って以下のコマンドを実行します。

```bash
docker compose --project-name <project-name> down
```

ただし、この方法では削除されるのはコンテナとネットワークだけです。イメージやボリュームもまとめて削除したい場合は以下のコマンドを実行します。

```bash
docker compose --project-name <project-name> down --volumes --rmi all --remove-orphans
```

このコマンドの詳細は[《滅びの呪文》Docker Composeで作ったコンテナ、イメージ、ボリューム、ネットワークを一括完全消去する便利コマンド #docker-compose - Qiita](https://qiita.com/suin/items/19d65e191b96a0079417)を参照してください。

## チームの設定と個人向けの設定

このDev Containerは、チーム開発向けの設定と個人向けの設定を両立させることを目指しています。

### Bash, Zsh, Fishの設定

チーム共通の設定は、

- ~/team.bash
- ~/team.zsh
- ~/team.fish

に記述します。これは、それぞれ

- ~/.bashrc
- ~/.zshrc
- ~/.config/fish/config.fish

から読み込まれることを想定しています。したがって、シェルを個人的にカスタマイズしたい場合は、これらのファイルを編集して構いませんが、チーム共通の設定を忘れずに`source`することを推奨します。

## Chezmoiの適用

dotfilesを[Chezmoi]で管理している場合は、すでに`chezmoi`コマンドが使える状態になっているので、Dev Container内で以下のコマンドを実行します。

```bash
chezmoi init --apply
```

## Nixの適用

Dev Containerには`nix`コマンドがインストールされているので、Nixの設定ファイルを持っている場合は、Dev Container内で以下のコマンドを実行します。

```bash
nix develop # など
```

このDev Containerには、[Direnv]が導入済みなので、`.envrc`ファイルを使って環境変数を設定することもできます。おそらくこちらの設定のほうが、毎回`nix develop`を実行する必要がないので便利でしょう。

```bash
# /workspace/.envrc
use flake
```

### VS CodeでのNixパッケージの利用

プロジェクトルートの`flake.nix`で指定したパッケージをVS Codeで利用するためには、[direnv拡張]をVS Codeにインストールしてください。

[direnv拡張]: https://marketplace.visualstudio.com/items?itemName=mkhl.direnv

プロジェクトルートに`.envrc`を作り、次の内容を書いておいてください。

```bash
use flake
```

この状態でVS Codeを開くと、direnv allowを求められます。許可するとNixのパッケージにパスが通るので、VS Codeの各種拡張からNixで導入したツールが利用できるようになります。許可してもうまくパスが通っていないようであれば、VS Codeを再起動してみてください。

## 複数のプロジェクトを同時に起動したいとき

複数のプロジェクトを同時に起動しようとすると、ポートの競合が発生します。

`.devcontainer/.env`の`HOST_ADDR`をプロジェクトごとにIPアドレスを変えることで、一応ポートの競合を回避できます。

ただし、この方法は開発者個々人がIPアドレスを自由に決める裁量がないため、チーム開発には向いていない可能性があります。開発者ごとに携わっているプロジェクト数が異なる可能性があるためです。このあたりの改善は今後の課題とします。

## CI (GitHub Actions)

### `devcontainer/ci`でDev Containerを再利用する

GitHub ActionsでDev Containerを再利用したいときは、[devcontainer/ci](https://github.com/devcontainers/ci/blob/main/docs/github-action.md)アクションを使うと良いでしょう。

```yaml
name: Dev Container Build Check
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - name: Run devcontainer build
      uses: devcontainers/ci@v0.3
      with:
        runCmd: yarn test
```

以上はシンプルな導入例ですが、ドキュメントにはDev Containerのビルドをキャッシュする方法など高度なトピックについても記載されています。

### `devcontainer/ci`を使わずにDev Containerのビルドをテストする

Dev ContainerがビルドできるかをCIでテストすることができます。以下のようなGitHub Actionsの設定ファイルを用意して、リポジトリに配置します。

```yaml
name: Dev Container Build Check

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  devcontainer-build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Dev Container CLI
        run: npm install -g @devcontainers/cli
      - name: Run devcontainer build
        run: devcontainer build --workspace-folder .
```

### `devcontainer/ci`を使わずにDev Containerで何かコマンドを実行する

CIでもDev Containerの環境を用いて、テストやビルドなど何らかのタスクを行いたいことがあるかもしれません。
その場合は、以下のようなGitHub Actionsの設定ファイルを用意して、リポジトリに配置します。

```yaml
name: Use Dev Container in CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  devcontainer-build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Dev Container CLI
        run: npm install -g @devcontainers/cli
      - name: Execute something in Dev Container
        run: devcontainer exec --workspace-folder . echo "Hello, Dev Container!"
```

## Dev Containerのカスタマイズ

このDev Containerをカスタマイズする方法はいくつかあります。

### `devcontainer.json`

Dev Containerの設定ファイルです。本リポジトリでは扱っていない設定も沢山あります。カスタマイズが必要になったら下記公式ドキュメントを参照してみてください。

- [devcontainer.json reference](https://code.visualstudio.com/docs/remote/devcontainerjson-reference)

### Dev Container Features

Dev Container Featuresは、開発コンテナの機能を拡張するためのモジュラーなコンポーネントです。これらを使用することで、開発者は必要な言語サポート、ツール、設定などを柔軟に追加し、プロジェクト固有の要件に合わせて開発環境をカスタマイズできます。再利用可能で、バージョン管理が可能なため、一貫性のある環境構築を容易にします。

このDev ContainerでもすでにいくつかのFeaturesを利用しています。

利用可能なDev Container Featuresの一覧は以下のURLから確認できます。

https://containers.dev/features

## 起動パフォーマンス

Dev Containerの起動が遅いと、開発体験が悪くなります。そのため、Dev Containerの起動を高速化は重要です。

Dev ContainerはDockerをベースとしているため、起動を高速化するにはDockerビルドの最適化に関する次のような知識が必要です。

- イメージを小さくする
- レイヤーキャッシュがよく効くようにする (単純にレイヤー数を減らせば速くなるわけではなく、適切に分割することが重要)
- コンテキストをできるだけ小さくする
- ボリュームを使う

### イメージサイズを小さくする・レイヤーキャッシュを効かせる

この手の最適化は[`dive`]や`docker diff`などのツールを使って、Dockerイメージのレイヤーを分析する必要があります。

[`dive`]: https://github.com/wagoodman/dive

### コンテキストをできるだけ小さくする

Dockerビルド時にDockerデーモンに転送するファイルが増えると、ビルドが遅くなります。
Dev Containerを構成する上で不要なファイルがコンテキストに含まれていないかチェックしましょう。
チェックには[`docker-show-context`]を使うと便利です。不要なファイルが除外されるように、コンテキストを指定する、`.dockerignore`ファイルを適切に設定するなどの対策を行いましょう。

[`docker-show-context`]: https://github.com/pwaller/docker-show-context

### ボリュームを使う

Dev Containerの開発体験はDockerビルドのパフォーマンスだけでなく、IDEの起動にかかる時間や、`yarn install`などの初回セットアップ手順にかかる時間も重要になってきます。
このDev Containerでは、「ボリュームを使う」アプローチを用いて、初回セットアップ手順の高速化を図っています。
この最適化はツールがどこにキャッシュや設定ファイルを作るかを理解する必要があります。
ツールがどこにファイルを作るかを知るには、`docker diff`コマンドを使うと便利です。

```bash
docker diff <container-id> | sort
```

これにより見つかったファイルをボリュームにマウントすることで、2回目以降のセットアップ手順の高速化が期待できます。
ボリュームマウントする方法は、`devcontainer.json`の`mounts`セクションを使うと簡単に設定できますが、このDev Containerでは `docker-compose.yml` を使ってボリュームマウントを設定しています。

## Q&A

### `vsc-{project-name}-{checksum}-uid:latest`のようなイメージが作成されるのはなぜですか？

Dev Containerの仕様で、設定`updateRemoteUserUID`が有効になっているとき、ホストマシンのユーザーIDに合わせてコンテナ内のユーザーIDを変更します。この変更がイメージとして作られた結果です。
