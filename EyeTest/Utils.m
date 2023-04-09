classdef Utils
    methods (Static)
        function [times, dists, percentOffCenter] = convertResults(result)
            numSizes = numel(unique(result.windowSize));
            numFunctions = numel(result.funcs);
            numTrials = result.numTrials;

            % Initialize the 3D arrays
            times = zeros(numSizes, numFunctions, numTrials);
            dists = zeros(numSizes, numFunctions, numTrials);
            percentOffCenter = zeros(length(result.windowSize), 1); % For percentage calculation

            % Calculate half-diagonals for percentage off center calculation
            halfDiagonals = sqrt(2) * (result.windowSizes / 2);

            for idx = 1:length(result.windowSize)
                sizeIdx = result.windowSize(idx);
                funcIdx = result.func(idx);
                trialIdx = ceil(idx / (numSizes * numFunctions));

                % Calculate the center of the distortion
                windowCenter = [result.windowPos(idx, 2) + result.windowSizes(sizeIdx) / 2, ...
                                result.windowPos(idx, 1) + result.windowSizes(sizeIdx) / 2];

                clickPos = result.clickPosition(idx, :);

                % Calculate the distance and assign values
                distance = sqrt(sum((clickPos - windowCenter).^2));
                times(sizeIdx, funcIdx, trialIdx) = result.elapsedTime(idx);
                dists(sizeIdx, funcIdx, trialIdx) = distance;

                % Calculate percentage off center
                percentOffCenter(idx) = (distance / halfDiagonals(sizeIdx)) * 100;
            end
        end

        function displayAnalysis(times, dists, funcs, result)
            % Convert function handles to strings for labeling
            funcNames = cellfun(@func2str, funcs, 'UniformOutput', false);
            
            % Average times and distances across all trials
            avgTimes = squeeze(mean(times, 3)); % Average over trials
            avgDists = squeeze(mean(dists, 3)); % Average over trials
        
            %% Plot 1: Average Response Time by Distortion Type
            figure;
            bar(avgTimes);
            title('Average Response Time by Distortion Type');
            xlabel('Distortion Type');
            ylabel('Time (seconds)');
            set(gca, 'XTickLabel', funcNames);
            legend('Size 1', 'Size 2', 'Size 3', 'Location', 'NorthEastOutside'); % Adjust size labels as needed
        
            %% Plot 2: Scatter Plot of Distance from Center vs. Response Time
            figure;
            hold on;
            colors = 'rgbmyk'; % Color for each distortion type, extend as needed
            for i = 1:length(funcs)
                % Squeeze to ensure times and dists are 2D matrices or vectors
                x = squeeze(times(:, i, :));
                y = squeeze(dists(:, i, :));
                
                % Ensure x and y are vectors. If they're not, you may need to further process them
                % For instance, if x and y are matrices, you might need to flatten them
                if ~isvector(x)
                    x = x(:); % Flatten the matrix to a vector
                end
                if ~isvector(y)
                    y = y(:); % Flatten the matrix to a vector
                end
                
                % Check if x and y are of the same length before plotting
                if length(x) == length(y)
                    scatter(x, y, colors(i), 'DisplayName', funcNames{i});
                else
                    % Handle the error or discrepancy
                    warning('Mismatch in dimensions between times and dists for function %d.', i);
                end
            end

            hold off;
            title('Distance from Center vs. Response Time');
            xlabel('Time (seconds)');
            ylabel('Distance from Center (pixels)');
            legend('Location', 'NorthEastOutside');
        
            %% Plot 3: 3D Bar Graph of Response Time by Distortion Size and Original Image Showing
            % Assuming an additional dimension or data indicating whether the original was shown
            % This is a placeholder for how you might approach it
            % You'd need to adapt based on your actual data structure
            figure;
            sizes = unique(result.windowSize); % Example, assuming 'result' is available
            for i = 1:length(sizes)
                subplot(1, length(sizes), i);
                bar3(avgTimes(:, i)); % One bar plot per size
                title(['Distortion Size ', num2str(sizes(i))]);
                xlabel('Distortion Type');
                ylabel('Showing Original');
                zlabel('Average Time (seconds)');
                set(gca, 'XTickLabel', funcNames, 'YTickLabel', {'No', 'Yes'}); % Example labels
            end

            %% Plot 4: Window Size vs. Time to Click
            figure;
            scatter(result.windowSizes, squeeze(mean(times, [2, 3])));
            xlabel('Window Size (pixels)');
            ylabel('Average Time to Click (seconds)');
            title('Window Size vs. Average Time to Click');
            grid on;
        end
    end
end
