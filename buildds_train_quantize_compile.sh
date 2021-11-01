set -e
trap "docker stop vitis_ai_quantize_compile" ERR

python u96v2_mobilenetv2_customcoco/coco_processor.py
(cd u96v2_mobilenetv2_customcoco/coco2014_cropped_images && tfds build coco2014_cropped_images)
python u96v2_mobilenetv2_customcoco/mobilenet_v2_trainer.py

docker pull xilinx/vitis-ai:1.3.411
docker run -dit --name vitis_ai_quantize_compile --rm -e PATH="/opt/vitis_ai/conda/bin:/opt/vitis_ai/conda/bin:/opt/vitis_ai/conda/condabin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" -e CONDA_EXE="/opt/vitis_ai/conda/bin/conda" -e CONDA_PREFIX="/opt/vitis_ai/conda" -e CONDA_PYTHON_EXE="/opt/vitis_ai/conda/bin/python" xilinx/vitis-ai:1.3.411 bash

docker cp custom.json vitis_ai_quantize_compile:/home/vitis-ai-user
docker cp quantize_model.py vitis_ai_quantize_compile:/home/vitis-ai-user
docker cp ULTRA96V2.dcf vitis_ai_quantize_compile:/home/vitis-ai-user
docker cp u96v2_mobilenetv2_customcoco/trained_model/mobilenetv2 vitis_ai_quantize_compile:/home/vitis-ai-user

docker exec -i vitis_ai_quantize_compile bash -c "source /opt/vitis_ai/conda/etc/profile.d/conda.sh && conda activate vitis-ai-tensorflow2 && conda env list && vai_c_tensorflow2 -m /home/vitis-ai-user/quantized_mobilenetv2_model.h5 -a /home/vitis-ai-user/custom.json -o /home/vitis-ai-user/compiled_mobilenetv2_model -n mobilenetv2"

docker cp vitis_ai_quantize_compile:/home/vitis-ai-user/compiled_mobilenetv2_model .
docker stop vitis_ai_quantize_compile
