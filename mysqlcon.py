import mysql.connector

# Database connection configuration
def get_database_connection():
    return mysql.connector.connect(
        user='root',
        host='localhost',
        database='userdb'
    )

# CRUD Operations
class UserDatabase:
    def __init__(self):
        self.con = get_database_connection()

    def insert(self, name, age, city):
        try:
            cursor = self.con.cursor()
            sql = "INSERT INTO users (name, age, city) VALUES (%s, %s, %s)"
            user_data = (name, age, city)
            cursor.execute(sql, user_data)
            self.con.commit()
            print("Data Insert Success")
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            cursor.close()

    def update(self, id, name, age, city):
        try:
            cursor = self.con.cursor()
            sql = "UPDATE users SET name=%s, age=%s, city=%s WHERE id=%s"
            user_data = (name, age, city, id)
            cursor.execute(sql, user_data)
            self.con.commit()
            print("Data Update Success")
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            cursor.close()

    def select(self):
        try:
            cursor = self.con.cursor()
            sql = "SELECT id, name, age, city FROM users"
            cursor.execute(sql)
            result = cursor.fetchall()
            print("\nID | Name  | Age | City")
            print("-----------------------")
            for row in result:
                print(f"{row[0]}  | {row[1]} | {row[2]}  | {row[3]}")
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            cursor.close()

    def delete(self, id):
        try:
            cursor = self.con.cursor()
            sql = "DELETE FROM users WHERE id=%s"
            cursor.execute(sql, (id,))
            self.con.commit()
            print("Data Delete Success")
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            cursor.close()

    def close_connection(self):
        self.con.close()

# Main menu function
def main():
    db = UserDatabase()
    
    while True:
        print("\nMenu:")
        print("1. Insert Data")
        print("2. Update Data")
        print("3. Select Data")
        print("4. Delete Data")
        print("5. Exit")
        
        try:
            choice = int(input("Enter Your Choice: "))
            
            if choice == 1:
                name = input("Enter Name: ")
                age = int(input("Enter Age: "))
                city = input("Enter City: ")
                db.insert(name, age, city)
            
            elif choice == 2:
                id = int(input("Enter ID to Update: "))
                name = input("Enter Name: ")
                age = int(input("Enter Age: "))
                city = input("Enter City: ")
                db.update(id, name, age, city)
            
            elif choice == 3:
                db.select()
            
            elif choice == 4:
                id = int(input("Enter ID to Delete: "))
                db.delete(id)
            
            elif choice == 5:
                print("Exiting...")
                db.close_connection()
                break
            
            else:
                print("Invalid Selection. Please Try Again!")
        
        except ValueError:
            print("Please enter a valid number for your choice or inputs.")
        except mysql.connector.Error as err:
            print(f"Database error: {err}")

if __name__ == "__main__":
    main()