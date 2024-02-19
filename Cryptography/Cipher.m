classdef Cipher

    properties
        Mode % 'encrypt' or 'decrypt'
    end

    methods

        function obj = Cipher(mode)

            if nargin > 0 % If a mode is provided
                obj.Mode = mode;
            end

        end

    end

    methods (Abstract)
        result = encrypt(obj, text)
        result = decrypt(obj, text)
    end

end
