generated at: 2013-11-04 22:41:11

## POST /

get message ok

### Target Server

http://localhost

(Plack application)

### Parameters

__application/json__

- `id`: Number (e.g. 1)
- `message`: String (e.g. "blah blah")

### Request

POST /

### Response

```
Status:       200
Content-Type: application/json
Response:
{
   "message" : "Hello"
}

```

## POST /foo

get message ok

### Target Server

http://localhost

(Plack application)

### Parameters

__application/json__

- `id`: Number (e.g. 1)
- `message`: String (e.g. "blah blah")

### Request

POST /foo

### Response

```
Status:       200
Content-Type: application/json
Response:
{
   "message" : "Goodbye"
}

```
