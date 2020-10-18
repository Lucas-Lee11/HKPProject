# Backend for HKP Final Project
## Libraries Used
* express
* jsonwebtoken
* mongoose
* bcryptjs

## Routes
### `/users/login` POST
### Request
```json
{
  "username": "some username",
  "password": "some password"
}
```
This route requests a JSON object containing a username and password

### Response
```json
{
  "token": "arbitrary signed token"
 }
 ```
 Requesting from this route returns a JWT web token which contains the following information:
 * MongoDB Database ID
 * Username
 * Time of creation
 * Time of expiration (1 day)
 
### `/users/register` POST
### Request
```json
{
  "username": "some username",
  "password": "some password",
  "admin": "boolean"
}
```
This route requests a JSON object containing a username, password, and permission level (i.e. admin or customer)

### Response
```json
{
  "token": "arbitrary signed token"
 }
 ```
 Requesting from this route returns a JWT web token which contains the following information:
 * MongoDB Database ID
 * Username
 * Time of creation
 * Time of expiration (1 day)
 
 ### `/items/list` GET
 ### Request
 ```json
 ```
 This route does not ask for any data in its request.
 
 ### Response
 
```json
{ "items": [
    {
      "name": "item name",
      "description": "item description",
      "quantity": "quantity of the item (default: 0)",
      "image": "imgur link of image (not implemented yet)"
    },
    {
      "name": "another item name",
      "description": "another item description",
      "quantity": "another quantity of the item (default: 0)",
      "image": "imgur link of image (not implemented yet)"
    }
  ]
}
```
This route returns a response with a list containing item document objects. Each item has a name (String), description (String), quantity (Number), and image (String imgur link) field.

### `/items/create` POST
### Request
```json
{
  "name": "item name",
  "description": "item description",
  "quantity": , item quantity (Number),
  "image": "Not implemented it (Actually no idea how to get binary data through json requests"
}
```
This route requests for a JSON object containing the fields listed above which will then be saved into the Item database.

### Response
```json
{
  "_id": "database entry id",
  "name": "item name",
  "description": "item description",
  "quantity": , item quantity (Number)
    "__v": 0
}
```
This route returns a response with the database entry of the item that was created from the request.

### `/cart` GET
### Request
```json
{
  "token": "some user token"
}
This route requests for a user token for access to user information
```

### Response
```json
[
  {
    "_id": "database entry id",
    "name": "item name",
    "description": "item description",
    "quantity": , item quantity (Number)
    "__v": 0
  },
  {
    "_id": "another database entry id",
    "name": "another item name",
    "description": "another item description",
    "quantity": , another item quantity (Number)
    "__v": 0
  }
]
```
This route returns a response with a list of all the items associated with a user (their cart).

### `/cart` POST
### Request
```json
{
    "token: "some token",
    "cart": [
        {
            "name": "apple",
            "description": "el apple",
            "quantity": 5
        },
        {
            "name": "orange",
            "description": "el orange",
            "quantity": 10
        }
    ]
}
```
Route requests for a token for authentication, and a cart key which is a list of items

### Reponse
```json
{
  "message": "Cart saved."
}
Route responds with a message, "Cart saved." if it successfully stores it in the database.
