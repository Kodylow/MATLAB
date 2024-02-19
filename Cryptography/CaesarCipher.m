classdef CaesarCipher < Cipher

    properties
        Shift
    end

    methods

        function obj = CaesarCipher(shift, mode)
            obj = obj@Cipher(mode); % Call superclass constructor
            obj.Shift = shift;
        end

        function result = encrypt(obj, text)
            result = obj.shiftText(text, obj.Shift);
        end

        function result = decrypt(obj, text)
            result = obj.shiftText(text, -obj.Shift);
        end

        function bruteForce(obj, text)
            fprintf('Brute forcing Caesar Cipher:\n');

            for shift = 1:25
                fprintf('Shift %d: %s\n', shift, obj.shiftText(text, -shift));
            end

        end

    end

    methods (Access = private)

        function result = shiftText(obj, text, shift)
            result = ''; % Initialize result string

            for i = 1:length(text)
                char = text(i);

                if isletter(char)
                    % Determine the alphabet offset (65 for uppercase, 97 for lowercase)
                    offset = double(lower(char) == char) * 32 + 65;
                    % Shift character
                    encryptedChar = mod(double(char) - offset + shift, 26) + offset;
                    result(end + 1) = char(encryptedChar);
                else
                    % Non-letter characters are added unchanged
                    result(end + 1) = char;
                end

            end

        end

    end

end
