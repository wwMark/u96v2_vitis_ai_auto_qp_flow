docker pull xilinx/vitis-ai:1.3.411
docker run --name vitis_ai_quantize_compile --rm xilinx/vitis-ai:1.3.411 bash
docker cp custom.json vitis_ai_quantize_compile:/home/vitis-ai-user
docker cp quantize_model.py vitis_ai_quantize_compile:/home/vitis-ai-user
docker cp ULTRA96V2.dcf vitis_ai_quantize_compile:/home/vitis-ai-user
docker cp u96v2_mobilenetv2_customcoco/trained_model/mobilenetv2 vitis_ai_quantize_compile:/home/vitis-ai-user
docker exec vitis_ai_quantize_compile conda activate vitis-ai-tensorflow2
docker exec vitis_ai_quantize_compile cd /home/vitis-ai-user
docker exec vitis_ai_quantize_compile python quantize_model.py
docker exec vitis_ai_quantize_compile vai_c_tensorflow2 -m ./quantized_mobilenetv2_model.h5 -a ./custom.json -o ./compiled_mobilenetv2_model -n mobilenetv2
docker cp vitis_ai_quantize_compile:/home/vitis-ai-user/compiled_mobilenetv2_model .
