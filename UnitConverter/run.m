% run.m - Main script to interact with the user
disp('Welcome to the Unit Converter!');
disp('You can convert distances, volumes, and weights.');

converter = UnitConverter();
converter.printAvailableUnits();

keepRunning = true;
while keepRunning
try
    original_unit = converter.promptForUnit('Enter the original unit (or type "exit" to quit): ', true);
    if strcmpi(original_unit, 'exit')
    disp('Thank you for using the Unit Converter. Goodbye!');
    break;
    end
    
    quantity = converter.promptForQuantity();
    
    target_unit = converter.promptForUnit('Enter the target unit: ', false);
    
    converted_value = converter.convert(quantity, original_unit, target_unit);
    
    fprintf('%f %s is equal to %f %s.\n', quantity, original_unit, converted_value, target_unit);
    
    againResponse = input('Do you want to use the converter again? (yes/no): ', 's');
    if strcmpi(againResponse, 'no')
    disp('Thank you for using the Unit Converter. Goodbye!');
    break;
    end
    
catch ME
    disp(['An unexpected error occurred: ', ME.message]);
end
end
