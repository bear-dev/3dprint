#!/bin/bash
#
# The script is to build TH3D Unified 2 Firmware (based on Marlin 2.0) for 
# Creality Ender 3 3D Printer.
#
# Style guide: https://google.github.io/styleguide/shellguide.html
#

VENV_HOME="$HOME/th3d_fw_build"
# TH3D FW releases link https://github.com/th3dstudio/UnifiedFirmware/releases
FW_FILE="TH3D_Unified2_Creality_Melzi.zip"
FW_VERSION="latest" # specific fw version, e.g., 2.49 or latest
FW_URL="https://github.com/th3dstudio/UnifiedFirmware/releases/${FW_VERSION}/
download/${FW_FILE}"

prepare_venv() {
  # If venv exists remove it first
  if [ -d "$VENV_HOME" ]; then
    rm -rf "$VENV_HOME"
  fi
  
  # Setup platformio inside Python virtual environment
  if ! command -v python3; then
    echo "Python 3 is required to build the firmware. Please install it first."
    echo "Exiting..."
    exit 1
  fi
  
  if ! python3 -m venv "$VENV_HOME"; then
    exit 1
  fi
  
  mkdir "$VENV_HOME/fw_config"
  cp Configuration_Ender3.h "$VENV_HOME/fw_config/"

  source "$VENV_HOME/bin/activate"
  python3 -m pip install --require-virtualenv -U platformio
}

get_fw() {
  mkdir download && cd $_
  wget "$FW_URL" -O "${FW_FILE}"
  unzip "${FW_FILE}"
}

prepare_venv
get_fw
