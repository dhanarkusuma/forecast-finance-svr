# Jupyter Docker Setup — CPU & GPU

## Project structure

```
your-project/
├── Dockerfile
├── docker-compose.yml
├── README.md
└── notebooks/          ← your notebooks live here (auto-created on first run)
```

---

## 1. Prerequisites

| Device | What you need |
|--------|--------------|
| Both   | Docker Desktop (or Docker Engine) + Docker Compose v2 |
| GPU    | [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) |

Verify GPU host setup:
```bash
nvidia-smi          # should list your GPU
docker run --rm --gpus all nvidia/cuda:12.1.1-base-ubuntu22.04 nvidia-smi
```

---

## 2. Build the image (once, on each device)

```bash
# Build CPU service
docker compose --profile cpu build

# Build GPU service
docker compose --profile gpu build

# Or build BOTH at once
docker compose --profile cpu --profile gpu build
```

---

## 3. Run

### On the CPU device
```bash
docker compose --profile cpu up
```

### On the GPU device
```bash
docker compose --profile gpu up
```

Then open your browser at: **http://localhost:8888**

---

## 4. Verify GPU inside Jupyter

Run this in a notebook cell:

```python
import torch
print("CUDA available:", torch.cuda.is_available())
print("Device count :", torch.cuda.device_count())
if torch.cuda.is_available():
    print("GPU name     :", torch.cuda.get_device_name(0))
```

---

## 5. Useful commands

```bash
# Stop the container
docker compose --profile cpu down     # or --profile gpu

# Rebuild after changing Dockerfile
docker compose build --no-cache

# Open a shell inside the running container
docker exec -it jupyter-cpu bash      # or jupyter-gpu
```

---

## Notes

- Notebooks are saved to `./notebooks/` on your host — same folder on both devices.
- No token/password is set (local dev only). Add `--NotebookApp.token='secret'` to the CMD in Dockerfile if you expose the port externally.
- The same Docker image works on both machines; CUDA libs are simply unused when no GPU is present.
