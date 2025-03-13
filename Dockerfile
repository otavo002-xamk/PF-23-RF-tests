FROM python:3 AS base-image

RUN pip install \
    robotframework \
    robotframework-jsonlibrary \
    robotframework-seleniumlibrary && \
    apt-get update && apt-get install -y \
    libasound2 \
    libgtk-3-0 \
    libpango1.0-0 \
    wget \
    xdg-utils \
    xvfb && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

FROM base-image AS geckodriver-image

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.36.0/geckodriver-v0.36.0-linux64.tar.gz \
    && tar -xvzf geckodriver-v0.36.0-linux64.tar.gz \
    && mv geckodriver /usr/local/bin/ \
    && rm geckodriver-v0.36.0-linux64.tar.gz

FROM geckodriver-image

RUN apt-get update && apt-get install -y mariadb-client && rm -rf /var/lib/apt/lists/*

# Set environment variables for headless Firefox
ENV DISPLAY=:99

WORKDIR /app
COPY ./Portfolio-2023-RPA-tests /app

RUN useradd -m appuser
USER appuser

# Start Xvfb and run tests with headless Firefox
SHELL ["/bin/bash", "-c"]
CMD Xvfb :99 -screen 0 1920x1080x24 & \
    sleep 3 && \
    robot --variable BROWSER:headlessfirefox Database.robot Math_Game.robot NASA_API.robot Slideshow.robot static_parts.robot \
    --exclude with_no_connection && pkill Xvfb