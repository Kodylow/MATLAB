classdef Distortions
    methods(Static)
        function distortedImage = controlDistortion(imagePatch)
            % Control Distortion
            meanValue = mean(imagePatch(:));
            if meanValue > 127
                distortedImage = 255 * ones(size(imagePatch), 'like', imagePatch);
            else
                distortedImage = zeros(size(imagePatch), 'like', imagePatch);
            end
        end

        function distortedImage = meanDistortion(imagePatch)
            % Mean Distortion
            meanValue = mean(imagePatch(:));
            distortedImage = meanValue * ones(size(imagePatch), 'like', imagePatch);
        end

        function distortedImage = invertDistortion(imagePatch)
            % Invert Distortion
            distortedImage = 255 - imagePatch;
        end

        function distortedImage = transposeDistortion(imagePatch)
            % Transpose Distortion
            if size(imagePatch, 1) == size(imagePatch, 2)
                distortedImage = imagePatch';
            else
                % Handle non-square patches by making the patch square
                minDim = min(size(imagePatch));
                squarePatch = imagePatch(1:minDim, 1:minDim);
                distortedImage = squarePatch';
                if size(imagePatch, 1) ~= size(imagePatch, 2)
                    distortedImage(size(imagePatch, 2), size(imagePatch, 1)) = 0;
                end
            end
        end
    end
end
