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
              <th>Rating</th>
              <th>Note</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="readingList/book">
              <tr>
                <td><xsl:value-of select="id" /></td>
                <td><xsl:value-of select="status" /></td>
                <td>
                  <xsl:call-template name="render-stars">
                    <xsl:with-param name="value" select="rating" />
                  </xsl:call-template>
                </td>
                <td><xsl:value-of select="note" /></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="render-stars">
    <xsl:param name="value" />
    <xsl:variable name="filled" select="floor($value)" />
    <xsl:variable name="half" select="(number($value) - floor($value)) &gt;= 0.5" />
    <xsl:variable name="max" select="5" />
    <!-- Full stars -->
    <xsl:for-each select="document('')/*[1]/*[position() &lt;= $filled]">
      <xsl:text>★</xsl:text>
    </xsl:for-each>
    <!-- Half star -->
    <xsl:if test="$half">
      <xsl:text>⯪</xsl:text>
    </xsl:if>
    <!-- Empty stars -->
    <xsl:for-each select="document('')/*[1]/*[position() &lt;= ($max - $filled - $half)]">
      <xsl:text>☆</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
