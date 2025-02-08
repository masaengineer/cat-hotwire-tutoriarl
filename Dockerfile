FROM ruby:3.2.2

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs
RUN npm install --global yarn

# 作業ディレクトリの作成
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Bundlerでgemをインストール
RUN bundle install

# package.jsonとyarn.lockをコピー
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock

# Yarnでパッケージをインストール
RUN yarn install

# アプリケーションのソースをコピー
COPY . /app

# Railsサーバーを起動するためのエントリーポイントスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Railsサーバーを起動
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
