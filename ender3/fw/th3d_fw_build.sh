#!/bin/bash
#
# The script is to build TH3D Unified 2 Firmware (based on Marlin 2.0) for 
# Creality Ender 3 3D Printer.
#
# Style guide: https://google.github.io/styleguide/shellguide.html
#

# shellcheck disable=SC1090

readonly VENV_HOME="$HOME/th3d_fw_build"
# TH3D FW releases link https://github.com/th3dstudio/UnifiedFirmware/releases
readonly FW_FILE="TH3D_Unified2_Creality_Melzi.zip"
readonly FW_VERSION="latest" # specific fw version, e.g., 2.49 or latest
readonly FW_URL="https://github.com/th3dstudio/UnifiedFirmware/\
releases/${FW_VERSION}/download/${FW_FILE}"

purge_venv() {
  # If venv exists remove it
  if [ -d "$VENV_HOME" ]; then
    rm -rf "$VENV_HOME"
  fi
}

prepare_venv() {
  echo "Preparing build environment..."

  purge_venv

  # Setup platformio inside Python virtual environment
  if ! command -v python3; then
    echo "Python 3 is required to build the firmware. Please install it first."
    echo "Exiting..."
    exit 1
  fi
  
  if ! python3 -m venv "$VENV_HOME"; then
    exit 1
  fi
  
  # Ender 3 firmware config copy
  mkdir "$VENV_HOME/fw_config/"
  cp Configuration_Ender3.h Ender_bootscreen.h \
    Configuration_adv.patch marlinui.patch "$_"

  source "$VENV_HOME/bin/activate"
  python3 -m pip install --require-virtualenv -U platformio
}

get_fw() {
  echo "Downloading firmware..."

  mkdir -p "$VENV_HOME/download"
  cd "$_" || { echo "Can't change the directory. Exiting..."; exit 1; }
  wget -q "$FW_URL" -O "${FW_FILE}"
  unzip -q "${FW_FILE}"
}

build_fw() {
  echo "Building firmware..."

  cd "$VENV_HOME" || { echo "Can't change the directory. Exiting..."; exit 1; }
  local fw_config="download/Firmware/Marlin/Configuration.h"

  # By default Configuration.h is DOS text file
  dos2unix "$fw_config"
  
  # Prepare firmware configuration
  sed -i "/CONFIGURATION_H_VERSION/r fw_config/Configuration_Ender3.h" \
    $fw_config

  # Comment out needless parameters
  for pattern in \
    EZABL EXTRAPOLATE CUSTOM_ESTEPS HIGH_TEMP X_HOME Y_HOME LINEAR_ADVANCE; do
      sed -i "s|^#define $pattern|//&|" $fw_config
  done

  # Apply patch for Ender 3 more encoder smoothness
  patch -d "$VENV_HOME" -p 0 < fw_config/Configuration_adv.patch
  patch -d "$VENV_HOME" -p 0 < fw_config/marlinui.patch

  # Apply custom boot screen logo
  cp "fw_config/Ender_bootscreen.h" "download/Firmware/Marlin/_Bootscreen.h"

  # Build firmware
  if ! platformio run -e melzi -d download/Firmware/; then
    echo "Firmware build failure. Exiting..."
  fi
  mv download/Firmware/.pio/build/melzi/firmware.hex \
    "/tmp/firmware_${FW_VERSION}.hex"
  echo "Firmware has been successfuly builded: $_"
}

main() {
  prepare_venv
  get_fw
  build_fw
  read -n1 -r -p $'Do you wish to purge firmware build directory? [y/N]\n' answer
  case $answer in
    [Yy] ) echo "Cleaning up ${VENV_HOME}"; purge_venv;;
    * ) echo "Build directory ${VENV_HOME} has been left untouched"; exit 0;;
  esac
}

main "$@"
