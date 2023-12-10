FROM python:3.8.1-slim-buster

# Install OS dependencies
RUN apt-get update && apt-get install -qq -y \
    git gcc build-essential libpq-dev --fix-missing --no-install-recommends \
    && apt-get clean

# Make sure we are using latest pip
RUN pip install --upgrade pip

# Create directory for dbt config
RUN mkdir -p /root/.dbt

# Copy requirements.txt
COPY requirements.txt requirements.txt

# Install dependencies
RUN pip install -r requirements.txt

# Copy source code
COPY jaffle_shop/ .


RUN chmod -R 755 scripts/

# we run everything through sh, so we can execute all we'd like
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD ["dbt_container_init_commands.sh.sh"]