
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const algoliasearch = require("algoliasearch").default;

// Firebase Admin 초기화
admin.initializeApp(functions.config().firestore);

// Firestore 참조
// const firestore = admin.firestore();

// Algolia 클라이언트 초기화
// const ALGOLIA_APP_ID = "L0ZWCL0CYR";
// const ALGOLIA_API_KEY = "7caf5c06565eab83d67cca55ac449dc2";
const ALGOLIA_INDEX_NAME = "HealthySecretUsers";

const client = algoliasearch("L0ZWCL0CYR", "7caf5c06565eab83d67cca55ac449dc2");
const index = client.initIndex(ALGOLIA_INDEX_NAME);
exports.sendCollectionToAlgolia = functions
    .region("asia-northeast2")
    .https.onRequest(async (request, response) => {
      const firestore = admin.firestore();
      const algoliaRecords = [];
      const snapshot = await firestore
          .collection("HealthySecretUsers").get();
      snapshot.forEach((doc) => {
        const document = doc.data();
        const record = {
          objectID: doc.id,
          activity: document.activity,
          age: document.age,
          blocked: document.blocked,
          blocking: document.blocking,
          calorie: document.calorie,
          diarys: document.diarys,
          exercise: document.exercise,
          followers: document.followers,
          followings: document.followings,
          goalWeight: document.goalWeight,
          ingredients: document.ingredients,
          loginMethod: document.loginMethod,
          name: document.name,
          nowWeight: document.nowWeight,
          report: document.report,
          sex: document.sex,
          tall: document.tall,
          uuid: document.uuid,
        };

        algoliaRecords.push(record);
      });

      // After all records are created, save them to Algolia
      index.saveObjects(algoliaRecords, (_error, content) => {
        response.status(200)
            .send("COLLECTION was indexed to Algolia successfully.");
      });
    });

exports.collectionOnCreate = functions
    .region("asia-northeast2")
    .firestore.document("HealthySecretUsers/{documentId}")
    .onCreate(async (snapshot, context) => {
      await saveDocumentInAlgolia(snapshot);
    });

const saveDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const document = snapshot.data();
    console.log(snapshot.id);
    if (document) {
      const record = {
        objectID: snapshot.id,
        activity: document.activity,
        age: document.age,
        blocked: document.blocked,
        blocking: document.blocking,
        calorie: document.calorie,
        diarys: document.diarys,
        exercise: document.exercise,
        followers: document.followers,
        followings: document.followings,
        goalWeight: document.goalWeight,
        ingredients: document.ingredients,
        loginMethod: document.loginMethod,
        name: document.name,
        nowWeight: document.nowWeight,
        report: document.report,
        sex: document.sex,
        tall: document.tall,
        uuid: document.uuid,
      };
      index.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

exports.ticcleOnUpdate = functions
    .region("asia-northeast2")
    .firestore.document("HealthySecretUsers/{documentId}")
    .onUpdate(async (change, context) => {
      await updateDocumentInAlgolia(context.params.documentId, change);
    });


const updateDocumentInAlgolia = async (objectID, change) => {
  const after = change.after.data();
  const before = change.before.data();
  const record = {objectID: objectID,
    activity: after.activity,
    age: after.age,
    blocked: after.blocked,
    blocking: after.blocking,
    calorie: after.calorie,
    diarys: after.diarys,
    exercise: after.exercise,
    followers: after.followers,
    followings: after.followings,
    goalWeight: after.goalWeight,
    ingredients: after.ingredients,
    loginMethod: after.loginMethod,
    name: after.name,
    nowWeight: after.nowWeight,
    report: after.report,
    sex: after.sex,
    tall: after.tall,
    uuid: after.uuid,
  };
  let flag = false;
  if (before.activity != after.activity || before.age != after.age ||
before.blocked != after.blocked ||
before.blocking != after.blocking ||
before.calorie != after.calorie || before.diarys != after.diarys ||
before.exercise != after.exercise ||
before.followers != after.followers ||
before.followings != after.followings ||
before.goalWeight != after.goalWeight ||
before.ingredients != after.ingredients ||
before.loginMethod != after.loginMethod ||
before.name != after.name ||
before.nowWeight != after.nowWeight || before.report != after.report ||
before.sex != after.sex ||
before.tall != after.tall || before.uuid != after.uuid ) {
    flag = true;
  }

  if (flag) {
    // update
    index.partialUpdateObject(record)
        .catch((res) => console.log("Error with: ", res));
  }
};


// Firestore 문서가 삭제될 때 Algolia에서 삭제
exports.ticcleOnDelete = functions
    .region("asia-northeast2")
    .firestore.document("HealthySecretUsers/{documentId}")
    .onDelete(async (snapshot, context) => {
      await deleteDocumentInAlgolia(snapshot);
    });

const deleteDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    index.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};
