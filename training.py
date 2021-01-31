# https://www.pyimagesearch.com/2019/06/24/change-input-shape-dimensions-for-fine-tuning-with-keras/
# Image Dataset: https://github.com/balajisrinivas/Face-Mask-Detection/tree/master/dataset
# import the packages needed to train the program
from imutils import paths
import matplotlib.pyplot as plt
import numpy as np
import os
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dropout
from tensorflow.keras.layers import Flatten
from tensorflow.keras.layers import AveragePooling2D
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.layers import Dense
from tensorflow.keras.layers import Input
from tensorflow.keras.models import Model
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
from tensorflow.keras.preprocessing.image import img_to_array
from tensorflow.keras.preprocessing.image import load_img
from tensorflow.keras.utils import to_categorical
from sklearn.preprocessing import LabelBinarizer
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report

# initialization of the learning rate, the number of epocs, and the batch size
learn_rate = 1e-4
EPOCHS = 20
BS = 32
dire = r"D:\Python Projects\Face-Mask-Detection-master\dataset" #or whatever your directory is
cats = ["with_mask", "without_mask"]
# initializes list of the data and corresponding labels
data = []
labels = []
# loops through each category, mask and no mask, and gets each image
for category in cats:
    path = os.path.join(dire, category)
    for img in os.listdir(path):
    	img_path = os.path.join(path, img)
    	image = load_img(img_path, target_size=(224, 224))
		# converts the image to an array and sends in through the prepocess
    	image = img_to_array(image)
    	image = preprocess_input(image)
		# each image and category is stored in its respective data/label list
    	data.append(image)
    	labels.append(category)
# initializes the binarizer
binarize = LabelBinarizer()
labels = binarize.fit_transform(labels)
labels = to_categorical(labels)
data = np.array(data, dtype="float32")
labels = np.array(labels)

(trainX, testX, trainY, testY) = train_test_split(data, labels,
	test_size=0.20, stratify=labels, random_state=42)

# # Initializes the image generator to begin augmentation of the data
aug = ImageDataGenerator(
	rotation_range=20,
	zoom_range=0.15,
	width_shift_range=0.2,
	height_shift_range=0.2,
	shear_range=0.15,
	horizontal_flip=True,
	fill_mode="nearest")
baseModel = MobileNetV2(weights="imagenet", include_top=False,
	input_tensor=Input(shape=(224, 224, 3)))
# head model is made on top of the base
headModel = baseModel.output
headModel = AveragePooling2D(pool_size=(7, 7))(headModel)
headModel = Flatten(name="flatten")(headModel)
headModel = Dense(128, activation="relu")(headModel)
headModel = Dropout(0.5)(headModel)
headModel = Dense(2, activation="softmax")(headModel)
model = Model(inputs=baseModel.input, outputs=headModel)
# goes through each layer in the base model and makes them frozen to avoid being trained
for layer in baseModel.layers:
	layer.trainable = False
# begins optimization using the adam algorithm given the predetermined learning rate and the decay of the function
opt = Adam(lr=learn_rate, decay=learn_rate / EPOCHS)
model.compile(loss="binary_crossentropy", optimizer=opt,
	metrics=["accuracy"])
# the head of the network is becoming trained
H = model.fit(
	aug.flow(trainX, trainY, batch_size=BS),
	steps_per_epoch=len(trainX) // BS,
	validation_data=(testX, testY),
	validation_steps=len(testX) // BS,
	epochs=EPOCHS)
# find the image with the largest predicted probability in the set
predPos = model.predict(testX, batch_size=BS)
predPos = np.argmax(predPos, axis=1)
# shows a formatted classification report
print(classification_report(testY.argmax(axis=1), predPos,
	target_names=binarize.classes_))
# saves the model as an h5 file
model.save("mask_detector.model", save_format="h5")
