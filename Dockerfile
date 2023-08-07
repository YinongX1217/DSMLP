# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/scipy-ml-notebook:2023.2-stable

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

# 2) change to root to install packages
USER root

RUN apt-get update && apt-get -y install g++

# 3) install packages using notebook user
USER jovyan

#Copy the environment file into the Docker image
COPY e4e_env.yaml /tmp/e4e_env.yaml
#Create the conda environment from the file
RUN conda env create -f /tmp/e4e_env.yaml

# Activate the environment (replace e4e_env with the name of your environment)
# and install additional packages
RUN /bin/bash -c "source activate e4e_env && \
    conda install -c conda-forge dlib && \
    python3 -m pip install cmake"

#Copy the environment file into the Docker image
#COPY e4e_env.yaml /tmp/e4e_env.yaml

#RUN conda env create -f /tmp/e4e_env.yaml
#RUN conda create --name e4e_env --file /tmp/e4e_env.yaml
#RUN conda install --name e4e_env -c conda-forge cudatoolkit scipy

# Activate the environment and install additional packages
#RUN echo "source activate e4e_env" > ~/.bashrc
#ENV PATH /opt/conda/envs/e4e_env/bin:$PATH

# Install dlib and cmake
RUN conda install -c conda-forge dlib
RUN pip install cmake

# RUN conda install -y scikit-learn

# RUN pip install --no-cache-dir networkx scipy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
