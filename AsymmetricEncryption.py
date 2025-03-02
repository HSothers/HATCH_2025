#Encrypting Symmetric Key Generated from GeneratingSymmetricKey.py
import rsa
from cryptography.fernet import Fernet

#Generate symmetric key
key = Fernet.generate_key()

#symmetric key to be encrypted
#Note the key generated above must be converted into a str in order for methods below to function
sym_key = str(key)

string_to_save_to_txt = sym_key

with open("symmetric_key.txt", "w") as file:
    file.write(string_to_save_to_txt)

publicKey, privateKey = rsa.newkeys(1024)

#public key string is encoded to byte string before encryption with encode method
enc_key = rsa.encrypt(sym_key.encode(), publicKey)

print("Original Key: ", sym_key)
print("Encrypted Key: ", enc_key)

#encrypted key can be decrypted using the ras.decrypt method and stored in private key
#private key then returns the encoded byte string and decode method is used to convert it to a string
#Note that the public key cannot be used for decryption
dec_key = rsa.decrypt(enc_key, privateKey).decode()
print("Decrypted Key: ", dec_key)