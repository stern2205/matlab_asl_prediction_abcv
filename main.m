clc;
clear;

% Automatically get the current script's directory
currentFolder = fileparts(mfilename('fullpath'));

% Construct the full dataset path based on the script's location
datasetPath = fullfile(currentFolder, 'ASL_Dataset');
modelFile = 'ASL_ABC_CNN.mat';

% Check if the model file exists
if isfile(modelFile)
    disp('Loading the saved model...');
    load(modelFile, 'net');
else
    % Step 1: Preprocess the data
    disp('No saved model found. Starting training...');
    [trainData, testData, numClasses] = preprocessASL(datasetPath);

    % Step 2: Train and save the model
    net = trainASLModel(trainData, testData, numClasses);
end

% Step 3: Predict using saved image or webcam
choice = input('Choose mode: 1 - Random Image from Testing, 2 - Webcam: ');

if choice == 1
    % Random image mode from the Testing folder
    disp('Selecting a random image from the Testing folder...');
    
    % Get the path to the Testing folder
    testFolder = fullfile(datasetPath, 'Testing');
    
    % Get a list of all files in the Testing folder
    classes = dir(testFolder); 
    classes = classes([classes.isdir]);  % Filter out non-directory files
    classes = classes(~ismember({classes.name}, {'.', '..'}));  % Exclude '.' and '..'
    
    % Randomly select a class folder
    randClassIdx = randi(numel(classes));
    randClassFolder = fullfile(testFolder, classes(randClassIdx).name);
    
    % Get all image files in the selected class folder
    imgFiles = dir(fullfile(randClassFolder, '*.jpg'));  % Change extension if needed
    if isempty(imgFiles)
        disp('No images found in the selected folder.');
        return;
    end
    
    % Randomly select an image file
    randImgIdx = randi(numel(imgFiles));
    imgPath = fullfile(randClassFolder, imgFiles(randImgIdx).name);
    
    % Predict the random image
    predictASL(net, 'image', imgPath);

elseif choice == 2
    % Webcam mode - capture an image using videoinput
    disp('Capturing image from webcam...');
    
    % Initialize video input (webcam)
    vid = videoinput('winvideo', 1);
    set(vid, 'ReturnedColorSpace', 'RGB');
    
    % Preview the video
    preview(vid);
    pause(5); % Let the preview stabilize for 5 seconds

    % Capture a snapshot
    img1 = getsnapshot(vid);
    
    % Close preview window
    closepreview(vid);

    % Resize the captured image to 64x64
    img1 = imresize(rgb2gray(img1), [64, 64]);

    % Predict using the captured image
    predLabel = classify(net, img1);

    % Display the captured image and prediction result
    imshow(img1);
    title(['Prediction: ', char(predLabel)]);
    
    % Clear the webcam object
    clear vid;
else
    disp('Invalid choice. Please select 1 for random image or 2 for webcam.');
end