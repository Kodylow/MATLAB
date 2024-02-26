classdef TestCiphers < matlab.unittest.TestCase
    % TestVigenereCipher contains unit tests for the CaesarCipher and VigenereCipher classes

    methods (Test)

        function testCaesarExampleEncryptionFromPpt(testCase)
            cipher = CaesarCipher(10, 'encrypt');
            encryptedText = cipher.encrypt('I like chemistry');
            expectedText = 'S vsuo mrowscdbi';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarEncryption(testCase)
            cipher = CaesarCipher(3, 'encrypt');
            encryptedText = cipher.encrypt('HELLO');
            expectedText = 'KHOOR';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarEncryptionWithLower(testCase)
            cipher = CaesarCipher(3, 'encrypt');
            encryptedText = cipher.encrypt('hello');
            expectedText = 'khoor';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarEncryptionWithMixed(testCase)
            cipher = CaesarCipher(3, 'encrypt');
            encryptedText = cipher.encrypt('hello WORLD');
            expectedText = 'khoor ZRUOG';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarEncryptionWithSpaces(testCase)
            % Test the encryption functionality with spaces
            cipher = CaesarCipher(3, 'encrypt');
            encryptedText = cipher.encrypt('HELLO WORLD');
            expectedText = 'KHOOR ZRUOG';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarEncryptionWithPunctuation(testCase)
            % Test the encryption functionality with punctuation
            cipher = CaesarCipher(3, 'encrypt');
            encryptedText = cipher.encrypt('HELLO, WORLD!');
            expectedText = 'KHOOR, ZRUOG!';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarEncryptionWithNumbers(testCase)
            % Test the encryption functionality with numbers
            cipher = CaesarCipher(3, 'encrypt');
            encryptedText = cipher.encrypt('HELLO 123');
            expectedText = 'KHOOR 123';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarExampleDecryptionFromPpt(testCase)
            cipher = CaesarCipher(10, 'decrypt');
            encryptedText = cipher.decrypt('S vsuo mrowscdbi');
            expectedText = 'I like chemistry';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarDecryption(testCase)
            cipher = CaesarCipher(3, 'decrypt');
            decryptedText = cipher.decrypt('KHOOR');
            expectedText = 'HELLO';
            testCase.verifyEqual(decryptedText, expectedText);
        end

        function testCaesarDecryptionWithLower(testCase)
            cipher = CaesarCipher(3, 'decrypt');
            decryptedText = cipher.decrypt('khoor');
            expectedText = 'hello';
            testCase.verifyEqual(decryptedText, expectedText);
        end

        function testCaesarDecryptionWithMixed(testCase)
            cipher = CaesarCipher(3, 'decrypt');
            encryptedText = cipher.decrypt('khoor ZRUOG');
            expectedText = 'hello WORLD';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testCaesarDecryptionWithSpaces(testCase)
            cipher = CaesarCipher(3, 'decrypt');
            decryptedText = cipher.decrypt('KHOOR ZRUOG');
            expectedText = 'HELLO WORLD';
            testCase.verifyEqual(decryptedText, expectedText);
        end

        function testCaesarDecryptionWithPunctuation(testCase)
            cipher = CaesarCipher(3, 'decrypt');
            decryptedText = cipher.decrypt('KHOOR, ZRUOG!');
            expectedText = 'HELLO, WORLD!';
            testCase.verifyEqual(decryptedText, expectedText);
        end

        function testCaesarDecryptionWithNumbers(testCase)
            cipher = CaesarCipher(3, 'decrypt');
            decryptedText = cipher.decrypt('KHOOR 123');
            expectedText = 'HELLO 123';
            testCase.verifyEqual(decryptedText, expectedText);
        end

        function testVignereExampleEncryptionFromPpt(testCase)
            cipher = VigenereCipher('math', 'encrypt');
            encryptedText = cipher.encrypt('Cryptography is super cool');
            expectedText = 'Orrwfozympaf us lbbek jaoe';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVigenereEncryption(testCase)
            cipher = VigenereCipher('KEY', 'encrypt');
            encryptedText = cipher.encrypt('HELLO');
            expectedText = 'RIJVS';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVignereEncryptionWithLower(testCase)
            cipher = VigenereCipher('key', 'encrypt');
            encryptedText = cipher.encrypt('hello');
            expectedText = 'rijvs';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVignereEncryptionWithMixed(testCase)
            cipher = VigenereCipher('kEy', 'encrypt');
            encryptedText = cipher.encrypt('hello WORLD');
            expectedText = 'rijvs UYVJN';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVigenereEncryptionWithSpaces(testCase)
            cipher = VigenereCipher('KEY', 'encrypt');
            encryptedText = cipher.encrypt('HELLO WORLD');
            expectedText = 'RIJVS UYVJN';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVigenereEncryptionWithPunctuation(testCase)
            cipher = VigenereCipher('KEY', 'encrypt');
            encryptedText = cipher.encrypt('HELLO, WORLD!');
            expectedText = 'RIJVS, UYVJN!';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVigenereEncryptionWithNumbers(testCase)
            cipher = VigenereCipher('KEY', 'encrypt');
            encryptedText = cipher.encrypt('HELLO 123');
            expectedText = 'RIJVS 123';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVignereExampleDecryptionFromPpt(testCase)
            cipher = VigenereCipher('math', 'decrypt');
            encryptedText = cipher.decrypt('Orrwfozympaf us lbbek jaoe');
            expectedText = 'Cryptography is super cool';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVigenereDecryption(testCase)
            cipher = VigenereCipher('KEY', 'decrypt');
            decryptedText = cipher.decrypt('RIJVS');
            expectedText = 'HELLO';
            testCase.verifyEqual(decryptedText, expectedText);
        end

        function testVignereDecryptionWithLower(testCase)
            cipher = VigenereCipher('key', 'decrypt');
            encryptedText = cipher.decrypt('rijvs');
            expectedText = 'hello';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVignereDecryptionWithMixed(testCase)
            cipher = VigenereCipher('kEy', 'decrypt');
            encryptedText = cipher.decrypt('rijvs UYVJN');
            expectedText = 'hello WORLD';
            testCase.verifyEqual(encryptedText, expectedText);
        end

        function testVigenereDecryptionWithSpaces(testCase)
            cipher = VigenereCipher('KEY', 'decrypt');
            decryptedText = cipher.decrypt('RIJVS UYVJN');
            expectedText = 'HELLO WORLD';
            testCase.verifyEqual(decryptedText, expectedText);
        end

    end

end
