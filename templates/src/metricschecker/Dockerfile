FROM python:3-slim as base

FROM base as builder

RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        g++

# Install dependencies
RUN pip install kubernetes

# Copy Python script
COPY . .

# Command to run the script
CMD ["python", "metrics_checker.py"]
