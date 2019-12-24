FROM python

COPY requirements.txt /
COPY scripts/ /src/scripts/
RUN pip install -r /requirements.txt
