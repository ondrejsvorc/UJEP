<?php
include 'includes/layout.php';
include 'includes/db.php';
include 'includes/functions.php';

$id = isset($_GET['id']) ? (int) $_GET['id'] : 0;
if ($id <= 0) {
  echo start_page();
  echo "<p>❌ Invalid book ID.</p>";
  echo end_page();
  exit;
}

$readingList = loadReadingList();
$stmt = $db->prepare("
  SELECT
    Book.title,
    Author.name AS author,
    Genre.name AS genre,
    Book.year
  FROM Book
  JOIN Author ON Book.author_id = Author.id
  LEFT JOIN Genre ON Book.genre_id = Genre.id
  WHERE Book.id = ?
");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
  echo start_page();
  echo "<p>❌ Book not found.</p>";
  echo end_page();
  exit;
}

$book = $result->fetch_assoc();
$status = $readingList[$id]['status'] ?? '';
$rating = $readingList[$id]['rating'] ?? 0;
$note = $readingList[$id]['note'] ?? '';
?>

<?= start_page() ?>
<h2>
  <?= htmlspecialchars($book['title']) ?>
  <a href="edit.php?id=<?= $id ?>" class="edit-book-redirect">✏️ Edit</a>
</h2>
<ul>
  <li><strong>Author:</strong> <?= htmlspecialchars($book['author']) ?></li>
  <li><strong>Genre:</strong> <?= htmlspecialchars($book['genre'] ?? '—') ?></li>
  <li><strong>Year:</strong> <?= htmlspecialchars($book['year']) ?></li>
  <li><strong>Status:</strong> <?= htmlspecialchars($status) ?></li>
  <li><strong>Rating:</strong> <?= htmlspecialchars($rating) ?>/5</li>
  <li><strong>Note:</strong> <?= nl2br(htmlspecialchars($note)) ?></li>
</ul>
<a href="list.php">← Back to books</a>
<?= end_page() ?>