FROM nvidia/cuda:11.4.2-runtime-ubuntu20.04

FROM riazarbi/datasci-gui-minimal:20210920203321

LABEL authors="Riaz Arbi,Gordon Inggs"

USER root

# CUDA
# Special args for nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Delyno's request - can clean up later
#RUN add-apt-repository ppa:ubuntugis/ppa \
RUN apt-get update \
 && apt-get install -y python-numpy gdal-bin libgdal-dev \
 && pip install rasterio descartes

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

