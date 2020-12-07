FROM riazarbi/datasci-gui-minimal:focal

LABEL authors="Riaz Arbi,Gordon Inggs"

USER root

# CUDA
# Special args for nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

COPY cuda_setup.sh .
RUN bash cuda_setup.sh

# OpenCL
# POCL
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install -y pocl-opencl-icd opencl-headers clinfo

# Nvidia ICD
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install -y nvidia-opencl-icd-340 nvidia-opencl-dev


# Install packages
RUN python3 -m pip install --upgrade torch torchvision fastai \
 && python3 -m pip install --upgrade tensorflow \
 && python3 -m pip install --upgrade Keras \
 && python3 -m pip install --upgrade scikit-image \
 && python3 -m pip install --upgrade xgboost \
 && python3 -m pip install  --upgrade catboost \
 && python3 -m pip install  --upgrade plotly==4.13.0 \
 && python3 -m pip install  --upgrade opencv-contrib-python \
 && python3 -m pip install  --upgrade geopandas \
 && python3 -m pip install  --upgrade pymc3 \
 && python3 -m pip install -q tensorflow_data_validation[visualization] \
 && python3 -m pip install  --upgrade  imutils \
 && python3 -m pip install  --upgrade  rioxarray \
 && python3 -m pip install  --upgrade  earthpy

USER $NB_USER

