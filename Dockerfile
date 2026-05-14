# ─────────────────────────────────────────────
#  Base: NVIDIA CUDA image (CPU-only devices
#  can still use this image fine; the CUDA
#  libs are simply unused).
# ─────────────────────────────────────────────
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install Python & essentials
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3-pip \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Make python3.11 the default python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Upgrade pip
RUN pip install --upgrade pip

# ─────────────────────────────────────────────
#  Install PyTorch (CUDA 12.1 build — works on
#  CPU-only too, just uses the CPU backend)
# ─────────────────────────────────────────────
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Common data-science extras
RUN pip install \
    jupyterlab \
    notebook \
    ipywidgets \
    numpy \
    pandas \
    matplotlib \
    scikit-learn \
    tqdm

# Create working directory inside container
WORKDIR /workspace

# Expose Jupyter port
EXPOSE 8888

# Start JupyterLab (no token/password — fine for local dev)
CMD ["jupyter", "lab", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--NotebookApp.token=''", \
     "--NotebookApp.password=''"]
