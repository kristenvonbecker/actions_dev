FROM rasa/rasa-sdk:3.5.1

USER root

RUN apt-get update && \
    apt-get install -y curl bzip2  && \
    curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > /tmp/conda.sh && \
    bash /tmp/conda.sh -b -p /opt/conda
    /opt/conda/bin/conda update -n base conda && \
    /opt/conda/bin/conda install -y -c pytorch faiss-cpu && \
    apt-get remove -y --auto-remove curl bzip2 && \
    apt-get clean && \
    rm -fr /tmp/conda.sh

ENV PATH="/opt/conda/bin:$PATH"

WORKDIR /app

COPY ./requirements-actions.txt requirements.txt
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

USER 1001

EXPOSE 5055

ENTRYPOINT ["python", "-m", "rasa_sdk", "--actions", "actions"]
