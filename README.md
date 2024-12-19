# oneapi-verify-headroom

A testing framework to verify different versions of Intel OneAPI runtime.

## Background

This repository was created to investigate IGC (Intel Graphics Compiler) compatibility issues with different OneAPI versions on the headroom system. The current issue appears to be related to outdated IGC versions affecting newer OneAPI releases.

### Current Status

Current test results show issues with newer OneAPI versions:
```
Test Summary:
OneAPI 2024.0 - SUCCESS: 2, FAIL: 0
OneAPI 2024.2 - SUCCESS: 1, FAIL: 1
OneAPI 2025.0 - SUCCESS: 1, FAIL: 1
```

### Expected Results

After updating the Intel Base Toolkit (particularly IGC), all tests should pass:
```
Test Summary:
OneAPI 2024.0 - SUCCESS: 2, FAIL: 0
OneAPI 2024.2 - SUCCESS: 2, FAIL: 0
OneAPI 2025.0 - SUCCESS: 2, FAIL: 0
```

## Known Issues

1. IGC version compatibility:
   - Current IGC version dates back to June 2023 (`libigc.so.1.0.13822.8`)
   - Newer OneAPI releases (2024.2 and 2025.0) require updated IGC versions
   - Debug builds (-g flag) are particularly affected

2. Specific problems:
   - 2024.2: Debug build fails with SPIRV-related IGC error
   - 2025.0: Debug build fails with segmentation fault

## Usage

Run the test script:
```bash
bash cmd
```

This will:
1. Test each version of OneAPI (2024.0, 2024.2, 2025.0)
2. For each version, compile and run tests with and without debug flag (-g)
3. Generate test results in `build/` directory:
   - Executables: `single.sycloffload.icpx.intelgpu<version>[-g]`
   - Log files: `logs/log_<version>.txt`

## Output

Each log file contains:
- Build output
- Runtime output
- Success/Failure status for each test

Example log file name: `log_2024.0.txt`
