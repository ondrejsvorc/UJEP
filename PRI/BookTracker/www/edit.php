<?php
include 'includes/layout.php';
include 'includes/db.php';
include 'includes/functions.php';
include 'includes/constants.php';

$id = isset($_GET['id']) ? (int) $_GET['id'] : 0;
if ($id <= 0) {
  echo start_page();
  echo "<p>❌ Invalid book ID.</p><p><a href='detail.php?id=<?= $id ?>'>← Back to book</a></p>";
  echo end_page();
  exit;
}

$readingList = loadReadingList();
$current = $readingList[$id] ?? ['status' => '', 'rating' => 0, 'note' => ''];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $readingList[$id] = [
    'status' => $_POST['status'],
    'rating' => $_POST['rating'],
    'note' => $_POST['note']
  ];
  saveReadingList($readingList);
  header("Location: detail.php?id=$id");
  exit;
}

$stmt = $db->prepare("SELECT title FROM Book WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
  echo start_page();
  echo "<p>❌ Book not found.</p><p><a href='detail.php?id=<?= $id ?>'>← Back to book</a></p>";
  echo end_page();
  exit;
}
$book = $result->fetch_assoc();
?>

<?= start_page() ?>
<h2>Edit Book</h2>
<p><strong><?= htmlspecialchars($book['title']) ?></strong></p>
<form method="POST" class="edit-form">
  <label>Status:
    <select name="status">
      <option value="">—</option>
      <option value="read" <?= $current['status'] === 'read' ? 'selected' : '' ?>>read</option>
      <option value="currently reading" <?= $current['status'] === 'currently reading' ? 'selected' : '' ?>>currently reading</option>
      <option value="want to read" <?= $current['status'] === 'want to read' ? 'selected' : '' ?>>want to read</option>
    </select>
  </label>
  <label><strong>Rating:</strong></label>
  <div class="stars" id="stars"></div>
  <input type="hidden" name="rating" id="rating" value="<?= htmlspecialchars($current['rating']) ?>">
  <label for="note"><strong>Note:</strong></label>
  <textarea name="note" id="note" rows="4"><?= htmlspecialchars($current['note']) ?></textarea>
  <button type="submit">💾 Save</button>
</form>
<p><a href="detail.php?id=<?= $id ?>">← Back to book</a></p>
<?= end_page() ?>

<script>
  const stars = document.getElementById('stars');
  const input = document.getElementById('rating');
  let isRating = false;

  const getRating = (e, full, half) => {
    const mousePositionX = e.offsetX;
    const starWidth = e.target.offsetWidth;
    const isLeftHalf = mousePositionX < starWidth / 2;
    return isLeftHalf ? half : full;
  };
  const updateRating = (value) => {
    input.value = value;
    render(parseFloat(value));
  };

  const render = (value) => {
    stars.innerHTML = '';
    for (let i = 0; i < 5; i++) {
      const full = i + 1;
      const half = i + 0.5;
      const char = value >= full ? '★' : value >= half ? '⯪' : '☆';
      const star = document.createElement('span');
      star.className = 'star';
      star.textContent = char;
      star.onclick = (e) => {
        const rating = getRating(e, full, half);
        updateRating(input.value == getRating(e, full, half) ? 0 : rating);
      };
      star.onmousemove = (e) => isRating && updateRating(getRating(e, full, half));
      stars.appendChild(star);
    }
  };

  stars.onmousedown = () => isRating = true;
  document.onmouseup = () => isRating = false;

  render(parseFloat(input.value) || 0);
</script>
