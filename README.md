# ASL Alphabet Recognition

This project uses a Convolutional Neural Network (CNN) to recognize American Sign Language (ASL) alphabet gestures. The model is trained using a dataset of ASL letters and can predict signs using both webcam input or random testing images.

## Author

Morales, Johann Daniel P.  
CpE-3205

## Project Details

In this project, I used my initials (J, D, P, M), and B for additional letters.

## Requirements

Before running the project, make sure you have the following dependencies installed:

### MATLAB Requirements

- MATLAB (preferably the latest version)
- Deep Learning Toolbox
- Image Processing Toolbox
- Computer Vision Toolbox

### Python Requirements (for capturing dataset)

- Python 3.x
- OpenCV (install via `pip install opencv-python`)

## Installation and Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/matlab_asl_prediction_abcv.git
cd matlab_asl_prediction_abcv

```

###Step 2: Collect the Dataset Using snapshots.py
1. Make sure your webcam is connected and functioning.

2. Run the snapshots.py script:

```bash
python snapshots.py
```

3. When prompted, type the letter (e.g., J) you want to record. A folder will be created with the letter as its name.

4. The script will wait 5 seconds before starting the capture.

5. It will then capture and save 50 cropped (480x480) images from the webcam to the folder named after the typed letter.

6. Repeat the process for the all the letters

Step 3: Prepare the Dataset for MATLAB
1. Inside the project folder, navigate to the ASL_Dataset directory.
2. Inside ASL_Dataset, create two subdirectories:
    -Training
    -Testing

3. For each letter you captured (J, D, P, M, B):
4. Move a portion of the images to ASL_Dataset/Training/[LETTER]/
5. Move the rest to ASL_Dataset/Testing/[LETTER]/
6. You can use any number of images between 1–3000 per letter. Make sure both Training and Testing sets have images for each letter.

Step 4: Remove Existing Model
Before running the main script, delete the existing model file:
```
ASL_ABC_CNN.mat
```
This ensures the model will be retrained from scratch using your newly captured dataset.

Step 5: Train the Model
1. Open MATLAB.
2. Open the main.m file.
3. Run the script.

If no pre-trained model exists, the script will begin preprocessing and training the CNN using the dataset. Training time may vary based on system performance.

Step 6: Choose a Mode for Prediction
After training is complete, the program will ask you to select a mode for prediction:

1: Use a random image from the Testing set for prediction.

2: Use the webcam to capture an image and predict the letter.

3: Validate the model by testing one random image per letter in the Testing set.

Type the number corresponding to your preferred mode when prompted.
