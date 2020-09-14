from keras.layers import Input
from frcnn import FRCNN 
from PIL import Image
import time
import os

frcnn = FRCNN()
image_ids = open('VOCdevkit/VOC2007/ImageSets/Main/test.txt').read().strip().split()
root="VOCdevkit/VOC2007/JPEGImages"

start=time.time()
for image_id in image_ids:
    path = os.path.join(root,image_id+".jpg")
    try:
        image = Image.open(path)
    except:
        print('Open Error! Try again!')
        continue
    else:
        r_image = frcnn.detect_image(image)
        r_image.save("%s.jpg"%image_id)
        r_image.show()
end=time.time()
frcnn.close_session()
n_time=end-start
print(n_time)
    