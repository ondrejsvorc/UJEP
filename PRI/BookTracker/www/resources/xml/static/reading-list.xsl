<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html>
      <head>
        <title>Reading List</title>
        <style>
          body {
            font-family: sans-serif;
            padding: 20px;
            max-width: 800px;
            margin: auto;
          }
          table {
            border-collapse: collapse;
            width: 100%;
          }
          th, td {
            border: 1px solid #ccc;
            padding: 6px;
            text-align: left;
          }
        </style>
      </head>
      <body>
        <h2>📚 Reading List</h2>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="readingList/book">
              <tr>
                <td><xsl:value-of select="id" /></td>
                <td><xsl:value-of select="status" /></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>