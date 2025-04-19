# Setting Up Docker Desktop on Windows (with WSL)

## Steps to Install Docker Desktop

### Step 1: Install Docker Desktop

1. Once the Docker Desktop installer is downloaded, run the `.exe` file to begin the installation process.
2. During the installation, make sure to select the option to enable WSL 2 integration.
3. The installer will automatically install Docker Desktop and all necessary dependencies.
4. After installation is complete, launch Docker Desktop from the Start menu.

### Step 2: Configure Docker to Use WSL 2

1. Open Docker Desktop.
2. Click the **Settings** gear icon in the top-right corner of the Docker Desktop window.
3. In the settings menu, navigate to **General** and ensure that the WSL 2 option is enabled under the **Use the WSL 2 based engine**.
4. Under **Resources** > **WSL Integration**, enable integration with your desired WSL distros (e.g., Ubuntu).

### Step 3: Verify Docker Installation

1. Open your WSL terminal (e.g., Ubuntu, Debian, etc.).
2. Type the following command to verify Docker is installed and running:
   ```bash
   docker --version
   ```
   You should see the version of Docker installed.
3. Run a simple test to verify Docker is working:
   ```bash
   docker run hello-world
   ```
   This will download and run the "hello-world" Docker image and display a message confirming Docker is correctly installed.

### Step 4: Additional Configuration (Optional)

- You can configure the amount of CPU, memory, and disk space Docker Desktop uses by going to **Settings** > **Resources**.
- Docker Desktop provides a graphical interface for managing containers, images, volumes, and more. You can access it from the Docker Desktop application.

## Troubleshooting

- **WSL Version Issues**: If Docker Desktop asks you to switch to WSL 2, ensure your WSL version is set correctly by running:
  ```bash
  wsl --set-default-version 2
  ```


##

##

- Open Ubuntu (or whatever distro you have hooked to docker) 
- run -> docker login
- login through the webpage that pops up, if it's not there then cli must have a url usko copy paste krlena

- run -> docker pull jinha1ba/rustybox


##

