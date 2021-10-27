import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import tensorflow_datasets as tfds
from pathlib import Path
import numpy as np
from numpy import asarray
from PIL import Image

'''
project_root_path = '/home/mark/hiwi/liubo/Vitis-AI/compile_temp/'
bbox_images_path = project_root_path + 'bbox_images/'
coco_path = bbox_images_path + 'coco/'
test_path = coco_path + 'test2014'

if not Path(test_path).exists():
    Path(test_path).mkdir(parents=True)
'''

coco_test, info_test = tfds.load('mnist', split='test', shuffle_files=True, with_info=True)

coco_test = coco_test.take(256)

# create numpy array
images_array = np.empty((0, 224, 224, 3), float)
for example in coco_test.as_numpy_iterator():
    image = example['image']
    image = Image.fromarray(image, 'RGB')
    resized_image = image.resize((224, 224))
    image_data_array = asarray(resized_image)
    image_data_array = np.expand_dims(image_data_array, axis=0)
    images_array = np.append(images_array, image_data_array, axis=0)


model = tf.keras.models.load_model('mobilenetv2')

from tensorflow_model_optimization.quantization.keras import vitis_quantize

quantizer = vitis_quantize.VitisQuantizer(model)
quantized_model = quantizer.quantize_model(calib_dataset=images_array)

quantized_model.save('./quantized_mobilenetv2_model.h5')
