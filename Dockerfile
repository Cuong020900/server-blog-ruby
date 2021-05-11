# FROM ubuntu:18.04 as base-ubuntu

# MAINTAINER CuongUET <trancuong.02092000@gmail.com>

# # update apt cache and install dependencies
# RUN apt-get update && apt-get install git curl build-essential libssl-dev libreadline-dev zlib1g-dev sqlite3 libsqlite3-dev -y

# # set rbenv, ruby-build bin paths
# ENV HOME /home/app
# ENV PATH $HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH

# # clone rbenv
# RUN git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
# RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

# RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

# RUN exec $SHELL

# # install ruby
# RUN rbenv install 2.6.3
# RUN rbenv global 2.6.3
# # install bundler
# RUN gem install bundler

FROM ruby:2.6.3

RUN apt-get update && apt-get install -y npm && npm install -g yarn

RUN gem install bundler
RUN gem install rails
RUN mkdir -p /var/app
COPY . /var/app
WORKDIR /var/app

RUN bundle install