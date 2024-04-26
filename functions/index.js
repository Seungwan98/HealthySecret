const functions = require("firebase-functions");
// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

initializeApp();

exports.helloWorld = functions.https.onRequest((request, response) => {
    const qs = require('qs');

    response.send(request.query.code);
    
});

function makeJWT(){
    const jwt = require('jsonwebtoken')
    const fs = require('fs')
    // Path to download key file from developer.apple.com/account/resources/authkeys/list
    let privateKey = fs.readFileSync('AuthKey_ZL24X6HW63.p8');


    //Sign with your team ID and key ID information.
    let token = jwt.sign({
        iss: 'YH4A87H8M4',
        iat: Math.floor(Date.now() / 1000),
        exp: Math.floor(Date.now() / 1000) + 120,
        aud: 'https://appleid.apple.com',
        sub: 'com.wan.HealthySecret'
    },
        privateKey,{
        algorithm: 'ES256',
        header: { alg: 'ES256', kid: 'ZL24X6HW63' },
    });

    return token;
}


exports.getRefreshToken = functions.https.onRequest( async (request, response) => {
    
    //import the module to use
    const axios = require('axios');
    const qs = require('qs');
    const code = request.query.code

    const client_secret = makeJWT();
    let data = {
        'code': code,
        'client_id': 'com.wan.HealthySecret',
        'client_secret': client_secret,
        'grant_type': 'authorization_code'
    }


    return axios.post(`https://appleid.apple.com/auth/token`, qs.stringify(data), {
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
    }).then(async res => {
        const refresh_token = res.data.refresh_token;

        response.send(refresh_token);
    });
});


exports.revokeToken = functions.https.onRequest(async (request, response) => {
    //import the module to use
    const axios = require('axios');
    const qs = require('qs');
    


    const refresh_token = request.query.refresh_token;
    const client_secret = makeJWT();

    let data = {
        'token': refresh_token,
        'client_id': 'com.wan.HealthySecret',
        'client_secret': client_secret,
        'token_type_hint': 'refresh_token'
    };

    return axios.post(`https://appleid.apple.com/auth/revoke`, qs.stringify(data), {
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
    }).then(async res => {
        console.log(res.data)
        response.send("success");
    });
});