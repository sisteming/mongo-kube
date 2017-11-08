#!/usr/bin/python
from pymongo import MongoClient
import pymongo
pymongo.version
#db = pymongo.MongoClient('mongodb://localhost:27017/').get_database("mytodo")
db = pymongo.MongoClient('mongodb://mongo-0.mongo:27017,mongo-1.mongo:27017,mongo-2.mongo:27017/?replicaSet=rs0').get_database("mytodo")
changestream = db.get_collection("todos")
print "==========================================================="
print db
print changestream
print "==========================================================="
change_stream = changestream.watch([
    {'$match': {
        'operationType': {'$in': ['insert', 'replace', 'delete']}
    }}
])


# Loops forever.
for change in change_stream:
    print(change)
    print "-------------------------------------------------------"