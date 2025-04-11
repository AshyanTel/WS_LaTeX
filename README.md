
# LaTeX Compile Script

## Description

A simple Bash script to compile LaTeX projects.

### Features
- Takes a `.tex` file as input and compiles it using `pdflatex`.
- Output directories:
  - `build` for PDFs (with timestamped names).
  - `debug` for logs (with timestamped names).
  - `temp` symlink pointing to the latest build.
- Auto-cleans: Keeps only the last **5** PDFs and logs.
- Symbolic links to the latest PDF and logs are created for easy access.
- Works seamlessly from any directory when run via terminal.

>[!IMPORTANT]
>Ensure the script is called with the correct path when using VS Code tasks (absolute or `realpath`).

> [!NOTE]
> Fancy output with Nerd Font symbols (suggested font: [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)).

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/AshyanTel/latex_workspace_config new_workspace
    cd new_workspace
    ```

2. Ensure `pdflatex` is installed on your system:

3. Install [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads) for the fancy symbols (optional but recommended).

## Usage

To compile a `.tex` file, run the script with the file path as an argument:

```bash
./compile.sh path/to/yourfile.tex
```

The script will:
- Compile the LaTeX file and generate a PDF in the `build` directory.
- Place logs and auxiliary files in `debug`.
- Clean up old files, keeping only the last 5 PDFs and logs.

>[!TIP]
> By editing the script you can increase the amount of each kept.

## Example with VS Code

To integrate the script with VS Code, set up a custom task:

1. Open `tasks.json` in your VS Code workspace's `.vscode/` folder.
2. Add the following task configuration:

    ```json
    {
        "version": "2.0.0",
        "tasks": [
            {
                "label": "Compile LaTeX",
                "type": "shell",
                "command": "./compile.sh",
                "args": [
                    "${file}"
                ],
                "problemMatcher": [],
                "group": {
                    "kind": "build",
                    "isDefault": true
                },
                "presentation": {
                    "echo": true,
                    "reveal": "always",
                    "focus": false,
                    "panel": "shared"
                }
            }
        ]
    }
    ```

This will allow you to compile LaTeX files directly from VS Code using the `triangle` button.

If you use LaTeX Workshop add this to your `settings.json`.
```bash
    "latex-workshop.latex.recipes": [

            {
                "name": "Compile avec compile.sh",
                "tools": [
                    "compile.sh"
                ]
        }
    ]
```
And this too.
```bash
    "latex-workshop.latex.tools": [
            {
                "name": "compile.sh",
                "command": "sh",
                "args": [
                    "../compile.sh",
                    "%DOCFILE%"
                ]
            }
    ]
```

>[!WARNING]
> Those are made to work when `compile.sh` is at your root workspace directory. And your `.tex` file in a `src` folder. However, if you don't use those path, it won't work at all.
> In that case just use the script in your terminal.

## Cleanup

The script automatically cleans up old PDF and log files:
- **PDFs**: Only the last 5 PDFs are kept in the `build` directory.
- **Logs**: Only the last 5 log files are kept in the `debug` directory.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
