<?php
include 'includes/layout.php';
include 'includes/db.php';
include 'includes/functions.php';

function highlight(string $text, string $search): string {
  if (!$search) return htmlspecialchars($text);
  return preg_replace(
    '/' . preg_quote($search, '/') . '/i',
    '<mark>$0</mark>',
    htmlspecialchars($text)
  );
}

$search = $_GET['search'] ?? '';
$filterStatuses = array_filter([
  'read' => isset($_GET['read']),
  'currently reading' => isset($_GET['currently_reading']),
  'want to read' => isset($_GET['want_to_read'])
]);

$readingList = loadReadingList();
$query = "
  SELECT
    Book.id,
    Book.title,
    Author.name AS author,
    Genre.name AS genre,
    Book.year
  FROM Book
  JOIN Author ON Book.author_id = Author.id
  LEFT JOIN Genre ON Book.genre_id = Genre.id
  ORDER BY Book.title
";
$result = $db->query($query);
?>

<?php if (isset($_GET['import'])): ?>
  <p id="import-message">
    <?php
    echo match ($_GET['import']) {
      'success' => "✅ XML imported successfully!",
      'invalid' => "❌ Only XML files are allowed.",
      'invalid_structure' => "❌ Invalid XML structure.",
      'fail' => "❌ Failed to save the file.",
      default => "❌ Import failed."
    };
    ?>
  </p>
  <script>
    const timeoutInMs = 2000;
    setTimeout(() => {
      const msg = document.getElementById('import-message');
      if (msg) msg.remove();
    }, timeoutInMs);
  </script>
<?php endif; ?>

<?= start_page() ?>
<h2 onclick="window.location.href = 'index.php'" style="cursor: pointer;">Books</h2>

<form action="import.php" method="POST" enctype="multipart/form-data" class="import-form">
  <button type="button" onclick="document.getElementById('xmlFile').click()">📂 Import...</button>
  <input type="file" name="xml" id="xmlFile" accept=".xml" style="display: none;" onchange="this.form.submit()">
  <a href="export.php"><button type="button">📤 Export</button></a>
</form>

<form method="GET" class="filter-form">
  <input type="text" name="search" value="<?= htmlspecialchars($search) ?>" placeholder="Search books...">
  <label><input type="checkbox" name="read" <?= isset($_GET['read']) ? 'checked' : '' ?>> Read</label>
  <label><input type="checkbox" name="currently_reading" <?= isset($_GET['currently_reading']) ? 'checked' : '' ?>> Currently Reading</label>
  <label><input type="checkbox" name="want_to_read" <?= isset($_GET['want_to_read']) ? 'checked' : '' ?>> Want to Read</label>
  <button type="submit">Filter</button>
</form>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>Author</th>
      <th>Genre</th>
      <th>Year</th>
      <th>Status</th>
      <th>Rating</th>
    </tr>
  </thead>
  <tbody>
    <?php while ($row = $result->fetch_assoc()):
      $bookId = $row['id'];
      $entry = $readingList[$bookId] ?? ['status' => '—', 'rating' => '—'];
      $combined = strtolower(
        $row['title'] .
        $row['author'] .
        $row['genre'] .
        $row['year'] .
        $entry['status'] .
        $entry['rating']
      );
      if ($search && !str_contains($combined, strtolower($search))) {
        continue;
      }
      if ($filterStatuses && (!$entry['status'] || !isset($filterStatuses[$entry['status']]))) {
        continue;
      }
    ?>
    <tr onclick="window.location.href = 'detail.php?id=<?= $bookId ?>'">
      <td><?= highlight($row['title'], $search) ?></td>
      <td><?= highlight($row['author'], $search) ?></td>
      <td><?= highlight($row['genre'], $search) ?></td>
      <td><?= highlight($row['year'], $search) ?></td>
      <td><?= highlight($entry['status'] ?: '—', $search) ?></td>
      <td><?= highlight($entry['rating'] ?? '—', $search) ?></td>
    </tr>
    <?php endwhile; ?>
  </tbody>
</table>
<?= end_page() ?>
