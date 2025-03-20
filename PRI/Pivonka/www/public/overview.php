<?php
declare(strict_types=1);
require_once 'allowedTables.php';
?>

<!DOCTYPE html>
<html lang="cs">
<?php include 'head.php'; ?>
<body>
  <h1>Tabulky</h1>

  <label for="tableSelector">Vyberte si tabulku:</label>
  <select id="tableSelector">
    <option value="">-- Vyberte si tabulku --</option>
    <?php foreach ($allowedTables as $table): ?>
        <option value="<?= htmlspecialchars($table) ?>">
            <?= htmlspecialchars(substr($table, strpos($table, '.') + 1)) ?>
        </option>
    <?php endforeach; ?>
  </select>

  <div id="tableContainer"></div>

  <script>
    // Wait until the DOM is fully loaded.
    document.addEventListener('DOMContentLoaded', () => {
      const tableSelector = document.getElementById('tableSelector');
      const tableContainer = document.getElementById('tableContainer');

      tableSelector.addEventListener('change', () => {
        const selectedTable = tableSelector.value;
        if (!selectedTable) {
          tableContainer.innerHTML = '';
          return;
        }
        loadTableData(selectedTable)
          .then(xmlDoc => {
            tableContainer.innerHTML = buildHtmlTable(xmlDoc);
          })
          .catch(error => {
            console.error('Error loading table data:', error);
            tableContainer.innerHTML = '<p>Error loading data.</p>';
          });
      });

      /**
       * Loads table data from the server and returns an XML document.
       * @param {string} table - The table name.
       * @returns {Promise<Document>} - Promise resolving to an XML document.
       */
      const loadTableData = (table) =>
        fetch(`getRecords.php?table=${encodeURIComponent(table)}`)
          .then(response => {
            if (!response.ok) {
              throw new Error(`HTTP error: ${response.status}`);
            }
            return response.text();
          })
          .then(xmlText => {
            const parser = new DOMParser();
            return parser.parseFromString(xmlText, 'application/xml');
          });

      /**
       * Builds a semantic HTML table from the XML document.
       * @param {Document} xmlDoc - The XML document containing records.
       * @returns {string} - The HTML string of the table.
       */
      const buildHtmlTable = (xmlDoc) => {
        const records = xmlDoc.getElementsByTagName('record');
        if (!records.length) {
          return '<p>No records found.</p>';
        }
        const headerKeys = [];
        // Use the first record to determine header keys.
        const firstRecord = records[0];
        for (let i = 0; i < firstRecord.childNodes.length; i++) {
          const child = firstRecord.childNodes[i];
          if (child.nodeType === Node.ELEMENT_NODE) {
            headerKeys.push(child.nodeName);
          }
        }
        const htmlParts = [];
        htmlParts.push('<table>');
        htmlParts.push('<thead><tr>');
        headerKeys.forEach(key => htmlParts.push(`<th>${key}</th>`));
        htmlParts.push('</tr></thead>');
        htmlParts.push('<tbody>');
        for (let i = 0; i < records.length; i++) {
          const record = records[i];
          htmlParts.push('<tr>');
          headerKeys.forEach(key => {
            const cell = record.getElementsByTagName(key)[0];
            const value = cell ? cell.textContent : 'N/A';
            htmlParts.push(`<td>${value}</td>`);
          });
          htmlParts.push('</tr>');
        }
        htmlParts.push('</tbody></table>');
        return htmlParts.join('');
      };
    });
  </script>
</body>
</html>
