## Overview
This repository contains relative files for automatically quantizing and compiling the trained model in docker container
and retrieving result back to host.

## Environment and Dependency
OS: Ubuntu 18.04
Python version: 3.9
Dependency: ```pip install tensorflow tensorflow_datasets pillow```

## Usage
Run ```git clone --recurse-submodules https://github.com/wwMark/u96v2_vitis_ai_auto_qp_flow.git``` to clone this repository.
Then run ```buildds_train_quantize_compile.sh``` to start the model training, quantization and compilation. The script will first run the python code inside ```u96v2_mobilenetv2_customcoco``` to generate custom coco dataset, then train the model. After that, it will pull and run xilinx docker image, copy all the relative files for quantization and compilation of the trained model into the docker container, run the quantization and compilation, then copy back the resulting directory containing the ```.xmodel``` file, and finally stop the container.

**Note**: If coco downloading causes exception, it is suggested to check the ```download``` argument of the ```tfds.load``` function in ```coco_processor.py```.
