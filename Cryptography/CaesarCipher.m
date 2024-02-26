classdef CaesarCipher < Cipher
    % CaesarCipher implements a simple Caesar cipher for encrypting and decrypting text.

    properties
        Shift % The number of positions that each letter in the plaintext is shifted.
    end

    methods
        % Initializes a new instance of the CaesarCipher with a specified shift and mode.
        % Parameters:
        %   shift: An integer representing the shift for the cipher.
        %   mode: A string indicating the mode of operation (e.g., 'encrypt', 'decrypt').
        function obj = CaesarCipher(shift, mode)
            obj = obj@Cipher(mode); % Call superclass constructor
            obj.Shift = shift; % Set the shift property
        end

        % Encrypts a given plaintext
        % Parameters:
        %   text: The string to be encrypted.
        % Returns:
        %   result: The encrypted string.
        function result = encrypt(obj, text)
            result = obj.shiftText(text, obj.Shift);
        end

        % Decrypts a given ciphertext
        % Parameters:
        %   text: The string to be decrypted.
        % Returns:
        %   result: The decrypted string.
        function result = decrypt(obj, text)
            result = obj.shiftText(text, -obj.Shift);
        end

        % Attempts to decrypt a given text by trying all possible shifts.
        % Parameters:
        %   text: The encrypted string.
        function bruteForce(obj, text)
            fprintf('Brute forcing Caesar Cipher:\n');
            for shift = 1:25 % Try all possible shifts except the trivial shift of 0
                fprintf('Shift %d: %s\n', shift, obj.shiftText(text, -shift)); % Display each possible decryption
            end
        end
    end

    methods (Access = private)
        % Shifts the text by a specified number of positions.
        function result = shiftText(obj, text, shift)
            len = length(text); % Get the length of the input text
            resultArray = zeros(1, len); % Preallocate an array of zeros with the same length as the text
            
            for i = 1:len
                charCode = double(text(i)); % Convert character to its ASCII code
                if isletter(text(i)) % Check if the character is a letter
                    isLower = isstrprop(text(i), 'lower'); % Check if the character is lowercase
                    offset = isLower * (97 - 65) + 65; % Calculate the offset based on case (65 for 'A', 97 for 'a')
                    encryptedCharCode = mod(charCode - offset + shift, 26) + offset; % Calculate encrypted character code
                    resultArray(i) = encryptedCharCode; % Store encrypted character code at the current position
                else
                    resultArray(i) = charCode; % Store non-letter character codes unchanged
                end
            end
            
            result = char(resultArray); % Convert the array of character codes back to a string
        end
    end
end
