<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>Records</title>
      </head>
      <body>
        <h1>Records</h1>
        <table border="1">
          <thead>
            <tr>
              <th>Id Pozice</th>
              <th>Id Pozice Nadrizeny</th>
              <th>Název</th>
              <th>Plat</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="records/record">
              <tr>
                <td><xsl:value-of select="id_pozice"/></td>
                <td><xsl:value-of select="id_pozicenadrizeny"/></td>
                <td><xsl:value-of select="nazev"/></td>
                <td><xsl:value-of select="plat"/></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>