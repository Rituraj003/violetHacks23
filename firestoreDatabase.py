
# email : rituraj@vt.edu
# password : efficientDiningCenter
from os import times
from time import time
import firebase_admin
from firebase_admin import credentials, firestore
import datetime;
import uuid
import sys
import os
import random

def reource_path(relative_path):
    return os.path.join(
        os.environ.get(
            "_MEIPASS2",
            os.path.abspath(".")
        ),
        relative_path
    )
        


class dbConnect:
    
    def __init__(self):
        cred = credentials.Certificate(reource_path("dining-halls-firebase-adminsdk-g97zv-0dc5bcd65f.json"))
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()
    
    def addData(self,timestamp,people, waitTime ,id = None):
        if id == None:
            id = "c297f6f6-6f2c-11ed-a1eb-0242ac120002"
        myuuid = uuid.uuid1()
        collection = self.db.collection('squiresFoodCourt').document(id).collection("peopleCount")
        res = collection.document(str(myuuid)).set({
            "noOfpeople":people,
            "timestamp": timestamp,
            "waitTime": waitTime
        })
        print(res)
    
    def addDocument(self,hallName):
        myuuid = uuid.uuid1()
        collection = self.db.collection('squiresFoodCourt')
        res = collection.document(str(myuuid)).set({
            "hallName": hallName
        })
        return myuuid;
    

  
# # ct stores current time
# a = dbConnect()
# a.addData();



# THE BELOW CODE WAS ONLY SUPPOSED TO RUN ONCE, DONT UNCOMMENT IT AGAIN OR ELSE IT WILL WRITE NEW DOCUMENTS TO THE CLOUD AND CREATE 
#           AND CREARE CLONE INSTANCE OF ALREADY CREATED DOCUMENTS.


a = dbConnect()
Data = ["Au Bon Pain", "Burger '37"]
for hall in Data:
    currentTime = datetime.datetime.now().timestamp()
    noOfPeople = random.randint(1,12)
    id = a.addDocument(hall)
    waitTime = round(2* noOfPeople / 3)
    a.addData(round(currentTime),noOfPeople,waitTime,str(id))
        