
import datetime
import numpy as np
import os.path as osp
import cv2 
import insightface
from matplotlib import pyplot as plt
import time
assert insightface.__version__>='0.4'
import firestoreDatabase
import datetime
import time



def detect_person(img, detector):
    bboxes, kpss = detector.detect(img)
    bboxes = np.round(bboxes[:,:4]).astype(np.int32)
    kpss = np.round(kpss).astype(np.int32)
    kpss[:,:,0] = np.clip(kpss[:,:,0], 0, img.shape[1])
    kpss[:,:,1] = np.clip(kpss[:,:,1], 0, img.shape[0])
    vbboxes = bboxes.copy()
    vbboxes[:,0] = kpss[:, 0, 0]
    vbboxes[:,1] = kpss[:, 0, 1]
    vbboxes[:,2] = kpss[:, 4, 0]
    vbboxes[:,3] = kpss[:, 4, 1]
    return bboxes, vbboxes


Database = firestoreDatabase.dbConnect()

numberOfWorker = 4 #int(input("Number of workers: "))
numberOfPeople = 0
detector = insightface.model_zoo.get_model('scrfd_person_2.5g.onnx', download=True)
detector.prepare(0, nms_thresh=0.5, input_size=(640, 640))

video=cv2.VideoCapture(0)
video.read()
time.sleep(1)
count = 0
while True:
    status=0
    time.sleep(0)
    check,frame=video.read()
    img = frame
    gray_img=cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
    cv2.imshow("gray_frame",frame)
    bboxes, vbboxes = detect_person(frame, detector)
    print(bboxes.shape[0])
    if bboxes.shape[0] != numberOfPeople or count%1000 == 0:
        numberOfPeople = bboxes.shape[0]
        ct = datetime.datetime.now()
        waitTime = round(numberOfPeople * 2 / numberOfWorker)
        Database.addData(round(ct.timestamp()),numberOfPeople, waitTime)
    for i in range(bboxes.shape[0]):
        bbox = bboxes[i]
        vbbox = vbboxes[i]
        x1,y1,x2,y2 = bbox
        vx1,vy1,vx2,vy2 = vbbox
        cv2.rectangle(img, (x1,y1)  , (x2,y2) , (0,255,0) , 1)
        alpha = 0.8
        color = (255, 0, 0)
        for c in range(3):
            img[vy1:vy2,vx1:vx2,c] = img[vy1:vy2, vx1:vx2, c]*alpha + color[c]*(1.0-alpha)
        cv2.circle(img, (vx1,vy1) , 1, color , 2)
        cv2.circle(img, (vx1,vy2) , 1, color , 2)
        cv2.circle(img, (vx2,vy1) , 1, color , 2)
        cv2.circle(img, (vx2,vy2) , 1, color , 2)
    cv2.imshow("gray_frame",img)
    key=cv2.waitKey(1)
    if key==ord('q'):
        video.release()
        cv2.destroyAllWindows()
        break
    count +=1

# img_paths = glob.glob('data/images/*.jpg')qq


# plt.xticks([]), plt.yticks([])
# plt.imshow(img2)
# plt.title('my picture')
# plt.show()
# filename = img_paths.split('/')[-1]
# cv2.imwrite('./content/outputs/%s'%filename, img)git
print(count)
