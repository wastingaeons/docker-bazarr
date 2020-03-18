FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BAZARR_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"
# hard set UTC in case the user does not define it
ENV TZ="Etc/UTC"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	libxml2-dev \
	libxslt-dev \
	python3-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	ffmpeg \
	libxml2 \
	libxslt \ 
	python3 \
	unrar \
	unzip && \
 echo "**** install bazarr ****" && \
 if [ -z ${BAZARR_VERSION+x} ]; then \
	BAZARR_VERSION=$(curl -sX GET "https://api.github.com/repos/morpheus65535/bazarr/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /tmp/bazarr.tar.gz -L \
	"https://github.com/morpheus65535/bazarr/archive/${BAZARR_VERSION}.tar.gz" && \
 mkdir -p \
	/app/bazarr && \
 tar xf \
 /tmp/bazarr.tar.gz -C \
	/app/bazarr --strip-components=1 && \
 rm -Rf /app/bazarr/bin && \
 echo "**** Install requirements ****" && \
 pip3 install --no-cache-dir -U  -r \
	/app/bazarr/requirements.txt && \ 
 echo "**** clean up ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

RUN apk add --no-cache alsa-lib-dev \
    automake \
    autoconf \
    bison \
    build-base \ 
    curl \
    git \
    libtool \
    python3-dev \
    swig \
    tar \
    wget \
    xz && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    rm -r /root/.cache

WORKDIR /build

RUN wget https://sourceforge.net/projects/cmusphinx/files/sphinxbase/5prealpha/sphinxbase-5prealpha.tar.gz/download -O sphinxbase.tar.gz \
	&& tar -xzvf sphinxbase.tar.gz \
        && cd /build/sphinxbase-5prealpha \
	&& ./configure --enable-fixed \
	&& make \
	&& make install

RUN wget https://sourceforge.net/projects/cmusphinx/files/pocketsphinx/5prealpha/pocketsphinx-5prealpha.tar.gz/download -O pocketsphinx.tar.gz \
	&& tar -xzvf pocketsphinx.tar.gz \
        && cd /build/pocketsphinx-5prealpha \
	&& ./configure \
	&& make \
	&& make install

ENV FFMPEGVER https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz

RUN cd /build \
	&& wget "$FFMPEGVER" \
	&& tar xf ffmpeg-release-amd64-static.tar.xz

ENV FFMPEG_DIR /build/ffmpeg-release-amd64-static
ENV SPHINXBASE_DIR /build/sphinxbase-5prealpha
ENV POCKETSPHINX_DIR /build/pocketsphinx-5prealpha
ENV USE_PKG_CONFIG no

RUN apk add --no-cache py-pip \
	libffi-dev \
	openssl-dev \
	libgcc \
	ffmpeg-dev \
	py3-pybind11

RUN git clone -b '0.13' https://github.com/sc0ty/subsync.git /app/subsync
RUN cp /app/subsync/subsync/config.py.template /app/subsync/subsync/config.py
RUN sed -i '/wxPython>=4.0/d' /app/subsync/requirements.txt
RUN pip3 install -r /app/subsync/requirements.txt

WORKDIR /app/subsync/gizmo
RUN python3 setup.py build
RUN python3 setup.py install

WORKDIR /app/subsync
RUN pip3 install .

WORKDIR /

#COPY --from=builder /app .

# ports and volumes
EXPOSE 6767
VOLUME /config /data
