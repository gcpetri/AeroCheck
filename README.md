# TAMUHack_2021
AeroCheck -- American Airlines Challenge

# AeroCheck

## Introduction

> Due to COVID panic and restrictions, airline sales are down, flight attendant stress is high - even for their own safety, and the public seems to need an incentive to fly. That's where AeroCheck comes in...

## Code Samples

> **AeroCheck** developed with Flutter in Andrio Studio</br>

>>...</br>
> >// ############ create a flutter MaterialApp</br>
>class MyApp extends StatefulWidget {<br>
>&nbsp;&nbsp;@override</br>
>&nbsp;&nbsp;MyAppState createState() => _MyAppState();</br>
>}</br>
>class _MyAppState extends State<MyApp> {</br>
>&nbsp;&nbsp;// ############## amplify</br>
>&nbsp;&nbsp;bool _amplifyConfigured = false; </br>
 &nbsp;&nbsp;@override </br>
 &nbsp;&nbsp;initState() {</br>
 &nbsp;&nbsp;&nbsp;&nbsp;super.initState();</br>
 &nbsp;&nbsp;&nbsp;&nbsp;configureAmplify();</br>
 }</br>...</br>

>**Mask Recognition** developed with Keras/Tensorflow
>>...</br>baseModel = MobileNetV2(weights="imagenet", include_top=False,</br>
>&nbsp;&nbsp;&nbsp;&nbsp;input_tensor=Input(shape=(224, 224, 3)))</br>
>\# head model is made on top of the base</br>
headModel = baseModel.output</br>
headModel = AveragePooling2D(pool_size=(7, 7))(headModel)</br>
headModel = Flatten(name="flatten")(headModel)</br>
headModel = Dense(128, activation="relu")(headModel)</br>
headModel = Dropout(0.5)(headModel)</br>
headModel = Dense(2, activation="softmax")(headModel)</br>
model = Model(inputs=baseModel.input, outputs=headModel)</br>...</br>


## Installation

> **Setup AeroCheck in Android Studio** download:
* Android Studio https://developer.android.com/studio
* Flutter https://flutter.dev/docs/get-started/install
* Follow this video for installation with AWS amplify https://www.youtube.com/watch?v=70mFj8FZpTI&t=467s
>_Note:_https://docs.amplify.aws/lib/datastore/getting-started/q/platform/flutter#install-amplify-libraries follow this for pubspec.yaml the video is slightly outdated
* main.dart
* pubspec.yaml</br>

>**Run Mask Recognition Model in Python**
>* Ensure you have a Python virtual environment at your disposal (eg. Jupyter Notebook, VSCode, PyCharm)
>* Run the training.py script with the data set in the appropriate directory

>**Download Executables**</br>
> We are still in the detailed development stage of these systems ... no executables are currently available.</br>
>Look out for updates AeroCheck app deployment and the MaskRecognition model hosting on AWS
