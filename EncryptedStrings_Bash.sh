#!/bin/bash
# Use 'openssl' to create an encrypted Base64 string for script parameters
# Additional layer of security when passing account credentials from the JSS to a client

# Use GenerateEncryptedString() locally - DO NOT include in the script!
# The 'Encrypted String' will become a parameter for the script in the JSS
# The unique 'Salt' and 'Passphrase' values will be present in your script

# Updated from https://github.com/kc9wwh/EncryptedStrings/blob/master/EncryptedStrings_Bash.sh
# the original used some outdated stuff

function GenerateEncryptedString() {
    # Usage ~$ GenerateEncryptedString "String"
    local STRING="${1}"
    local SALT=$(openssl rand -hex 8)
    local K=$(openssl rand -hex 12)
    local ENCRYPTED=$(echo "${STRING}" | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -S "${SALT}" -k "${K}")
    echo "Encrypted String: ${ENCRYPTED}"
    echo "Salt: ${SALT} | Passphrase: ${K}"
}

#============================== Uncomment Line below to run encrypt
#GenerateEncryptedString "PasswordToEncrypt"

#DecryptString function test decryption
function DecryptString() {
    # Usage: ~$ DecryptString "Encrypted String"
    local SALT=""
    local K=""
    echo "${1}" | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -S "${SALT}" -k "${K}"
}
#============================== Uncomment Line below to run decrypt after pasting the SALT and Passphrase in the function above
#DecryptString "EncryptedPassword"