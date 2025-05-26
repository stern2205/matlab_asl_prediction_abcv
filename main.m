clc;
clear;

% Automatically get the current script's directory
currentFolder = fileparts(mfilename('fullpath'));

% Construct the full dataset path based on the script's location
datasetPath = fullfile(currentFolder, 'ASL_Dataset');
modelFile = 'ASL_ABC_CNN3.mat';

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
choice = input('Choose mode: 1 - Random Image from Testing, 2 - Webcam, 3 - Validation, 4 - Live Video: ');

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
    img1 = imresize(rgb2gray(img1), [128, 128]);

    % Predict using the captured image
    predLabel = classify(net, img1);

    % Display the captured image and prediction result
    imshow(img1);
    title(['Prediction: ', char(predLabel)]);
    
    % Clear the webcam object
    clear vid;

elseif choice == 3
    % Random image mode from each folder in the Testing directory
    disp('Selecting a random image from each folder in the Testing directory...');

    % Get the path to the Testing folder
    testFolder = fullfile(datasetPath, 'Testing');
    
    % Get a list of all subfolders (directories only)
    classes = dir(testFolder); 
    classes = classes([classes.isdir]);  % Filter out non-directory files
    classes = classes(~ismember({classes.name}, {'.', '..'}));  % Exclude '.' and '..'
    
    % Check if the number of folders is exactly 5
    if numel(classes) ~= 4
        disp('Error: The Testing folder must contain exactly 5 subfolders.');
        return;
    end

    % Create a single figure for displaying all images
    figure('Name', 'Randomly Selected Images from Each Folder', 'NumberTitle', 'off');

    % Loop through each folder and display the image
    for i = 1:numel(classes)
        % Get the path of the current class folder
        classFolder = fullfile(testFolder, classes(i).name);

        % Get all image files in the current class folder
        imgFiles = dir(fullfile(classFolder, '*.jpg'));  % Change extension if needed

        % Check if any images were found in the current folder
        if isempty(imgFiles)
            disp(['No images found in folder: ', classes(i).name]);
            continue;
        end
        
        % Randomly select an image file from the current folder
        randImgIdx = randi(numel(imgFiles));
        imgPath = fullfile(classFolder, imgFiles(randImgIdx).name);
        
        % Display the selected image path
        disp(['Randomly selected image from folder ', classes(i).name, ': ', imgPath]);

        % Predict the random image
        img = imread(imgPath);
        img = imresize(rgb2gray(img), [128, 128]);  % Updated to 128x128
        predLabel = classify(net, img);
        
        % Display the image in the subplot
        subplot(1, 4, i);  % Arrange in a single row with 5 columns
        imshow(img);
        title(['Predicted: ', char(predLabel), ' (', classes(i).name, ')']);
    end
 
elseif choice == 4
    % Real-time webcam ASL sign detection
    disp('Starting real-time ASL sign detection... Press Ctrl+C to stop.');

    % Initialize video input (webcam)
    vid = videoinput('winvideo', 1, 'YUY2_640x480');
    set(vid, 'ReturnedColorSpace', 'RGB');
    vid.FrameGrabInterval = 5; % Skip frames to reduce processing load

    % Create figure for display
    figure('Name', 'Live ASL Prediction', 'NumberTitle', 'off');

    % Start live capture
    while ishandle(gcf)
        % Capture one frame
        frame = getsnapshot(vid);
        
        % Preprocess the frame (convert to grayscale, resize)
        grayFrame = rgb2gray(frame);
        resizedFrame = imresize(grayFrame, [128, 128]);

        % Predict the label
        predLabel = classify(net, resizedFrame);

        % Show the frame and prediction
        imshow(frame);
        title(['Predicted Sign: ', char(predLabel)], 'FontSize', 16);

        % Pause briefly to allow GUI update
        pause(0.1);
    end

    % Clear the video object when done
    clear vid;

else
    disp('Invalid choice. Please select 1 for random image or 2 for webcam.');
end