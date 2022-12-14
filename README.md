# README
Heroku: https://sheltered-brook-46825.herokuapp.com/

Requests:
* POST https://sheltered-brook-46825.herokuapp.com/encode
* POST https://sheltered-brook-46825.herokuapp.com/decode

Params for both requests: { url: 'any url here' }

## Installation
Run `bundle install`.
`rails s` to start server. `rspec` to run tests.
## Potential attack vectors
A potential attack vector to think about is code injection in the input. This can be prevented by using various mitigation methods such as escaping user input data, adding input validation, etc.

Currently, I have allowed only the attribute 'url' in the params, and I also check if it is a valid url before proceeding further.

## Scaling
The short code used in this project is generated by nanoid, using the ID length of 12 characters. nanoid is the Ruby implementation of the original NanoId written for Javascript. Nano ID uses the `crypto` module in Node.js and the Web Crypto API in browsers, these modules use unpredictable hardware random generator. Nano ID is quite comparable to UUID v4 (random-based). It has a similar number of random bits in the ID (126 in Nano ID and 122 in UUID), so it has a similar collision probability: 
> For there to be a one in a billion chance of duplication, 103 trillion version 4 IDs must be generated.

With the ID length of 12, provided that 1000 IDs are generated hour, you will need ~1 thousand years in order to have a 1% probability of at least one collision.

For more scaling up possibilities, we can consider:

* Increasing ID length to further reduce risk of collision.

* Adding expiration for old, unused links. By removing these, the number of used codes will decrease, leading to lower chance of collision. This can be achieved by checking the last used date of the link to see how long it has not been accessed.

* Adding code to handle collision when it does occur, by adding uniqueness validation in the model, and handling the case where saving fails due to collision. When such case happens, we will generate a new one and attempt saving again. This does, however, lead to increase load in write performance.
