FROM python:3

# Install Robot Framework and SeleniumLibrary
RUN pip install robotframework robotframework-seleniumlibrary

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpango1.0-0 \
    xdg-utils \
    wget \
    xvfb \
    libgtk-3-0 \
    libasound2

# Install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.35.0/geckodriver-v0.35.0-linux64.tar.gz \
    && tar -xvzf geckodriver-v0.35.0-linux64.tar.gz \
    && mv geckodriver /usr/local/bin/ \
    && rm geckodriver-v0.35.0-linux64.tar.gz

# Set environment variables for headless Firefox
ENV DISPLAY=:99

WORKDIR /app
COPY ./Portfolio-2023-RPA-tests /app

# Start Xvfb and run tests with headless Firefox
CMD Xvfb :99 -screen 0 1920x1080x24 & \
    sleep 3 && \
    robot --variable BROWSER:headlessfirefox Slideshow.robot && \
    pkill Xvfb