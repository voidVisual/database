from pymongo import MongoClient

# Establish connection to MongoDB
try:
    client = MongoClient("mongodb://localhost:27017/")
    print("Connection Successful!")
except Exception as e:
    print("Could Not Connect to MongoDB:", e)
    exit()

# Access database
mydatabase = client.myDB

# Access collection in the database
mycollection = mydatabase.user_Table

# Function to insert a document
def insert(id, name, age, city):
    record = {
        'ID': id,
        'Name': name,
        'Age': age,
        'City': city
    }
    mycollection.insert_one(record)
    print("Data Inserted Successfully")

# Function to update a document
def update(name, age, city, id):
    result = mycollection.update_many(
        {"ID": id},
        {
            "$set": {
                "Name": name,
                "Age": age,
                "City": city
            },
            "$currentDate": {"lastModified": True}
        }
    )
    print("Total Records Updated:", result.matched_count)

# Function to show all documents
def showRec():
    cursor = mycollection.find()
    for record in cursor:
        print(record)

# Function to delete a document
def delete(id):
    delete_filter = {'ID': id}
    result = mycollection.delete_many(delete_filter)
    print("Total Records Deleted:", result.deleted_count)

# Main loop
while True:
    print("\nMenu:")
    print("1. Insert Data")
    print("2. Update Data")
    print("3. Print Data")
    print("4. Delete Data")
    print("5. Exit")

    try:
        choice = int(input("Enter Your Choice: "))
    except ValueError:
        print("Invalid Input. Please Enter a Number.")
        continue

    if choice == 1:
        id = input("Enter ID: ")
        name = input("Enter Name: ")
        age = input("Enter Age: ")
        city = input("Enter City: ")
        insert(id, name, age, city)

    elif choice == 2:
        id = input("Enter ID to Update: ")
        name = input("Enter New Name: ")
        age = input("Enter New Age: ")
        city = input("Enter New City: ")
        update(name, age, city, id)

    elif choice == 3:
        showRec()

    elif choice == 4:
        id = input("Enter ID to Delete: ")
        delete(id)

    elif choice == 5:
        print("Exiting Program.")
        break

    else:
        print("Invalid Selection. Please Try Again!")
