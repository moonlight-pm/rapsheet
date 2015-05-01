FROM quay.io/naturalethic/tinynode
RUN cd /home/tc \
    && npm install dev-coop/rapsheet \
    && mv node_modules/rapsheet . \
    && rmdir node_modules
ADD host.ls.docker /home/tc/rapsheet/host.ls
WORKDIR /home/tc/rapsheet
CMD ["sudo", "/home/tc/rapsheet/node_modules/olio/bin/olio", "api"]