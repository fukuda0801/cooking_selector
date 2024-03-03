FROM ruby:3.0.2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update && apt-get install -y curl apt-transport-https wget nodejs yarn && \
    apt-get install -y imagemagick && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /cooking_selector
WORKDIR /cooking_selector

COPY Gemfile /cooking_selector/Gemfile
COPY Gemfile.lock /cooking_selector/Gemfile.lock
RUN bundle install
RUN yarn install --check-files

COPY . /cooking_selector

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
