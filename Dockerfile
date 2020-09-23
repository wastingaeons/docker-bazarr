FROM hotio/bazarr:unstable

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
	mkdir /build && cd /build && \
	wget https://sourceforge.net/projects/cmusphinx/files/sphinxbase/5prealpha/sphinxbase-5prealpha.tar.gz/download -O sphinxbase.tar.gz \
		 && tar -xzvf sphinxbase.tar.gz \
			&& cd /build/sphinxbase-5prealpha \
		&& ./configure --enable-fixed \
		&& make \
		&& make install && cd .. && \
	wget https://sourceforge.net/projects/cmusphinx/files/pocketsphinx/5prealpha/pocketsphinx-5prealpha.tar.gz/download -O pocketsphinx.tar.gz \
		&& tar -xzvf pocketsphinx.tar.gz \
		&& cd /build/pocketsphinx-5prealpha \
		&& ./configure \
		&& make \
		&& make install && \
		
		mkdir /build/ffmpeg && \ 
		cd /build \
			&& wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
			&& tar xf ffmpeg-release-amd64-static.tar.xz --directory ffmpeg/ && \

	apk add --no-cache \
	libffi-dev \
	openssl-dev \
	libgcc \
	ffmpeg-dev \
	py3-pybind11-dev && \
	
	git clone -b '0.16' https://github.com/sc0ty/subsync.git /app/subsync && \
	cd /app/subsync && \
	pip3 install -r /app/subsync/requirements.txt \
	&& pip3 install . && \
	rm -rf /build && \
	apk del build-base


ENV FFMPEG_DIR /build/ffmpeg
ENV SPHINXBASE_DIR /build/sphinxbase-5prealpha
ENV POCKETSPHINX_DIR /build/pocketsphinx-5prealpha
ENV USE_PKG_CONFIG no



#COPY --from=builder /app .

# ports and volumes
EXPOSE 6767
VOLUME /config /data
