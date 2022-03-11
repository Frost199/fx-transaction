# Aza Finance technical assessment Solution

## Project Setup ⚙️

To run this project successfully, there are a few setup that needs to be done.

* Install [docker](https://docs.docker.com/engine/install/ubuntu/)
  and [docker-compose](https://docs.docker.com/compose/install/)
* Make sure you have go installed too.
* Start docker either from the terminal or the desktop application, if it is not already started



## Run the project 🏃🏽

* Open the terminal
* Pull the repository
* `cd` into the project 
* In Your `base` terminal session, run `docker-compose up`, this build the images if it hasn't been built before, and start the services
* Migrations
  * You need to run the migration for this project
  * open a new terminal, `cd` into the base project and run `docker-compose run -d fx-transactions-service bin/rake db:migrate` this runs the migration into the container.
* Tests
  * To run the specified tests in the project
  * You need to run `docker-compose run -e "RAILS_ENV=test" fx-transactions-service bin/rails test` this runs the specified tests in the project
  
## Design Considerations, Decisions and Assumptions 🤔
* Service was containerized to help with easy setup and in the future for easy deployment.
* It was assumed that the customers are valid customers already, as our microservice does not concern itself with validating customers.
* Currency types are validated before they are saved into the database. here is a [link](https://gist.github.com/semmons99/852788) of the currencies I used for validation

## Project Improvements Implemented 🔧

* Caching of requests: 
  * Requests are cache for an hour and this helps improve the response time for when a resource is requested.
* Pagination:
  * The fetching of all transactions is paginated and this helps to  reduce the size of the json object that is sent.
* DB Indexing:
  * Indexing frequently queried columns by, on th database helps in faster queries. here the `transaction_id`, `customer_id` rows are indexed.

## Project APIs 🔌

#### Post
Example request - `127.0.0.1:3000/api/v1/transactions`

###### Successful request - `201 Created`
```json
{
  "fx_transaction": {
    "customer_id": 10,
    "input_amount": 4444.9,
    "input_currency": "eur",
    "output_amount": 0.4,
    "output_currency": "ngn",
    "transaction_id": 2,
    "transaction_date": "2022-03-11T18:39:58.463Z"
  }
}
```
Example response

```json
{
  "data": {
    "id": "1",
    "type": "fx_transaction",
    "attributes": {
      "customer_id": 10,
      "transaction_id": 2,
      "input_amount": "4444.9",
      "input_currency": "eur",
      "output_amount": "0.4",
      "output_currency": "ngn",
      "transaction_date": "2022-03-11T18:39:58.463Z"
    }
  }
}
```

###### Bad request - `422 Unprocessable entity`
```json
{
  "fx_transaction": {
    "customer_id": 10,
    "input_amount": 4444.9,
    "input_currency": "eur",
    "output_amount": 0.4,
    "output_currency": "ngns",
    "transaction_id": 2
  }
}
```
Example response

```json
{
  "errors": [
    {
      "status": 422,
      "title": "Unprocessable Entity",
      "detail": "currency is not supported",
      "source": {
        "pointer": "output_currency"
      }
    },
    {
      "status": 422,
      "title": "Unprocessable Entity",
      "detail": "can't be blank",
      "source": {
        "pointer": "transaction_date"
      }
    }
  ]
}
```

#### Get - Single transaction
Example request - `127.0.0.1:3000/api/v1/transactions/2`

###### Successful response `200 OK`

```json
{
  "data": {
    "id": "1",
    "type": "fx_transaction",
    "attributes": {
      "customer_id": 10,
      "transaction_id": 2,
      "input_amount": "4444.9",
      "input_currency": "eur",
      "output_amount": "0.4",
      "output_currency": "ngn",
      "transaction_date": "2022-03-11T18:39:58.463Z"
    }
  }
}
```

###### Not found `404`

```json
{
  "errors": [
    {
      "status": 404,
      "title": "Record not Found",
      "detail": "We could not find the object you were looking for.",
      "source": {
        "pointer": "/api/v1/transaction/10"
      }
    }
  ]
}
```

#### Get - All transactions
Example request - `127.0.0.1:3000/api/v1/transactions`

###### Successful response `200 OK`

```json
{
  "data": [
    {
      "id": "1",
      "type": "fx_transaction",
      "attributes": {
        "customer_id": 10,
        "transaction_id": 2,
        "input_amount": "4444.9",
        "input_currency": "eur",
        "output_amount": "0.4",
        "output_currency": "ngn",
        "transaction_date": "2022-03-11T18:39:58.463Z"
      }
    },
    {
      "id": "2",
      "type": "fx_transaction",
      "attributes": {
        "customer_id": 10,
        "transaction_id": 10,
        "input_amount": "4444.9",
        "input_currency": "eur",
        "output_amount": "0.4",
        "output_currency": "ngn",
        "transaction_date": "2022-03-11T22:07:45.191Z"
      }
    }
  ],
  "links": {
    "first": "/api/v1/transactions?page=1",
    "last": "/api/v1/transactions?page=1",
    "prev": "/api/v1/transactions",
    "next": "/api/v1/transactions"
  }
}
```

###### Paginated successful response `200 OK`
Example request - `127.0.0.1:3000/api/v1/transactions`

```json
{
  "data": [
    {
      "id": "1",
      "type": "fx_transaction",
      "attributes": {
        "customer_id": 10,
        "transaction_id": 2,
        "input_amount": "4444.9",
        "input_currency": "eur",
        "output_amount": "0.4",
        "output_currency": "ngn",
        "transaction_date": "2022-03-11T18:39:58.463Z"
      }
    }
  ],
  "links": {
    "first": "/api/v1/transactions?page=1",
    "last": "/api/v1/transactions?page=3",
    "prev": "/api/v1/transactions",
    "next": "/api/v1/transactions?page=2"
  }
}
```
