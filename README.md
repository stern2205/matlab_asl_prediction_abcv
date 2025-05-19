# ASL Alphabet Recognition

This project uses a Convolutional Neural Network (CNN) to recognize American Sign Language (ASL) alphabet gestures. The model is trained using a dataset of ASL letters and can predict signs using both webcam input or random testing images.

This project is brought to you by
## Morales, Johann Daniel P.
## CpE-3205

## Project Details
In this project, I used my initials (J, D, P, M), and B for additional letters.

## Requirements

Before running the project, make sure you have the following dependencies installed:

- **MATLAB** (preferably the latest version)
- **Deep Learning Toolbox** (for CNN model support)
- **Image Processing Toolbox** (for image manipulation)
- **Computer Vision Toolbox** (for webcam support)

## Installation & Setup

### Step 1: Clone or Download the Repository

Clone or download the GitHub repository to your local machine:

### Step 2: Prepare the Dataset

1. Navigate to the `ASL_Dataset` folder within the repository:

    ```bash
    cd ASL_Recognition/ASL_Dataset
    ```

2. Inside the `ASL_Dataset` folder, you'll find two subfolders: `Training` and `Testing`.

3. Download the ASL alphabet dataset from Kaggle:

    - [ASL Alphabet Dataset on Kaggle](https://www.kaggle.com/datasets/grassknoted/asl-alphabet)

4. Fill the `Training` and `Testing` folders with **5 letters** of the ASL alphabet from the downloaded dataset. For each letter:

    - Add images of the corresponding letter in the respective folder (Training or Testing).
    - You can include anywhere between **1-3000** images for each letter.

5. Separate the images into `Training` and `Testing` datasets. For example:
    - Place training images in the `Training` folder.
    - Place testing images in the `Testing` folder.

---

### Step 3: Remove Existing Model

1. The repository already includes a pre-trained model file `ASL_ABC_CNN.mat`.
2. **Before running the code**, **delete the existing `ASL_ABC_CNN.mat` file** to ensure that the model is retrained from scratch.

---

### Step 4: Run the Main Script

1. Open the `main.m` file in MATLAB.
2. Run the `main.m` file to begin the training process.
   
   - The script will check if a pre-trained model (`ASL_ABC_CNN.mat`) is available. If not, it will preprocess the dataset and start the training process.
   - The model training may take a few minutes to several hours depending on your system's processing power.

---

### Step 5: Wait for the Model to Finish Training

- The model will be trained on the dataset you prepared in Step 2.
- Once training is complete, the model will be saved as `ASL_ABC_CNN.mat`.

---

### Step 6: Choose a Mode for Prediction

After the training is complete, you will be prompted to select one of the following modes:

1. **Random Image from Testing**: A random image will be selected from the Testing folder, and the model will predict the letter.
2. **Webcam Mode**: The script will capture an image from the webcam and predict the letter.
3. **Validation Mode**: A random image will be selected from each folder in the Testing directory for validation, and the model will predict each image.

Select the appropriate mode based on your choice by typing **1**, **2**, or **3**.

---

## Additional Notes

- **Dataset Size**: Ensure that you have at least 5 classes (letters) in your Testing and Training datasets.
- **Model Accuracy**: The model's performance depends on the quality and number of images in the dataset. More data generally leads to better accuracy.
- **File Extensions**: The script currently expects `.jpg` images. If you're using a different image format, you may need to modify the script accordingly.

---

## License

This project is licensed under the MIT License.

---

## Acknowledgments

- Special thanks to Kaggle for providing the ASL alphabet dataset.
