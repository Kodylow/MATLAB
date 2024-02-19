classdef ECA

    properties
        rule
        numSteps
        stateMatrix
    end

    methods

        % constructor (matlab convention to call it an obj)
        function obj = ECA(rule, numSteps)
            if rule < 1 || rule > 256
                error('Rule must be between 1 and 256');
            end
            obj.rule = ruleToBinString(rule);
            obj.numSteps = numSteps;
            obj.stateMatrix = zeros(numSteps + 1, 2 * numSteps + 1);

            % initialize with centered 1
            obj.stateMatrix(1, numSteps + 1) = 1;
        end

        % getters
        function matrix = getStateMatrix(obj)
            matrix = obj.stateMatrix;
        end

        function matrix = runEvolution(obj)
            for row = 2:obj.numSteps + 1
                for col = 1:2 * obj.numSteps + 1
                    newState = obj.applyRule(row, col);
                    obj.stateMatrix(row, col) = newState;
                end
            end
            matrix = obj.stateMatrix;
        end

        function state = applyRule(obj, row, col)
            % Extract the neighborhood with boundary handling
            neighborhood = obj.stateMatrix(row - 1, max(col - 1, 1):min(col + 1, size(obj.stateMatrix, 2)));
        
            % Pad boundary neighborhood with zeros
            if col == 1
                neighborhood = [0, neighborhood];
            end
            if col == size(obj.stateMatrix, 2)
                neighborhood = [neighborhood, 0];
            end

            neighborhood = neighborhood(1:3);
        
            % Convert to decimal to apply the rule
            decimal = binaryToDecimal(neighborhood);
            % Apply the rule
            state = str2double(obj.rule(9 - (decimal + 1)));
        end

    end

end
