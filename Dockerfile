FROM counterparty/base

MAINTAINER Counterparty Developers <dev@counterparty.io>

# Install (pip will effectively run `setup.py develop` for us)
COPY . /counterparty-lib
WORKDIR /counterparty-lib
RUN pip3 install -r requirements.txt
RUN python3 setup.py install_apsw
RUN python3 setup.py install_serpent

COPY docker/server.conf /root/.config/counterparty/server.conf
COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod a+x /usr/local/bin/start.sh

# Install counterparty-cli (pip will effectively run `setup.py develop` for us)
# NOTE: By default, check out the counterparty-cli master branch. You can override the BRANCH build arg for a different
# branch (as you should check out the same branch as what you have with counterparty-lib, or a compatible one)
# NOTE2: In the future, counterparty-lib and counterparty-cli will go back to being one repo...
ARG CLI_BRANCH=master
ENV CLI_BRANCH ${CLI_BRANCH}
RUN git clone -b ${CLI_BRANCH} https://github.com/CounterpartyXCP/counterparty-cli.git /counterparty-cli
WORKDIR /counterparty-cli
RUN pip3 install -r requirements.txt

EXPOSE 4000 4001

# NOTE: Defaults to running on mainnet, specify -e TESTNET=1 to start up on testnet
ENTRYPOINT ["start.sh"]
