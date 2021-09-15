FROM ruby:2.7.2

RUN apt-get update -qq && apt-get install -y curl sudo \
  && curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && sudo apt-get update -qq && sudo apt-get install -y nodejs yarn \
  && rm -rf /var/lib/apt/lists/*

ENV APP_ROOT /aws_batch
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

COPY Gemfile* ./
RUN bundle install --jobs=3 --retry=3 --path=/vendor/bundle

COPY . .

RUN yarn install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "bundle", "exec", "rails", "s", "-p", "80", "-b", "0.0.0.0" ]
