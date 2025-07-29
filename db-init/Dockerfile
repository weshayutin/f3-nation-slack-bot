FROM python:3.12

# Install git for cloning the repository
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Set Poetry configuration
ENV POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Set working directory
WORKDIR /f3-data-models

# Clone the F3-Data-Models repository
RUN git clone https://github.com/F3-Nation/F3-Data-Models.git . && \
    rm -rf .git

# Install dependencies
RUN poetry env use python3.12 && \
    poetry install && \
    rm -rf $POETRY_CACHE_DIR

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"] 