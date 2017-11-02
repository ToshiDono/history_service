FROM ruby:2.4
MAINTAINER Anton Karpenko <toshidono.it.work@gmail.com>

COPY . /app/
WORKDIR /app
RUN bundle install
EXPOSE 5000
EXPOSE 6379
EXPOSE 5432
EXPOSE 9292
CMD foreman start