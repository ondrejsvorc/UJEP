## 📚 BookTracker

Web application for **tracking and rating books**. Users can **browse** a list of books from the database, **search and filter** them, **import/export** their personal reading list in XML, and assign each book a **reading status**, **rating** (0–5 ★), and a **note**.

### ERD Diagram
![ERD Diagram](sql/db_diagram.png)

### Technology
- PHP 8, Apache, MySQL, Docker
- JavaScript, HTML5, CSS3
- XML, XSD, XSLT

### Pages
- `index.php`: navigation
- `list.php`: all books with filtering, search, import/export
- `detail.php`: book detail
- `edit.php`: book update
- `xsl.php`: transformed reading list

### Structure
```
📦BookTracker
 ┣ 📂Dockerfiles
 ┃ ┣ 📜Database
 ┃ ┗ 📜WebServer
 ┣ 📂sql
 ┃ ┣ 📜db_diagram.png
 ┃ ┗ 📜init.sql
 ┣ 📂www
 ┃ ┣ 📂includes
 ┃ ┃ ┣ 📜constants.php
 ┃ ┃ ┣ 📜db.php
 ┃ ┃ ┣ 📜functions.php
 ┃ ┃ ┗ 📜layout.php
 ┃ ┣ 📂resources
 ┃ ┃ ┣ 📂xml
 ┃ ┃ ┃ ┣ 📂imported
 ┃ ┃ ┃ ┃ ┗ 📜reading-list.xml
 ┃ ┃ ┃ ┗ 📂static
 ┃ ┃ ┃ ┃ ┣ 📂test
 ┃ ┃ ┃ ┃ ┃ ┣ 📜reading-corrupt.xml
 ┃ ┃ ┃ ┃ ┃ ┣ 📜reading-invalid-rating.xml
 ┃ ┃ ┃ ┃ ┃ ┣ 📜reading-list-large.xml
 ┃ ┃ ┃ ┃ ┃ ┣ 📜reading-missing-status.xml
 ┃ ┃ ┃ ┃ ┃ ┣ 📜reading-valid.xml
 ┃ ┃ ┃ ┃ ┃ ┗ 📜reading-wrong-root.xml
 ┃ ┃ ┃ ┃ ┣ 📜reading-list.xsd
 ┃ ┃ ┃ ┃ ┗ 📜reading-list.xsl
 ┃ ┃ ┗ 📜book.svg
 ┃ ┣ 📜.htaccess
 ┃ ┣ 📜detail.php
 ┃ ┣ 📜edit.php
 ┃ ┣ 📜export.php
 ┃ ┣ 📜import.php
 ┃ ┣ 📜index.php
 ┃ ┣ 📜list.php
 ┃ ┗ 📜xsl.php
 ┣ 📜docker-compose.yml
 ┗ 📜README.md
```