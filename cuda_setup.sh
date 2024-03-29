#!/usr/bin/env bash

# Taken from here: https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/10.0/base/Dockerfile
# Base

export NVARCH=x86_64
export NVIDIA_REQUIRE_CUDA="cuda>=11.1 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450"
export NV_CUDA_CUDART_VERSION=11.1.74-1
export NV_CUDA_COMPAT_PACKAGE=cuda-compat-11-1

export NV_ML_REPO_ENABLED=1
export NV_ML_REPO_URL=https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/${NVARCH}

apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    if [ ! -z ${NV_ML_REPO_ENABLED} ]; then echo "deb ${NV_ML_REPO_URL} /" > /etc/apt/sources.list.d/nvidia-ml.list; fi && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

export CUDA_VERSION=11.1.1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-1=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && ln -s cuda-11.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

COPY NGC-DL-CONTAINER-LICENSE /

# Runtime
export NV_CUDA_LIB_VERSION=11.1.1-1

export NV_NVTX_VERSION=11.1.74-1
export NV_LIBNPP_VERSION=11.1.2.301-1
export NV_LIBNPP_PACKAGE=libnpp-11-1=${NV_LIBNPP_VERSION}
export NV_LIBCUSPARSE_VERSION=11.3.0.10-1

export NV_LIBCUBLAS_PACKAGE_NAME=libcublas-11-1
export NV_LIBCUBLAS_VERSION=11.3.0.106-1
export NV_LIBCUBLAS_PACKAGE=${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}

export NV_LIBNCCL_PACKAGE_NAME=libnccl2
export NV_LIBNCCL_PACKAGE_VERSION=2.8.4-1
export NCCL_VERSION=2.8.4-1
export NV_LIBNCCL_PACKAGE=${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda11.1

apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-1=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    cuda-nvtx-11-1=${NV_NVTX_VERSION} \
    libcusparse-11-1=${NV_LIBCUSPARSE_VERSION} \
    ${NV_LIBCUBLAS_PACKAGE} \
    ${NV_LIBNCCL_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME}

# Devel
export NV_CUDA_LIB_VERSION="11.1.1-1"

export NV_CUDA_CUDART_DEV_VERSION=11.1.74-1
export NV_NVML_DEV_VERSION=11.1.74-1
export NV_LIBCUSPARSE_DEV_VERSION=11.3.0.10-1
export NV_LIBNPP_DEV_VERSION=11.1.2.301-1
export NV_LIBNPP_DEV_PACKAGE=libnpp-dev-11-1=${NV_LIBNPP_DEV_VERSION}

export NV_LIBCUBLAS_DEV_VERSION=11.3.0.106-1
export NV_LIBCUBLAS_DEV_PACKAGE_NAME=libcublas-dev-11-1
export NV_LIBCUBLAS_DEV_PACKAGE=${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

export NV_LIBNCCL_DEV_PACKAGE_NAME=libnccl-dev
export NV_LIBNCCL_DEV_PACKAGE_VERSION=2.8.4-1
export NCCL_VERSION=2.8.4-1
export NV_LIBNCCL_DEV_PACKAGE=${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda11.1

apt-get update && apt-get install -y --no-install-recommends \
    libtinfo5 libncursesw5 \
    cuda-cudart-dev-11-1=${NV_CUDA_CUDART_DEV_VERSION} \
    cuda-command-line-tools-11-1=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-11-1=${NV_CUDA_LIB_VERSION} \
    cuda-libraries-dev-11-1=${NV_CUDA_LIB_VERSION} \
    cuda-nvml-dev-11-1=${NV_NVML_DEV_VERSION} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    libcusparse-dev-11-1=${NV_LIBCUSPARSE_DEV_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}
