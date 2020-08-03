FROM hotio/bazarr:unstable

# add local files

COPY root/ /


WORKDIR /build

RUN apk add git
	
RUN git clone -b '0.16' https://github.com/sc0ty/subsync.git /app/subsync
WORKDIR /
COPY app/ /app/
WORKDIR /app/subsync
RUN pip3 install -r /app/subsync/requirements.txt \
	&& pip3 install .

##COPY --from=builder /app .

# ports and volumes
EXPOSE 6767
VOLUME /config /data
