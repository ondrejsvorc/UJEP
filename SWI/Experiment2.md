# Experiment 2

## Prompt (template)
```
You are an assistant that improves existing OpenAPI 3.0 documentation in JSON format.

Your task is to read the provided OpenAPI 3.0 specification (in JSON format) and return an improved version of it.

Apply the following improvements:
– Add missing `summary` and `description` fields where appropriate
– Add example request and response payloads where useful
– Add schema constraints (e.g., minLength, maxLength, enum, format) where relevant
– Ensure consistent and clean formatting
– Do not remove or rename any existing endpoints or schemas
– Keep the output in valid OpenAPI 3.0 JSON format

Your output should be a complete and self-contained OpenAPI document that includes all the improvements inline.

Here is the original OpenAPI document to improve:
[Experiment 1 JSON output]
```

## Prompt (example)
```
You are an assistant that improves existing OpenAPI 3.0 documentation in JSON format.

Your task is to read the provided OpenAPI 3.0 specification (in JSON format) and return an improved version of it.

Apply the following improvements:
– Add missing `summary` and `description` fields where appropriate
– Add example request and response payloads where useful
– Add schema constraints (e.g., minLength, maxLength, enum, format) where relevant
– Ensure consistent and clean formatting
– Do not remove or rename any existing endpoints or schemas
– Keep the output in valid OpenAPI 3.0 JSON format

Your output should be a complete and self-contained OpenAPI document that includes all the improvements inline.

Here is the original OpenAPI document to improve:
[Experiment 1 JSON output]
{
  "openapi": "3.0.0",
  "info": {
    "title": "Book Management API",
    "version": "1.0.0",
    "description": "API for managing a collection of books, authors, and genres"
  },
  "servers": [
    {
      "url": "https://api.example.com",
      "description": "Production server"
    }
  ],
  "paths": {
    "/books": {
      "get": {
        "summary": "View all books",
        "parameters": [
          {
            "name": "authorId",
            "in": "query",
            "description": "Filter books by author ID",
            "schema": {
              "type": "string",
              "format": "uuid"
            }
          },
          {
            "name": "genreId",
            "in": "query",
            "description": "Filter books by genre ID",
            "schema": {
              "type": "string",
              "format": "uuid"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "A list of books",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Book"
                  }
                }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create a new book",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/BookInput"
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Book created",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Book"
                }
              }
            }
          }
        }
      }
    },
    "/books/{bookId}": {
      "get": {
        "summary": "View a specific book by ID",
        "parameters": [
          {
            "name": "bookId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "format": "uuid"
            },
            "description": "The ID of the book to retrieve"
          }
        ],
        "responses": {
          "200": {
            "description": "The requested book",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Book"
                }
              }
            }
          },
          "404": {
            "description": "Book not found"
          }
        }
      },
      "put": {
        "summary": "Update a book by ID",
        "parameters": [
          {
            "name": "bookId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "format": "uuid"
            },
            "description": "The ID of the book to update"
          }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/BookInput"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Updated book",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Book"
                }
              }
            }
          },
          "404": {
            "description": "Book not found"
          }
        }
      },
      "delete": {
        "summary": "Delete a book by ID",
        "parameters": [
          {
            "name": "bookId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string",
              "format": "uuid"
            },
            "description": "The ID of the book to delete"
          }
        ],
        "responses": {
          "204": {
            "description": "Book deleted"
          },
          "404": {
            "description": "Book not found"
          }
        }
      }
    },
    "/authors": {
      "get": {
        "summary": "View all authors",
        "responses": {
          "200": {
            "description": "A list of authors",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Author"
                  }
                }
              }
            }
          }
        }
      }
    },
    "/genres": {
      "get": {
        "summary": "View all genres",
        "responses": {
          "200": {
            "description": "A list of genres",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Genre"
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Book": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid",
            "readOnly": true
          },
          "title": {
            "type": "string"
          },
          "publicationYear": {
            "type": "integer"
          },
          "authors": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/Author"
            }
          },
          "genres": {
            "type": "array",
            "items": {
              "$ref": "#/components/schemas/Genre"
            }
          }
        },
        "required": ["id", "title", "authors", "genres"]
      },
      "BookInput": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string"
          },
          "publicationYear": {
            "type": "integer"
          },
          "authors": {
            "type": "array",
            "items": {
              "type": "string",
              "format": "uuid"
            }
          },
          "genres": {
            "type": "array",
            "items": {
              "type": "string",
              "format": "uuid"
            }
          }
        },
        "required": ["title", "authors", "genres"]
      },
      "Author": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid"
          },
          "name": {
            "type": "string"
          },
          "dateOfBirth": {
            "type": "string",
            "format": "date"
          }
        },
        "required": ["id", "name"]
      },
      "Genre": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid"
          },
          "name": {
            "type": "string"
          }
        },
        "required": ["id", "name"]
      }
    }
  }
}
```

## Prompt (example output)
```json
{
  "openapi": "3.0.0",
  "info": {
    "title": "Book Management API",
    "version": "1.0.0",
    "description": "API for managing a collection of books, authors, and genres."
  },
  "servers": [
    {
      "url": "https://api.example.com",
      "description": "Production server"
    }
  ],
  "paths": {
    "/books": {
      "get": {
        "summary": "View all books",
        "description": "Retrieve a list of all books, optionally filtered by author or genre.",
        "parameters": [
          {
            "name": "authorId",
            "in": "query",
            "description": "UUID of an author to filter books by.",
            "schema": { "type": "string", "format": "uuid" }
          },
          {
            "name": "genreId",
            "in": "query",
            "description": "UUID of a genre to filter books by.",
            "schema": { "type": "string", "format": "uuid" }
          }
        ],
        "responses": {
          "200": {
            "description": "A list of books matching the filters.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/Book" }
                },
                "example": [
                  {
                    "id": "a3bb189e-8bf9-3888-9912-ace4e6543002",
                    "title": "1984",
                    "publicationYear": 1949,
                    "authors": [
                      {
                        "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
                        "name": "George Orwell",
                        "dateOfBirth": "1903-06-25"
                      }
                    ],
                    "genres": [
                      {
                        "id": "5a1f1ec5-6c54-4b01-90e6-d701748f1111",
                        "name": "Dystopian"
                      }
                    ]
                  }
                ]
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create a new book",
        "description": "Add a new book to the collection, specifying its title, publication year, authors, and genres.",
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": { "$ref": "#/components/schemas/BookInput" },
              "example": {
                "title": "1984",
                "publicationYear": 1949,
                "authors": [
                  "d290f1ee-6c54-4b01-90e6-d701748f0851"
                ],
                "genres": [
                  "5a1f1ec5-6c54-4b01-90e6-d701748f1111"
                ]
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Book successfully created.",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Book" },
                "example": {
                  "id": "a3bb189e-8bf9-3888-9912-ace4e6543002",
                  "title": "1984",
                  "publicationYear": 1949,
                  "authors": [
                    {
                      "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
                      "name": "George Orwell",
                      "dateOfBirth": "1903-06-25"
                    }
                  ],
                  "genres": [
                    {
                      "id": "5a1f1ec5-6c54-4b01-90e6-d701748f1111",
                      "name": "Dystopian"
                    }
                  ]
                }
              }
            }
          }
        }
      }
    },
    "/books/{bookId}": {
      "get": {
        "summary": "View a specific book by ID",
        "description": "Retrieve detailed information about a single book by its UUID.",
        "parameters": [
          {
            "name": "bookId",
            "in": "path",
            "required": true,
            "description": "UUID of the book to retrieve.",
            "schema": { "type": "string", "format": "uuid" }
          }
        ],
        "responses": {
          "200": {
            "description": "The requested book details.",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Book" },
                "example": {
                  "id": "a3bb189e-8bf9-3888-9912-ace4e6543002",
                  "title": "1984",
                  "publicationYear": 1949,
                  "authors": [
                    {
                      "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
                      "name": "George Orwell",
                      "dateOfBirth": "1903-06-25"
                    }
                  ],
                  "genres": [
                    {
                      "id": "5a1f1ec5-6c54-4b01-90e6-d701748f1111",
                      "name": "Dystopian"
                    }
                  ]
                }
              }
            }
          },
          "404": {
            "description": "Book not found.",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Error" },
                "example": {
                  "code": 404,
                  "message": "Book not found"
                }
              }
            }
          }
        }
      },
      "put": {
        "summary": "Update a book by ID",
        "description": "Replace all fields of an existing book. Provide title, publication year, author IDs, and genre IDs.",
        "parameters": [
          {
            "name": "bookId",
            "in": "path",
            "required": true,
            "description": "UUID of the book to update.",
            "schema": { "type": "string", "format": "uuid" }
          }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": { "$ref": "#/components/schemas/BookInput" },
              "example": {
                "title": "Nineteen Eighty-Four",
                "publicationYear": 1949,
                "authors": [
                  "d290f1ee-6c54-4b01-90e6-d701748f0851"
                ],
                "genres": [
                  "5a1f1ec5-6c54-4b01-90e6-d701748f1111"
                ]
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Book successfully updated.",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Book" },
                "example": {
                  "id": "a3bb189e-8bf9-3888-9912-ace4e6543002",
                  "title": "Nineteen Eighty-Four",
                  "publicationYear": 1949,
                  "authors": [
                    {
                      "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
                      "name": "George Orwell",
                      "dateOfBirth": "1903-06-25"
                    }
                  ],
                  "genres": [
                    {
                      "id": "5a1f1ec5-6c54-4b01-90e6-d701748f1111",
                      "name": "Dystopian"
                    }
                  ]
                }
              }
            }
          },
          "404": {
            "description": "Book not found.",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Error" },
                "example": {
                  "code": 404,
                  "message": "Book not found"
                }
              }
            }
          }
        }
      },
      "delete": {
        "summary": "Delete a book by ID",
        "description": "Remove a book from the collection by its UUID.",
        "parameters": [
          {
            "name": "bookId",
            "in": "path",
            "required": true,
            "description": "UUID of the book to delete.",
            "schema": { "type": "string", "format": "uuid" }
          }
        ],
        "responses": {
          "204": {
            "description": "Book deleted successfully. No content returned."
          },
          "404": {
            "description": "Book not found.",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Error" },
                "example": {
                  "code": 404,
                  "message": "Book not found"
                }
              }
            }
          }
        }
      }
    },
    "/authors": {
      "get": {
        "summary": "View all authors",
        "description": "Retrieve a list of all authors.",
        "responses": {
          "200": {
            "description": "A list of authors.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/Author" }
                },
                "example": [
                  {
                    "id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
                    "name": "George Orwell",
                    "dateOfBirth": "1903-06-25"
                  }
                ]
              }
            }
          }
        }
      }
    },
    "/genres": {
      "get": {
        "summary": "View all genres",
        "description": "Retrieve a list of all genres.",
        "responses": {
          "200": {
            "description": "A list of genres.",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/Genre" }
                },
                "example": [
                  {
                    "id": "5a1f1ec5-6c54-4b01-90e6-d701748f1111",
                    "name": "Dystopian"
                  }
                ]
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Author": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid",
            "readOnly": true
          },
          "name": {
            "type": "string",
            "minLength": 1,
            "maxLength": 255,
            "description": "Full name of the author."
          },
          "dateOfBirth": {
            "type": "string",
            "format": "date",
            "description": "Date of birth in YYYY-MM-DD format."
          }
        },
        "required": ["id", "name"]
      },
      "Book": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid",
            "readOnly": true
          },
          "title": {
            "type": "string",
            "minLength": 1,
            "maxLength": 255,
            "description": "Title of the book."
          },
          "publicationYear": {
            "type": "integer",
            "minimum": 1450,
            "maximum": 2025,
            "description": "Year the book was published."
          },
          "authors": {
            "type": "array",
            "minItems": 1,
            "items": { "$ref": "#/components/schemas/Author" }
          },
          "genres": {
            "type": "array",
            "minItems": 1,
            "items": { "$ref": "#/components/schemas/Genre" }
          }
        },
        "required": ["id", "title", "authors", "genres"]
      },
      "BookInput": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string",
            "minLength": 1,
            "maxLength": 255,
            "description": "Title of the book."
          },
          "publicationYear": {
            "type": "integer",
            "minimum": 1450,
            "maximum": 2025,
            "description": "Year the book was published."
          },
          "authors": {
            "type": "array",
            "minItems": 1,
            "items": { "type": "string", "format": "uuid" }
          },
          "genres": {
            "type": "array",
            "minItems": 1,
            "items": { "type": "string", "format": "uuid" }
          }
        },
        "required": ["title", "authors", "genres"]
      },
      "Error": {
        "type": "object",
        "properties": {
          "code": {
            "type": "integer",
            "description": "HTTP status code of the error."
          },
          "message": {
            "type": "string",
            "description": "Error message describing what went wrong."
          }
        },
        "required": ["code", "message"]
      },
      "Genre": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid",
            "readOnly": true
          },
          "name": {
            "type": "string",
            "minLength": 1,
            "maxLength": 100,
            "description": "Name of the genre."
          }
        },
        "required": ["id", "name"]
      }
    }
  }
}
```