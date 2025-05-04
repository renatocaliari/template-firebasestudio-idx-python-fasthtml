{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.python311
    pkgs.nixfmt
  ];

  env = {
     PYTHONUNBUFFERED = "1"; # Ensures python print() and logs appear immediately
  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "ms-python.python"
      "rangav.vscode-thunder-client"
      "RooVeterinaryInc.roo-cline"
      "ms-python.debugpy"
    ];
    
    # Configure web previews: https://developers.google.com/idx/guides/previews
    previews = {
      # Enable previews globally
      enable = true;

      # Define individual previews
      previews = {
        web = {
          # --- Direct Uvicorn Command ---
          command = [
            ".venv/bin/python" # Chama o interpretador python
            "main.py"          # Executa seu script diretamente
           ];

          # --- Explicit port attribute REMOVED as linter rejects it ---
          # We rely on manager="web" to auto-detect the port from the process.

          # --- Environment Variables specifically for this Preview ---
          env = {
             # Add any other ENV VARS your specific application requires for the preview
          };

          # --- REMINDER: MODIFY YOUR FastHTML main.py CODE ---
          # You MUST remove the `serve()` call from the end of your `main.py`
          # or wrap it in `if __name__ == "__main__":` so it doesn't run when imported.

          manager = "web";
        };
        # Add other named previews here if needed
      }; # End of the 'previews' attribute set containing named previews

    }; # End of idx.previews

    # Workspace lifecycle hooks
    workspace = {
      # Runs ONCE when a workspace is first created.
      onCreate = {
        setup-venv = ''
          echo ">>> [onCreate] Creating Python virtual environment in .venv..."
          python3 -m venv .venv
          echo ">>> [onCreate] Installing initial dependencies from requirements.txt..."
          if [ -f ".venv/bin/pip" ]; then
            if [ -f "requirements.txt" ]; then
              .venv/bin/pip install -r requirements.txt
            else
              echo ">>> [onCreate] requirements.txt not found. Skipping initial install."
            fi
          else
             echo ">>> [onCreate] ERROR: .venv/bin/pip not found after creating venv."
          fi
          echo ">>> [onCreate] Initial setup complete."
        '';
      };

      # Runs EVERY time the workspace is (re)started.
      onStart = {
        install-deps = ''
          echo ">>> [onStart] Checking/installing Python dependencies..."
          if [ ! -d ".venv" ]; then
            echo ">>> [onStart] Virtual environment .venv not found. Attempting to create..."
            python3 -m venv .venv
          fi
          if [ -f ".venv/bin/pip" ]; then
            echo ">>> [onStart] Upgrading pip..."
            .venv/bin/pip install --upgrade pip
            if [ -f "requirements.txt" ]; then
              echo ">>> [onStart] Installing/updating dependencies from requirements.txt..."
              .venv/bin/pip install -r requirements.txt
            else
              echo ">>> [onStart] requirements.txt not found. Skipping dependency installation."
            fi
             echo ">>> [onStart] Dependency check complete."
             # --- Keep delay ---
             echo ">>> [onStart] Adding 5 second delay before preview starts..."
             sleep 5
          else
             echo ">>> [onStart] ERROR: .venv/bin/pip not found. Cannot install dependencies."
          fi
        '';
      };
    }; # End of idx.workspace
  };
}