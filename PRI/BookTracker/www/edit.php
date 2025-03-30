<?php
include 'includes/layout.php';
include 'includes/db.php';
include 'includes/functions.php';
include 'includes/constants.php';

$id = isset($_GET['id']) ? (int) $_GET['id'] : 0;
if ($id <= 0) {
  echo start_page();
  echo "<p>❌ Invalid book ID.</p><p><a href='list.php'>← Back</a></p>";
  echo end_page();
  exit;
}

$readingList = loadReadingList();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $readingList[$id] = $_POST['status'];
  saveReadingList($readingList);
  header("Location: detail.php?id=$id");
  exit;
}

$stmt = $db->prepare("SELECT Book.title FROM Book WHERE Book.id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
  echo start_page();
  echo "<p>❌ Book not found.</p><p><a href='list.php'>← Back</a></p>";
  echo end_page();
  exit;
}

$book = $result->fetch_assoc();
$currentStatus = $readingList[$id] ?? '';
?>

<?= start_page() ?>
<h2>Edit Book Status</h2>
<p><strong><?= htmlspecialchars($book['title']) ?></strong></p>
<form method="POST" style="display: flex; flex-direction: column; gap: 10px; max-width: 300px;">
  <label>Status:
    <select name="status">
      <option value="">—</option>
      <option value="read" <?= $currentStatus === 'read' ? 'selected' : '' ?>>Read</option>
      <option value="currently reading" <?= $currentStatus === 'currently reading' ? 'selected' : '' ?>>Currently Reading</option>
      <option value="want to read" <?= $currentStatus === 'want to read' ? 'selected' : '' ?>>Want to Read</option>
    </select>
  </label>
  <button type="submit">💾 Save</button>
</form>
<p><a href="detail.php?id=<?= $id ?>">← Back to book</a></p>
<?= end_page() ?>