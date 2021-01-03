const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp();

const fcm =  admin.messaging();

exports.sendNotificationToAll = functions.firestore
    .document('posts/{postID}')
    .onCreate(async snap => {
        
        const data = snap.data();

        var payload = {
            notification : {
                title : `New Post from ${data.creator}`,
                body : data.post,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                sound : 'default'
            },
            topic : 'feed',
           
        }
       
        return fcm.send(payload).then((res) => {
            console.log("Successfully send message");
        }).catch((err) => {
            console.log("An Error has occured:", err);
        });
    
    })