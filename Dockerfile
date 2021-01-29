FROM continuumio/miniconda3

# Create conda environment and configure the shell to use it
# Info: https://pythonspeed.com/articles/activate-conda-dockerfile/
COPY environment.yml .
RUN conda env create -f environment.yml -n nazgul && rm environment.yml

# TODO remove installation via dubmodule
SHELL ["conda", "run", "-n", "nazgul", "/bin/bash", "-c"]
COPY nauron nauron
RUN pip install -e nauron/
# Restore original shell and define entrypoint
SHELL ["/bin/bash", "-c"]

WORKDIR /var/log/nazgul
WORKDIR /nazgul
VOLUME /nazgul/models

COPY . .

ENTRYPOINT conda run --no-capture-output -n nazgul \
python bert_ner_nazgul.py