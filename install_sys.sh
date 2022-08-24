#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

url-installer() {
    echo "https://raw.githubusercontent.com/Twilight4/arch-install/master"
}
