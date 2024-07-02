FROM sonroyaalmerol/steamcmd-arm64:root AS build_stage

LABEL maintainer="ponfertato@ya.ru"
LABEL description="A Dockerised version of the Day of Defeat: Source dedicated server for ARM64 (using box86)"

RUN dpkg --add-architecture amd64 \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    net-tools \
    lib32gcc-s1:amd64 \
    lib32stdc++6 \
    lib32z1 \
    libcurl3-gnutls:i386 \
    libcurl4-gnutls-dev:i386 \
    libcurl4:i386 \
    libgcc1 \
    libncurses5:i386 \
    libsdl1.2debian \
    libtinfo5 \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm libssl1.1_1.1.1f-1ubuntu2_i386.deb \
    && rm -rf /var/lib/apt/lists/*

ENV HOMEDIR="/home/steam" \
    STEAMAPPID="232290" \
    STEAMAPPDIR="/home/steam/dods-server"

COPY etc/entry.sh ${HOMEDIR}/entry.sh

WORKDIR ${STEAMAPPDIR}

RUN chmod +x "${HOMEDIR}/entry.sh" \
    && chown -R "${USER}":"${USER}" "${HOMEDIR}/entry.sh" ${STEAMAPPDIR}

FROM build_stage AS bookworm-root

ENV DODS_ARGS="" \
    DODS_CLIENTPORT="27005" \
    DODS_IP="" \
    DODS_LAN="0" \
    DODS_MAP="dod_anzio" \
    DODS_MAXPLAYERS="12" \
    DODS_PORT="27015" \
    DODS_SOURCETVPORT="27020" \
    DODS_TICKRATE=""

EXPOSE ${DODS_CLIENTPORT}/udp \
    ${DODS_PORT}/tcp \
    ${DODS_PORT}/udp \
    ${DODS_SOURCETVPORT}/udp

USER ${USER}
WORKDIR ${HOMEDIR}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD netstat -l | grep "${DODS_PORT}.*LISTEN"

CMD ["bash", "entry.sh"]