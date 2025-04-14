# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.2
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

# === Install Node.js (LTS version recommended) ===
# Set desired Node.js version (e.g., 22 in early 2025)
# Check https://github.com/nodesource/distributions for current setup scripts
ARG NODE_MAJOR=22
ENV NODE_MAJOR=${NODE_MAJOR}

# Install dependencies needed for NodeSource setup and potentially other tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*


# Add NodeSource repository and install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
&& apt-get update && apt-get install -y nodejs \
&& rm -rf /var/lib/apt/lists/*
# Verify installation (optional, removed in final image)
# RUN node -v && npm -v && npx -v
# === End Node.js Installation ===

# Install dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nodejs postgresql-client libpq-dev \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*
