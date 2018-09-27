FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -q -y \
			autoconf \
			automake \
			curl \
	    git \
			libssl-dev \
			libtool \
			pkg-config \
			python-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Watchman
ENV WATCHMAN_VERSION v4.9.0
RUN	git clone https://github.com/facebook/watchman.git \
		&& cd watchman \
		&& git checkout ${WATCHMAN_VERSION} \
		&& ./autogen.sh \
		&& ./configure \
		&& make -j$(nproc) \
		&& make install

# Install Node.js
ENV NODE_VERSION 10
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
		&& apt-get install -y \
			nodejs \
		&& rm -rf /var/lib/apt/lists/*

# Install Nuclide Remote Server
ENV NUCLIDE_VERSION 0.351.0
RUN npm install -g nuclide@${NUCLIDE_VERSION}

# Run nuclide-start-server
ENTRYPOINT ["nuclide-start-server"]
