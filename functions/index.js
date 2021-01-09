const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp();

const fcm =  admin.messaging();
const db = admin.firestore();

exports.sendNotificationToAll = functions.firestore
    .document('posts/{postID}')
    .onCreate(async snap => {
        
        const data = snap.data();
       
        const payload = {
            notification : {
                title : `New Post from ${data.creator}`,
                body : data.post,
            },
            android: {
                notification: {
                  sound: 'default',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK',
                },
              },
            apns: {
                payload: {
                  aps: {
                    sound: 'default'
                  },
                },
            },
            topic : 'feed',
           
        }
       
        return fcm.send(payload).then((res) => {
            console.log("Successfully send message");
        }).catch((err) => {
            console.log("An Error has occured:", err);
        });
    
    })
exports.sendLikedNotification = functions.firestore
    .document("posts/{postID}")
    .onUpdate(async (change) => {

      const before = change.before;
      const after = change.after; 
     
      console.log(before.data().likes);
      console.log(after.data().likes);

     if(before.data().likes != undefined){
       if(after.data().likes == [] || after.data().likes < before.data().likes){
          console.log("Do NOT send notification. User unliked post.")
          return;
       }
     }
      

      const creatorID = before.data().creatorID;
      const postMessage = before.data().post;
      const ids = after.data().likes;

      const likedByUser = ids[ids.length - 1];
      console.log("New liked user: " + likedByUser);
      

      // get token and username from user
      const likedByUsername = await db
        .doc(`users/${likedByUser}`)
        .get()
        .then((snap) => {
          return snap.data().username;
        })
        .catch(err => {
          console.log("Error occured when location username ", err);
        });
      console.log(likedByUsername);

      const creatorTokens = await db
        .doc(`users/${creatorID}`)
        .get()
        .then((snap) => snap.data().tokens)
        .catch(err => {
          console.log("Error occured when getting creator tokens ", err);
        });

      console.log(creatorTokens);
      console.log(typeof(creatorTokens));
      
      const payload = {
        notification : {
            title : `${likedByUsername} liked your post`,
            body : `"${postMessage}"`,
        },
        android: {
            notification: {
              sound: 'default',
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
          },
        apns: {
            payload: {
              aps: {
                sound: 'default'
              },
            },
        },
        tokens : creatorTokens,
      }

      return fcm.sendMulticast(payload).then((res) => {
        console.log("Successfully sent liked notification",res);
      }).catch(err => {
        console.log("An error has occured",err);
      })
    })