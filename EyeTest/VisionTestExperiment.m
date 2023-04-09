classdef VisionTestExperiment
    properties
        myImage % The greyscale image data array
        funcs % Cell array of function handles to distortion functions
        windowSizes % Vector of window sizes
        numTrials % Number of trials to run per function and window size
        showOriginal % Boolean flag to show the original image before distortion
    end
    
    methods
        function obj = VisionTestExperiment(myImage, windowSizes, numTrials, showOriginal)
            % Constructor to initialize the experiment settings
            obj.myImage = myImage;
            obj.windowSizes = windowSizes;
            obj.numTrials = numTrials;
            obj.showOriginal = showOriginal;
            
            % Initialize funcs with method handles
            obj.funcs = {
                @Distortions.controlDistortion,
                @Distortions.meanDistortion,
                @Distortions.invertDistortion,
                @Distortions.transposeDistortion
            };
        end

        
        function runExperiment(obj)
            % Main method to start the experiment
            result = obj.dataGathered();
            [times, dists] = Utils.convertResults(result);
            % Display plots of the results
            Utils.displayAnalysis(times, dists, obj.funcs, result);
        
            %% Log the overall results in a table separate from plots
            % Print the header
            fprintf('Trial Results:\n');
            fprintf('-------------------------------------------------\n');
            fprintf('%-10s %-20s %-20s\n', 'Trial ID', 'Time (seconds)', 'Distance from Center (pixels)');
            fprintf('-------------------------------------------------\n');
        
            % Iterate through each trial to print its results
            for i = 1:size(times, 1)
                fprintf('%-10d %-20.2f %-20.2f\n', i, times(i, 2), dists(i, 2));
            end
            fprintf('-------------------------------------------------\n');
        end

        function result = dataGathered(obj)
            % Method to run specified trials and gather results
            trials = obj.generateTrials();
            result.windowSizes = obj.windowSizes;
            result.funcs = obj.funcs;
            result.numTrials = obj.numTrials;
        
            s = size(obj.myImage);
            for i = 1:size(trials, 1)
                % Extract the current trial's function and window size indices
                funcIdx = trials(i, 1);
                sizeIdx = trials(i, 2);
            
                % Determine the window size for the current trial based on the index
                windowSizeScalar = obj.windowSizes(sizeIdx);
                windowSize = [windowSizeScalar windowSizeScalar]; % Creating a square window
            
                % Randomly select the lower-left corner of the window to ensure variability
                windowLowerLeft = floor(rand(1, 2) .* (s(1:2) - windowSize) + 1);
            
                % Initialize the distorted image as a copy of the original
                distortedImage = obj.myImage;
            
                % Extract the subimage based on the calculated window
                subimage = obj.myImage(windowLowerLeft(1) + (0:(windowSize(1) - 1)), ...
                            windowLowerLeft(2) + (0:(windowSize(2) - 1)));
            
                % Apply the distortion function to the subimage
                distortedSubimage = obj.funcs{funcIdx}(subimage);
            
                % Place the distorted subimage back into the original image's copy
                distortedImage(windowLowerLeft(1) + (0:(windowSize(1) - 1)), ...
                            windowLowerLeft(2) + (0:(windowSize(2) - 1))) = distortedSubimage;
            
                % Display the distorted image and capture the user's click position and response time
                [result.clickPosition(i, :), result.elapsedTime(i)] ...
                    = obj.timeUser(distortedImage, obj.myImage, obj.showOriginal);
            
                % Record the trial's window size and function indices
                result.windowSize(i) = sizeIdx;
                result.func(i) = funcIdx;
                result.windowPos(i, :) = [windowLowerLeft];
            
                % Calculate the center of the distortion, adjusting for MATLAB's coordinate system
                centerOfDistortionCorrected = [windowLowerLeft(2) + windowSize(2) / 2, windowLowerLeft(1) + windowSize(1) / 2];
            
                % Compute the distance between the click position and the distortion center
                distanceFromCenter = sqrt(sum((result.clickPosition(i, :) - centerOfDistortionCorrected).^2));
            
                % Log details of the trial for review
                fprintf('\nTrial %d completed.\n', i);
                fprintf('Function used: %s\n', func2str(obj.funcs{funcIdx}));
                fprintf('Window size: %d pixels\n', windowSizeScalar);
                fprintf('Click position: (x: %.2f, y: %.2f)\n', result.clickPosition(i, 1), result.clickPosition(i, 2));
                fprintf('Calculated center position: (x: %.2f, y: %.2f)\n', centerOfDistortionCorrected(1), centerOfDistortionCorrected(2));
                fprintf('Distance from calculated center: %.2f pixels\n', distanceFromCenter);
                fprintf('Time taken: %.2f seconds\n', result.elapsedTime(i));
                fprintf('Distance from center: %.2f pixels\n', distanceFromCenter);
            end
        end

        function [clickPosition, elapsedTime] = timeUser(obj, distortedImage, originalImage, showOriginal)
            % Clears the figure or displays the original image based on the flag
            if showOriginal
                imshow(originalImage); % Show the original image if the flag is true
                title('Original Image');
                pause(1); % Wait for 1 second
            else
                clf; % Clear the current figure without closing it
            end
        
            % Displays the distorted image after a pause
            pause(1); % Additional pause to ensure timing starts from when the distorted image is shown
            imshow(distortedImage); % Show the distorted image
            title('Click on the center of the distortion');
        
            tic; % Start timing the user's response time
            [x, y] = ginput(1); % Wait for one click
            elapsedTime = toc; % Stop the timer and get the elapsed time
        
            clickPosition = [x, y]; % Store the x and y position of the click
        end
    end

    
    methods (Access = private)
        function trials = generateTrials(obj)
            % Generate all combinations of function IDs and size IDs
            numFunctions = length(obj.funcs);
            numSizes = length(obj.windowSizes);
            [f, s] = meshgrid(1:numFunctions, 1:numSizes);
            combo = [f(:) s(:)]; % Combine function and size IDs into a two-column matrix
    
            % Repeat each combination numTrials times to get the required number of trials
            repeatedCombos = repmat(combo, obj.numTrials, 1);
    
            % Randomize the order of the trials
            randomizedOrder = randperm(size(repeatedCombos, 1));
            trials = repeatedCombos(randomizedOrder, :);
        end
    end
end
