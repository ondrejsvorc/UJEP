<?php
include 'includes/layout.php';
include 'includes/db.php';
include 'includes/functions.php';
include 'includes/constants.php';

$id = isset($_GET['id']) ? (int) $_GET['id'] : 0;
if ($id <= 0) {
  echo start_page();
  echo "<p>❌ Invalid book ID.</p><p><a href='#' onclick='history.back(); return false;'>← Back</a></p>";
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
  echo "<p>❌ Book not found.</p><p><a href='#' onclick='history.back(); return false;'>← Back</a></p>";
  echo end_page();
  exit;
}

$book = $result->fetch_assoc();
?>

<?= start_page() ?>
<h2>Edit Book</h2>
<p><strong><?= htmlspecialchars($book['title']) ?></strong></p>

<form method="POST" style="display: flex; flex-direction: column; gap: 10px; max-width: 300px;">
  <label>Status:
    <select name="status">
      <option value="">—</option>
      <option value="read" <?= $current['status'] === 'read' ? 'selected' : '' ?>>Read</option>
      <option value="currently reading" <?= $current['status'] === 'currently reading' ? 'selected' : '' ?>>Currently Reading</option>
      <option value="want to read" <?= $current['status'] === 'want to read' ? 'selected' : '' ?>>Want to Read</option>
    </select>
  </label>

  <label><strong>Rating:</strong></label>
  <div class="stars" id="stars"></div>
  <input type="hidden" name="rating" id="rating" value="<?= htmlspecialchars($current['rating']) ?>">

  <label for="note"><strong>Note:</strong></label>
  <textarea name="note" id="note" rows="4"><?= htmlspecialchars($current['note']) ?></textarea>

  <button type="submit">💾 Save</button>
</form>

<p><a href="#" onclick="history.back(); return false;">← Back</a></p>
<?= end_page() ?>

<script>
  const starsEl = document.getElementById('stars');
  const ratingInput = document.getElementById('rating');
  let isMouseDown = false;

  const renderStars = (value) => {
    starsEl.innerHTML = '';
    for (let i = 0; i < 5; i++) {
      const full = i + 1;
      const half = i + 0.5;
      let char = '☆';
      if (value >= full) char = '★';
      else if (value >= half) char = '⯪';

      const span = document.createElement('span');
      span.className = 'star';
      span.textContent = char;

      span.addEventListener('mousemove', (e) => {
        if (isMouseDown) {
          const isHalf = e.offsetX < e.target.offsetWidth / 2;
          const val = isHalf ? half : full;
          ratingInput.value = val;
          renderStars(val);
        }
      });

      span.addEventListener('click', (e) => {
        const isHalf = e.offsetX < e.target.offsetWidth / 2;
        const val = isHalf ? half : full;
        ratingInput.value = (parseFloat(ratingInput.value) === val) ? 0 : val;
        renderStars(parseFloat(ratingInput.value));
      });

      starsEl.appendChild(span);
    }
  };

  starsEl.addEventListener('mousedown', () => isMouseDown = true);
  document.addEventListener('mouseup', () => isMouseDown = false);

  renderStars(parseFloat(ratingInput.value) || 0);
</script>
