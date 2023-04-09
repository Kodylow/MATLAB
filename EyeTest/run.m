% Example script to use the VisionTestExperiment class

% Load or create a grayscale image
myImage = imread('grayscale_cat.jpg');

% Check if the image is RGB and convert to grayscale if it is
if size(myImage, 3) == 3
    myImage = rgb2gray(myImage); % Convert RGB to grayscale if needed
end

% Define window sizes (in pixels)
windowSizes = [ 50, 100, 150 ];

% Set the number of trials per function and window size
numTrials = 3;

% Set whether to show the original image before distortion
showOriginal = true;

% Create an instance of VisionTestExperiment
experiment = VisionTestExperiment(myImage, windowSizes, numTrials, showOriginal);

% Run the experiment
experiment.runExperiment();

