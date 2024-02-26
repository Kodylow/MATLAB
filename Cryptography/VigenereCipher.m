classdef VigenereCipher < Cipher
    properties
        Key % The keyword used for encryption and decryption processes.
    end

    methods
        function obj = VigenereCipher(key, mode)
            obj = obj@Cipher(mode); % Call superclass constructor
            obj.Key = upper(key); % Ensure the key is in uppercase for consistency
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
            len = length(text); 
            resultArray = zeros(1, len); % Preallocate numeric array for result
            keyLength = length(obj.Key);
            keyIndex = 1; % Initialize key index
        
            for i = 1:len
                charCode = double(text(i));
                if isletter(text(i))
                    [shift, isLower] = obj.getShiftForKeyCharacter(text(i), obj.Key(keyIndex), mode);
                    encryptedCharCode = obj.applyShiftToCharacter(charCode, shift, isLower);
                    resultArray(i) = encryptedCharCode;
        
                    keyIndex = mod(keyIndex, keyLength) + 1; % Advance key index only for letters
                else
                    resultArray(i) = charCode; % Non-letter characters are added unchanged, keyIndex does not advance
                end
            end
        
            result = char(resultArray); % Convert numeric array back to character array (string)
        end

        function [shift, isLower] = getShiftForKeyCharacter(obj, char, keyChar, mode)
            isLower = isstrprop(char, 'lower');
            offset = double(isLower) * (97 - 65) + 65; 
            k = double(keyChar) - 65; % Key is always uppercase for consistency

            if strcmp(mode, 'decrypt')
                shift = -k;
            else
                shift = k;
            end
        end

        function encryptedCharCode = applyShiftToCharacter(obj, charCode, shift, isLower)
            offset = isLower * (97 - 65) + 65; 
            encryptedCharCode = mod(charCode - offset + shift, 26) + offset;
        end
    end
end
