# base-container-template

This project provides a **ready-to-use container image** for running Python code and Jupyter notebooks.  
It includes system dependencies (ODBC 18 driver, etc.) and is easily extensible via `requirements.txt` and the `Dockerfile`.

---

## Getting Started

### Prerequisites
- [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) installed and running  
- (Optional but recommended) [VS Code](https://code.visualstudio.com/) with:
  - **Python extension**
  - **Jupyter extension**

### 1. Allow your WSL user to run Docker
```bash
# Replace <user_name> with your WSL username
sudo usermod -aG docker <user_name>
exec su -l <user_name>   # restart your shell/session
```

### 2. Build the container
Navigate to the directory containing your `Dockerfile`:
```bash
cd <PATH TO DOCKERFILE PARENT DIRECTORY>
docker build -t base-container-image .
```

### 3. Run Jupyter inside the container
```bash
docker run -it --rm   -v "$(pwd)":/app   -p 8888:8888   base-container-image   jupyter server --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token=''
```

This launches a Jupyter server on [http://localhost:8888](http://localhost:8888).  
Because the token is set to `''`, no authentication is required (fine for local dev — not safe for shared environments).

### 4. Connect from VS Code
- Open your `.ipynb` file in VS Code  
- Click **Select Kernel** → **Existing Jupyter Server**  
- Enter the URL:  
  ```
  http://localhost:8888
  ```
- Give it a name (e.g., `python_kernel`)

---

## Running Python Scripts

You don’t have to use Jupyter — you can also run scripts directly against the container.

1. Find the running container:
   ```bash
   docker ps
   ```
   Note the **CONTAINER ID**.

2. Open a shell inside it:
   ```bash
   docker exec -it <container_id> bash
   ```

3. Navigate to your file and run it:
   ```bash
   cd /app/src
   python3 your_script.py
   ```

---

## Customizing the Container

- **Python dependencies** → edit `requirements.txt`  
- **System dependencies** → edit `Dockerfile` (e.g., add `apt-get install` lines)

Rebuild the image after changes:
```bash
docker build -t base-container-image .
```

---

##  Notes
- Always restart your WSL session after adding your user to the `docker` group.  
- For production use, configure a secure Jupyter token or password.  
- Mounts: the current working directory on the host (`$(pwd)`) is mounted into `/app` inside the container.
