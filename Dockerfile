FROM hotio/bazarr:nightly AS base

ENV PATH="/venv/bin:$PATH"

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
	pip3 install virtualenv && \
	pip3 install wheel
	
RUN python3 -m venv /venv --without-pip

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


#ENV FFMPEG_DIR /build/ffmpeg
ENV SPHINXBASE_DIR /build/sphinxbase-5prealpha
ENV POCKETSPHINX_DIR /build/pocketsphinx-5prealpha
ENV USE_PKG_CONFIG no

RUN apk add --no-cache \
	libffi-dev \
	openssl-dev \
	libgcc \
	ffmpeg-dev \
	py3-pybind11-dev
	

RUN git clone -b '0.16' https://github.com/sc0ty/subsync.git /venv/subsync
WORKDIR /
#COPY app/ /app/
WORKDIR /venv/subsync
RUN pip3 install -r /venv/subsync/requirements.txt \
	&& pip3 install .
	

FROM hotio/bazarr:nightly AS img

ENV PATH="/venv/bin:$PATH"
ENV PATH="/venv/subsync/bin:$PATH"
COPY --from=base /venv /venv
COPY --from=base /usr/lib/python3.8/site-packages /venv/lib/python3.8/site-packages
COPY --from=base /usr/local/lib /usr/local/lib

RUN chmod -R 777 /root


## ports and volumes
EXPOSE 6767
VOLUME /config /data
