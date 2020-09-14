from nets.yolo3 import yolo_body
from keras.layers import Input
from yolo import YOLO
from PIL import Image

yolo = YOLO()

while True:
    img = input('Input image filename:')
    try:
        image = Image.open(img)
    except:
        print('Open Error! Try again!')
        continue
    else:
        r_image = yolo.detect_image(image)
        r_image.show()
        r_image.save('/home/mist/yolo3-keras-master/img/img2.jpg')
yolo.close_session()
