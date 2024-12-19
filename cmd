#!/bin/bash

# Function to test one OneAPI version
test_oneapi_version() {
   VERSION=$1
   echo "Testing OneAPI ${VERSION}"
   . /opt/intel/oneapi/${VERSION}/oneapi-vars.sh --force

   success_count=0
   fail_count=0

   {
       echo "Testing OneAPI ${VERSION}"
       echo "======================================"

       echo -e "\nBuilding and running without -g"
       icpx -O2 -fsycl -fiopenmp -lm -fopenmp-targets=spir64 -o ./build/single.sycloffload.icpx.intelgpu${VERSION} ./src/single.cc ./src/syclgpu.cc
       if ./build/single.sycloffload.icpx.intelgpu${VERSION}; then
           echo "[SUCCESS] Run without -g completed successfully"
           success_count=$((success_count + 1))
       else
           echo "[FAIL] Run without -g failed"
           fail_count=$((fail_count + 1))
       fi

       echo "======================================"
       
       echo -e "\nBuilding and running with -g"
       icpx -g -O2 -fsycl -fiopenmp -lm -fopenmp-targets=spir64 -o ./build/single.sycloffload.icpx.intelgpu${VERSION}-g ./src/single.cc ./src/syclgpu.cc
       if ./build/single.sycloffload.icpx.intelgpu${VERSION}-g; then
           echo "[SUCCESS] Run with -g completed successfully"
           success_count=$((success_count + 1))
       else
           echo "[FAIL] Run with -g failed"
           fail_count=$((fail_count + 1))
       fi
       
       echo "======================================"
   } >& ./build/logs/log_${VERSION}.txt

   RESULTS="${RESULTS}OneAPI ${VERSION} - SUCCESS: ${success_count}, FAIL: ${fail_count}\n"
}

# Check and remove existing build directory
if [ -d "build" ]; then
   rm -rf build
fi

mkdir -p build/logs

# Test each version
RESULTS=""
test_oneapi_version "2024.0"
test_oneapi_version "2024.2"
test_oneapi_version "2025.0"

# Print final report
echo -e "\nTest Summary:"
echo -e "${RESULTS}"