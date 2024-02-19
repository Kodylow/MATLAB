classdef ArrayUtils
    % Utils for array calculations.
    %
    % Example Usage:
    % >> arr1 = [10, 20, 30, 40, 50];
    % >> arr2 = [1, 2, 3, 4, 5];
    % >> mean_val = ArrayUtils.meanArray(arr1);
    % >> std_val = ArrayUtils.stdArray(arr1);
    % >> corr_val = ArrayUtils.corrArray(arr1, arr2);
    methods (Static)
        function mean_val = meanArray(arr)
            % type check
            if ~isvector(arr)
                error('Input must be a 1D array.');
            end
            mean_val = sum(arr) / length(arr);
        end

        function std_val = stdArray(arr)
            % type check
            if ~isvector(arr)
                error('Input must be a 1D array.');
            end

            mean_val = ArrayUtils.meanArray(arr);
            variance = sum((arr - mean_val).^2) / (length(arr) - 1);
            std_val = sqrt(variance);
        end

        function corr_val = corrArray(arr1, arr2)
            % type check
            if ~isvector(arr1) || ~isvector(arr2) || length(arr1) ~= length(arr2)
                error('Both inputs must be 1D arrays of the same length.');
            end

            mean1 = ArrayUtils.meanArray(arr1);
            mean2 = ArrayUtils.meanArray(arr2);

            std1 = ArrayUtils.stdArray(arr1);
            std2 = ArrayUtils.stdArray(arr2);

            covariance = sum((arr1 - mean1) .* (arr2 - mean2)) / (length(arr1) - 1);

            corr_val = covariance / (std1 * std2);
        end
    end
end
