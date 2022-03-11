FROM ruby:3.0.2-alpine

# maintainer
LABEL maintainer="Eleam Emmanuel"

# set scripts path in env
ENV PATH="/scripts:${PATH}"

#RUN apk add --no-cache bash
RUN apk add --update --virtual \
      runtime-deps \
      postgresql-client \
      build-base \
      libxml2-dev \
      libxslt-dev \
      libffi-dev \
      readline \
      postgresql-dev \
      libc-dev \
      linux-headers \
      readline-dev \
      file \
      imagemagick \
      git \
      tzdata \
      && rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app/
COPY ./scripts /scripts
RUN chmod +x /scripts/*

ENV BUNDLE_PATH /gems
RUN bundle install

ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
