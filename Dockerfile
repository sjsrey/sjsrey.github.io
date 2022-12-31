FROM jekyll/jekyll:3.8

LABEL maintainer="Serge Rey <sjsrey@gmail.com>"

COPY Gemfile /srv/jekyll/Gemfile
COPY Gemfile.lock /srv/jekyll/Gemfile.lock
RUN bundle install
