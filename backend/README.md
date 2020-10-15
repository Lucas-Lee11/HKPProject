# Backend for HKP Final Project
## Libraries Used
* express
* jsonwebtoken
* mongoose
* bcryptjs

## Routes
### `/users/login`
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
 
### `/users/register`
### Request
```json
{
  "username": "some username",
  "password": "some password",
  "permission": "level of admin rights"
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
