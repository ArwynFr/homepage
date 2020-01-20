FROM debian:buster-slim as minifier
WORKDIR /src/homepage
RUN apt-get update --yes
RUN apt-get install --yes --no-install-recommends minify=2.3.8-1+b10
COPY index.html .
COPY css ./css
COPY img ./img
RUN find . -name *.css -exec minify -o {} {} \;
RUN find . -name *.css -printf "gzip -c %p > %p.gz\n" | sh

FROM nginx:1.17.5-alpine
WORKDIR /usr/share/nginx/html
COPY --from=minifier /src/homepage .