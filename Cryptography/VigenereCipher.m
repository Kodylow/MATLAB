classdef VigenereCipher < Cipher

    properties
        Key % The keyword for encryption/decryption
    end

    methods

        function obj = VigenereCipher(key, mode)
            obj = obj@Cipher(mode); % Call superclass constructor
            obj.Key = key;
        end

        function result = encrypt(obj, text)
            result = obj.vigenere(text, 'encrypt');
        end

        function result = decrypt(obj, text)
            result = obj.vigenere(text, 'decrypt');
        end

    end

    methods (Access = private)

        function result = vigenere(obj, text, mode)
            result = char(zeros(1, length(text))); % Preallocate result with the same length as text
            keyLength = length(obj.Key);
            keyIndex = 1; % Index for key characters
            resultIndex = 1; % Initialize result index

            for i = 1:length(text)
                char = text(i);

                if isletter(char)
                    % Determine the alphabet offset (65 for uppercase, 97 for lowercase)
                    offset = double(lower(char) == char) * 32 + 65;
                    % Get the shift amount from the current key character
                    k = mod(obj.Key(keyIndex) - 'A', 26); % Assuming key is uppercase

                    if strcmp(mode, 'decrypt')
                        k = -k; % Invert key for decryption
                    end

                    % Shift character
                    encryptedChar = mod(double(char) - offset + k, 26) + offset;
                    result(resultIndex) = char(encryptedChar);
                    % Move to the next key character, wrapping back to the start if necessary
                    keyIndex = mod(keyIndex, keyLength) + 1;
                else
                    % Non-letter characters are added unchanged
                    result(resultIndex) = char;
                end

                resultIndex = resultIndex + 1; % Increment result index for each loop iteration
            end

            result = char(result); % Convert result back to char array
        end

    end

end
