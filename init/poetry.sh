#!/bin/bash

# Define Poetry installation directory
POETRY_DIR="/workspace/apps/poetry"

# Function to install Poetry
install_poetry() {
    echo "    Installing Poetry..."
    curl -sSL https://install.python-poetry.org | POETRY_HOME=${POETRY_DIR} python3 -

    echo "    Poetry installed."
}

# Check if Poetry directory exists
if [ -d "$POETRY_DIR" ]; then
    echo "    Checking Poetry installation..."

    # Check if Poetry executable exists
    POETRY_CMD="$POETRY_DIR/bin/poetry"
    if [ -x "$POETRY_CMD" ]; then
        INSTALLED_VERSION=$($POETRY_CMD --version 2>/dev/null)
        if [ -n "$INSTALLED_VERSION" ]; then
            echo "    Poetry is installed: $INSTALLED_VERSION"
            exit 0
        else
            echo "    Poetry executable found, but version check failed."
        fi
    else
        echo "    Poetry executable not found in $POETRY_DIR."
    fi

    # Remove the existing Poetry installation
    echo "    Removing existing Poetry installation..."
    rm -rf "$POETRY_DIR"
fi

# Install Poetry if not found
install_poetry

# Verify installation
if [ -x "$POETRY_DIR/bin/poetry" ]; then
    echo "    Poetry installation successful."
    $POETRY_DIR/bin/poetry --version
else
    echo "    Poetry installation failed."
    exit 1
fi
