# RustyBox - Rust Development Container

## Pulling the Image

### **For Windows Users**
If you are using Windows (with WSL or native Docker), you can pull and run the image with:
```powershell
# Pull the prebuilt image
docker pull your-dockerhub-username/rustybox:latest

# Run the container
docker run -it your-dockerhub-username/rustybox /bin/bash
```

## Building the Image

### **For macOS Users**
If you are on macOS and need to build the image for multiple architectures (like `amd64` for Intel Macs and `arm64` for Apple Silicon Macs), use Docker Buildx:
```bash
# Ensure Buildx is enabled
docker buildx create --use

# Build and push multi-architecture image
docker buildx build --platform linux/amd64,linux/arm64 -t your-dockerhub-username/rustybox:latest --push .
```

### **For Standard macOS Build (Single Architecture)**
If you only need to build for your current architecture (either `amd64` or `arm64`), use:
```bash
docker build -t your-dockerhub-username/rustybox .
```

## Running the Container
After building or pulling, run the container interactively:
```bash
docker run -it your-dockerhub-username/rustybox /bin/bash
```

This will start the container with a shell where you can develop using Rust.

Let me know if you need more details or adjustments!

