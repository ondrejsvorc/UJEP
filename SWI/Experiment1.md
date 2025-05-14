# Experiment 1

## Prompt (template)
```
You are an assistant that generates OpenAPI 3.0 documentation in JSON format.

The API should allow users to manage a collection of [EntityName].

Each [EntityName] has the following properties:
– [field1Name] ([type], [required/optional])
– [field2Name] ([type], [required/optional])
– [field3Name] ([type], [required/optional])
– …

The system also includes related entities:
– [RelatedEntity1Name]: [field1] ([type]), [field2] ([type, optional])
– [RelatedEntity2Name]: [field1] ([type])

Relationships:
– A [EntityName] can have multiple [RelatedEntity1Name] and [RelatedEntity2Name]
– [any other relationship, e.g. “Authors can be shared across books”]

The API should support the following operations:
– Create new [EntityName]
– View all [EntityName]
– View specific [EntityName] by ID
– Update [EntityName] by ID
– Delete [EntityName] by ID
– List all [RelatedEntity1Name]
– Filter [EntityName] by [field or related entity]

Constraints and assumptions:
– Use JSON for requests and responses
– Use RESTful HTTP conventions and standard status codes
– The API is public and does not require authentication
– Include reusable components under `components.schemas`
– Add a `summary` for each operation
```

## Prompt (example)
```
You are an assistant that generates OpenAPI 3.0 documentation in JSON format.

The API should allow users to manage a collection of books.

Each book has the following properties:
- id (guid, required)
– title (string, required)
– publicationYear (integer, optional)
– authors (array of Author, required)
– genres (array of Genre, required)

The system also includes related entities:
– Author: id (guid, required), name (string, required), dateOfBirth (string, optional)
– Genre: id (guid, required), name (string, required)

Relationships:
– A book can have multiple authors and genres
– Authors can be shared across multiple books
– Genres can be reused by many books

The API should support the following operations:
– Create new book (with authors and genres)
– View all books
- View all books by author or genre
– View specific book by ID
– Update book by ID
– Delete book by ID
– View all authors
– View all genres

Constraints and assumptions:
– Use JSON for requests and responses
– Use RESTful HTTP conventions and standard status codes
– The API is public and does not require authentication
– Include reusable components under `components.schemas`
– Add a `summary` for each operation
```

## Prompt (example output)
```json
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