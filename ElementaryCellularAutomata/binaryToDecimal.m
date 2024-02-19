function decimal = binaryToDecimal(binaryArray)
    binaryString = num2str(binaryArray(:).');
    decimal = bin2dec(binaryString);
end
