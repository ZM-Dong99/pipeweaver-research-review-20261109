```
  _____    _______   _                  ____    _____    _______ 
 |  __ \  |__   __| | |                / __ \  |  __ \  |__   __|
 | |__) |    | |    | |       ______  | |  | | | |__) |    | |   
 |  _  /     | |    | |      |______| | |  | | |  ___/     | |   
 | | \ \     | |    | |____           | |__| | | |         | |   
 |_|  \_\    |_|    |______|           \____/  |_|         |_|   
```                                                                 
                                                                 
# RTL-OPT: A Benchmark for RTL Code Optimization

**RTL-OPT** is a benchmark designed to evaluate RTL code optimization for improving IC design quality. The dataset consists of 40 digital IC designs, each containing suboptimal and expert-optimized RTL code, enabling the assessment of LLM-generated RTL code. The dataset also includes an integrated evaluation framework for automatic verification of functional correctness and quantification of PPA (Power, Performance, Area) improvements.

This benchmark provides a realistic and comprehensive evaluation method for generative AI models in hardware design optimization.

## Dataset Contents

- **Number of Designs**: 40 digital IC designs
- **Code Types**:
  - Suboptimal RTL code
  - Expert-optimized RTL code (golden reference)
