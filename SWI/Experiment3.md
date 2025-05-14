# Experiment 3

## Prompt (template)
```
You are an assistant that generates C# .NET 8 Minimal API route definitions.

Generate a self-contained set of C# route definitions using `app.Map...` methods that handle CRUD operations for a REST API defined in the following OpenAPI 3.0 document (JSON format).

Requirements:
– Use C# classes (not records) for the data models  
– Models should be ready to use with Entity Framework Core (i.e., use `Id` fields, standard naming)  
– Assume a fake `DbContext` named `FakeDbContext` with `DbSet<T>` properties  
– Use proper dependency injection for injecting the `FakeDbContext`  
– Do not use in-memory collections (no `List<Book>` etc.)  
– Return only the code needed to define the endpoints and models – no boilerplate or full project  
– Use idiomatic .NET 8 Minimal API style

Paste your output as valid C# code.

Input OpenAPI JSON:
[Experiment 2 JSON output]
```

## Prompt (example)
```
You are an assistant that generates C# .NET 8 Minimal API route definitions.

Generate a self-contained set of C# route definitions using `app.Map...` methods that handle CRUD operations for a REST API defined in the following OpenAPI 3.0 document (JSON format).

Requirements:
– Use C# classes (not records) for the data models  
– Models should be ready to use with Entity Framework Core (i.e., use `Id` fields, standard naming)  
– Assume a fake `DbContext` named `FakeDbContext` with `DbSet<T>` properties  
– Use proper dependency injection for injecting the `FakeDbContext`  
– Do not use in-memory collections (no `List<Book>` etc.)  
– Return only the code needed to define the endpoints and models – no boilerplate or full project  
– Use idiomatic .NET 8 Minimal API style

Paste your output as valid C# code.

Input OpenAPI JSON:
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

## Prompt (example output)
```csharp
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

// Data models

public class Book
{
    public Guid Id { get; set; }
    public string Title { get; set; }
    public int? PublicationYear { get; set; }

    // EF Core many‐to‐many
    public List<Author> Authors { get; set; } = new();
    public List<Genre> Genres   { get; set; } = new();
}

public class Author
{
    public Guid Id { get; set; }
    public string Name { get; set; }
    public DateTime? DateOfBirth { get; set; }

    public List<Book> Books { get; set; } = new();
}

public class Genre
{
    public Guid Id { get; set; }
    public string Name { get; set; }

    public List<Book> Books { get; set; } = new();
}

// DTO for create/update
public class BookInput
{
    public string Title { get; set; }
    public int? PublicationYear { get; set; }
    public List<Guid> Authors { get; set; } = new();
    public List<Guid> Genres  { get; set; } = new();
}

// Fake DbContext
public class FakeDbContext : DbContext
{
    public FakeDbContext(DbContextOptions<FakeDbContext> opts) : base(opts) {}

    public DbSet<Book> Books     { get; set; }
    public DbSet<Author> Authors { get; set; }
    public DbSet<Genre> Genres   { get; set; }
}

// Route definitions

app.MapGet("/books", async (FakeDbContext db, Guid? authorId, Guid? genreId) =>
{
    var query = db.Books
        .Include(b => b.Authors)
        .Include(b => b.Genres)
        .AsQueryable();

    if (authorId.HasValue)
        query = query.Where(b => b.Authors.Any(a => a.Id == authorId.Value));

    if (genreId.HasValue)
        query = query.Where(b => b.Genres.Any(g => g.Id == genreId.Value));

    var list = await query.ToListAsync();
    return Results.Ok(list);
})
.WithName("GetBooks")
.Produces<List<Book>>(statusCode: 200);

app.MapGet("/books/{bookId:guid}", async (FakeDbContext db, Guid bookId) =>
{
    var book = await db.Books
        .Include(b => b.Authors)
        .Include(b => b.Genres)
        .FirstOrDefaultAsync(b => b.Id == bookId);

    return book is not null
        ? Results.Ok(book)
        : Results.NotFound(new { code = 404, message = "Book not found" });
})
.WithName("GetBookById")
.Produces<Book>(200)
.Produces(404);

app.MapPost("/books", async (FakeDbContext db, BookInput input) =>
{
    var book = new Book
    {
        Id = Guid.NewGuid(),
        Title = input.Title,
        PublicationYear = input.PublicationYear,
        Authors = await db.Authors.Where(a => input.Authors.Contains(a.Id)).ToListAsync(),
        Genres   = await db.Genres  .Where(g => input.Genres.Contains(g.Id)).ToListAsync()
    };

    db.Books.Add(book);
    await db.SaveChangesAsync();

    return Results.Created($"/books/{book.Id}", book);
})
.WithName("CreateBook")
.Accepts<BookInput>("application/json")
.Produces<Book>(201);

app.MapPut("/books/{bookId:guid}", async (FakeDbContext db, Guid bookId, BookInput input) =>
{
    var book = await db.Books
        .Include(b => b.Authors)
        .Include(b => b.Genres)
        .FirstOrDefaultAsync(b => b.Id == bookId);

    if (book is null)
        return Results.NotFound(new { code = 404, message = "Book not found" });

    book.Title = input.Title;
    book.PublicationYear = input.PublicationYear;
    book.Authors.Clear();
    book.Authors.AddRange(await db.Authors.Where(a => input.Authors.Contains(a.Id)).ToListAsync());
    book.Genres.Clear();
    book.Genres.AddRange(await db.Genres.Where(g => input.Genres.Contains(g.Id)).ToListAsync());

    await db.SaveChangesAsync();
    return Results.Ok(book);
})
.WithName("UpdateBook")
.Accepts<BookInput>("application/json")
.Produces<Book>(200)
.Produces(404);

app.MapDelete("/books/{bookId:guid}", async (FakeDbContext db, Guid bookId) =>
{
    var book = await db.Books.FindAsync(bookId);
    if (book is null)
        return Results.NotFound(new { code = 404, message = "Book not found" });

    db.Books.Remove(book);
    await db.SaveChangesAsync();
    return Results.NoContent();
})
.WithName("DeleteBook")
.Produces(204)
.Produces(404);

app.MapGet("/authors", async (FakeDbContext db) =>
{
    var authors = await db.Authors.ToListAsync();
    return Results.Ok(authors);
})
.WithName("GetAuthors")
.Produces<List<Author>>(200);

app.MapGet("/genres", async (FakeDbContext db) =>
{
    var genres = await db.Genres.ToListAsync();
    return Results.Ok(genres);
})
.WithName("GetGenres")
.Produces<List<Genre>>(200);
```