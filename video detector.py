# https://www.pyimagesearch.com/2019/06/24/change-input-shape-dimensions-for-fine-tuning-with-keras/
# Image Dataset: https://github.com/balajisrinivas/Face-Mask-Detection/tree/master/dataset
# Importing the necessary packages to use throughout the facial recognition process
from imutils.video import VideoStream
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
import time
import numpy as np
from tensorflow.keras.preprocessing.image import img_to_array
from tensorflow.keras.models import load_model
import os
import imutils
import cv2


# function that detects presence of the mask, 3 parameters passed in
def detect_and_predict_mask(frame, faceNet, maskNet):
	# Get the dimensions of the frame sent in as a parameter
	(h, w) = frame.shape[:2]
	blob = cv2.dnn.blobFromImage(frame, 1.0, (224, 224),
		(104.0, 177.0, 123.0))

	# pass the blob through the network and obtain the face detections
	faceNet.setInput(blob)
	detections = faceNet.forward()

	# initialize our list of faces, their corresponding locations,
	# and the list of predictions from our face mask network
	faces, locs, preds = ([] for i in range(3))

	# loop over the detections
	for i in range(0, detections.shape[2]):
		# get and store the confidence of the each detections
		confidence = detections[0, 0, i, 2]
		# code below only runs if the confidence of the facial detection exceeds a minimum threshold
		if confidence > 0.5:
			# a box is created that stores the coordinates of the face
			box = detections[0, 0, i, 3:7] * np.array([w, h, w, h])
			(startX, startY, endX, endY) = box.astype("int")

			# the box that is created can exceed the size of the frame, so the coordinates of the box are calculated and changed to ensure it fits inside of the frame
			(startX, startY) = (max(0, startX), max(0, startY))
			(endX, endY) = (min(w - 1, endX), min(h - 1, endY))

			# The face is determined off the box coordinates on the actual frame
			face = frame[startY:endY, startX:endX]
			# The color of the face image is converted from BGR to RGB values
			face = cv2.cvtColor(face, cv2.COLOR_BGR2RGB)
			# The image of the race is resized to a specific size
			face = cv2.resize(face, (224, 224))
			# face is converted from an image to an array to send through the preprocess
			face = img_to_array(face)
			face = preprocess_input(face)

			# the face is appended to the list of all faces, and the location is as well
			faces.append(face)
			locs.append((startX, startY, endX, endY))

	# if there were no faces detected, then there is no prediction, but if there is at least one face, then the prediction is ran
	if len(faces) > 0:
		faces = np.array(faces, dtype="float32")
		preds = maskNet.predict(faces, batch_size=32)

	# at the end of the function, the list of locations and predictions are returned
	return (locs, preds)

# the prototxt and weight paths are stored from their computer location
prototxtPath = r"D:\Python Projects\Face-Mask-Detection-master\face_detector\deploy.prototxt" #or whatever your directory is
weightsPath = r"D:\Python Projects\Face-Mask-Detection-master\face_detector\res10_300x300_ssd_iter_140000.caffemodel" #or whatever your directory is
faceNet = cv2.dnn.readNet(prototxtPath, weightsPath)
# the face network is created from the two paths stored
maskNet = load_model("mask_detector.model")
# starting the video stream
vs = VideoStream(src=0).start()
# loops through each frame of the video
while True:
	# each frame is read in, and subsequently resized too a width of 400 pixels
	frame = vs.read()
	frame = imutils.resize(frame, width=400)

	# detect faces in the frame and determine if they are wearing a
	# face mask or not
	(locs, preds) = detect_and_predict_mask(frame, faceNet, maskNet)

	# loop over the detected face locations and their locations
	for (box, pred) in zip(locs, preds):
		# coordinates of the box are stored
		(startX, startY, endX, endY) = box
		(mask, withoutMask) = pred

		# color of the box is displayed based on if the program determined presence of a mask (light blue if yes, red if no mask)
		label = "Mask Detected" if mask > withoutMask else "No Mask Detected"
		color = (255, 151, 53) if label == "Mask Detected" else (0, 0, 255)

		# includes the confidence of the decision in the label on the screen
		label = f"{label}: {round(max(mask, withoutMask) * 100)}%"
		# frame properties
		cv2.putText(frame, label, (startX, startY - 10),
			cv2.FONT_HERSHEY_SIMPLEX, 0.45, color, 2)
		cv2.rectangle(frame, (startX, startY), (endX, endY), color, 2)

	# shows the frame that is outputted
	cv2.imshow("Live Feed", frame)
	key = cv2.waitKey(1) & 0xFF

	# break from loop on command
	if key == ord("z"):
		break

# cleaning up workspace
cv2.destroyAllWindows()
vs.stop()