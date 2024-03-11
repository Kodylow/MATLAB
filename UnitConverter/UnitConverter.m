classdef UnitConverter

    properties
        UnitsMap containers.Map
        UnitsCategoryMap containers.Map
    end

    methods

        function obj = UnitConverter()
            % Constructor
            units_data = readtable('unit_conversion_factors.csv');
            obj.UnitsMap = containers.Map(units_data.Unit, units_data.Factor);
            obj.UnitsCategoryMap = containers.Map(units_data.Unit, units_data.Category);
        end

        function unit = promptForUnit(self, promptMessage, exitOption)
            % Prompt for a unit with validation
            while true
                unit = input(promptMessage, 's');
                if exitOption && strcmpi(unit, 'exit')
                    unit = 'exit'; % Signal to exit
                    return;
                elseif isempty(unit) || (~ischar(unit) && ~isstring(unit))
                    disp('The unit must be a non-empty string. Please try again.');
                elseif ~isKey(self.UnitsMap, unit)
                    disp('This unit does not exist. Please try again.');
                else
                    break; % Valid input
                end
            end
        end

        function quantity = promptForQuantity(self)
            % Prompt for quantity with validation
            while true
                quantityStr = input('Enter the amount you are trying to convert: ', 's');
                quantity = str2double(quantityStr); % Attempt to convert to double

                if isnan(quantity) % Check if conversion failed
                    disp('The amount must be a numeric value. Please try again.');
                elseif quantity < 0
                    disp('The quantity must be a positive number. Please try again.');
                else
                    break; % Valid input
                end
            end
        end

        function converted_value = convert(self, quantity, from_unit, to_unit)
            % Validate quantity
            if isempty(quantity) || ~isnumeric(quantity) || quantity < 0
                error('UnitConverter:InvalidQuantity', 'The quantity must be a positive number.');
            end

            % Validate from_unit and to_unit
            if isempty(from_unit) || ~ischar(from_unit) && ~isstring(from_unit)
                error('UnitConverter:InvalidFromUnit', 'The original unit must be a non-empty string.');
            end

            if isempty(to_unit) || ~ischar(to_unit) && ~isstring(to_unit)
                error('UnitConverter:InvalidToUnit', 'The target unit must be a non-empty string.');
            end

            % Check if units exist in the map
            if ~isKey(self.UnitsMap, from_unit) || ~isKey(self.UnitsMap, to_unit)
                error('UnitConverter:InvalidUnits', 'One or more specified units are invalid.');
            end

            % Check if units are of the same category
            if ~strcmp(self.UnitsCategoryMap(from_unit), self.UnitsCategoryMap(to_unit))
                error('UnitConverter:CategoryMismatch', 'Units are not of the same category.');
            end

            % Perform conversion
            converted_value = quantity * (self.UnitsMap(from_unit) / self.UnitsMap(to_unit));
        end

        function printAvailableUnits(self)
            categories = unique(values(self.UnitsCategoryMap));
            categorizedUnits = containers.Map('KeyType', 'char', 'ValueType', 'any');

            % Initialize categories in the map
            for i = 1:length(categories)
                categorizedUnits(categories{i}) = {};
            end

            % Group units by category
            unitKeys = keys(self.UnitsCategoryMap);

            for i = 1:length(unitKeys)
                unit = unitKeys{i};
                category = self.UnitsCategoryMap(unit);
                categorizedUnits(category) = [categorizedUnits(category) {unit}];
            end

            % Print units by category
            disp('The UnitConverter can convert the following units:');

            for i = 1:length(categories)
                category = categories{i};
                unitsStr = strjoin(sort(categorizedUnits(category)), ', ');
                fprintf('%s: %s\n', category, unitsStr);
            end

            disp('Note: The units are case-sensitive and you cannot convert units from different categories.');

        end

    end

end
