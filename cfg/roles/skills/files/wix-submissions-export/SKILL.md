---
name: wix-submissions-export
description: >
  Exports all rows and columns from a Wix Forms submissions table to a CSV file,
  including columns (like Payment info / paymentStatus) that Wix's built-in export
  omits. Use this skill whenever the user wants to export, extract, download, or
  save Wix form submissions data — especially when they mention missing payment
  status, incomplete exports, or need all columns. Also trigger when the user
  shares a Wix manage.wix.com submissions URL and asks to get the data out.
---

# Wix Submissions Export

Wix's built-in CSV export omits certain columns, most notably payment status. This
skill extracts all submissions directly from the rendered DOM by scrolling the table
to load every row, then triggers a browser download of the complete CSV.

## Prerequisites

- The user must be logged into Wix in Chrome with the Claude extension active.
- The submissions page URL should include `selectedColumns=...` query params to
  control which columns appear (the user's URL already has these set).

## Step-by-step workflow

### 1. Navigate to the submissions page

Navigate to the Wix submissions URL the user provides. Wait for the page to fully
load (spinner gone, table rows visible).

### 2. Read column headers

```javascript
const headers = Array.from(document.querySelectorAll('thead th'))
  .map(th => th.innerText.trim());
```

Confirm the columns with the user if they aren't already known.

### 3. Find the scrollable table container

The table sits inside a div whose `scrollHeight` is much larger than its
`clientHeight`. Locate it with:

```javascript
let scrollContainer = null;
for (const div of document.querySelectorAll('div')) {
  if (div.scrollHeight > div.clientHeight + 100 &&
      div.querySelectorAll('tbody tr').length > 0) {
    scrollContainer = div;
    break;
  }
}
```

Store it as `window._scrollContainer`.

### 4. Scroll to load all rows

Wix renders rows in batches of ~100. Repeatedly scroll to the bottom of the
container until the DOM row count stops increasing. Each scroll triggers React to
append the next batch.

```javascript
// Reset to top first
window._scrollContainer.scrollTop = 0;

// Then repeatedly jump to bottom with a delay between each
window._scrollContainer.scrollTop = window._scrollContainer.scrollHeight;
// Wait ~2 seconds, check document.querySelectorAll('tbody tr').length
// Repeat until count stops growing or equals the total shown in the tab badge
```

The tab badge (e.g. "Submissions 261") tells you the expected total. Keep scrolling
until `document.querySelectorAll('tbody tr').length` matches it.

### 5. Extract all rows

Once all rows are in the DOM, extract in one pass using the row index (not
submission time) as the key — two submissions can share the same timestamp:

```javascript
window._allRows = [];
document.querySelectorAll('tbody tr').forEach(row => {
  const cells = row.querySelectorAll('td');
  if (cells.length < 5) return;
  window._allRows.push(
    Array.from(cells).map(td => td.innerText?.replace(/\n/g, ' | ').trim())
  );
});
```

### 6. Build the CSV

```javascript
function csvEscape(val) {
  if (!val) return '';
  const s = String(val).replace(/\r?\n/g, ' ').replace(/ \| /g, '; ');
  if (s.includes(',') || s.includes('"') || s.includes('\n')) {
    return '"' + s.replace(/"/g, '""') + '"';
  }
  return s;
}

// Strip checkbox column (index 0) and trailing blank columns
const usableHeaders = headers.filter((h, i) => i > 0 && h !== '');
const csvLines = [usableHeaders.map(csvEscape).join(',')];

window._allRows.forEach(row => {
  const data = row.slice(1, row.length - 2); // drop checkbox + trailing blanks
  csvLines.push(data.map(csvEscape).join(','));
});

window._csvData = csvLines.join('\n');
```

Verify line count equals (total rows + 1 for header).

### 7. Trigger the download

```javascript
const blob = new Blob([window._csvData], { type: 'text/csv;charset=utf-8;' });
const url = URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = url;
a.download = 'wix_submissions.csv';
document.body.appendChild(a);
a.click();
document.body.removeChild(a);
setTimeout(() => URL.revokeObjectURL(url), 5000);
```

Chrome will either auto-save to `~/Downloads` (if configured) or show a save dialog.

### 8. Copy to outputs folder

Once the file is in `~/Downloads`, mount that folder with `request_cowork_directory`
if needed and copy:

```bash
cp ~/Downloads/wix_submissions.csv /path/to/outputs/wix_submissions.csv
```

Then present the file to the user with `present_files`.

## Notes and edge cases

- **Duplicate timestamps**: Two registrations can arrive at the same second. Always
  use row index, not timestamp, as the deduplication key.
- **Column count**: The raw `thead th` list includes a leading checkbox column and
  1–2 trailing blank action columns. Slice them off (`slice(1, length - 2)`) when
  building the CSV to keep headers and data aligned.
- **Trailing relative dates**: Each submission-time cell contains two lines —
  the absolute date and a relative one (e.g. "9 days ago"). The `replace(/\n/g, ' | ')`
  in the extraction step captures both; you may want to strip the relative part.
- **Batch size**: Wix loads 100 rows per scroll. For 261 rows you need 3 scrolls
  to bottom (100 → 200 → 261). Always verify `tbody tr` count matches the badge.
- **Mixed content**: The browser blocks HTTP requests from an HTTPS page, so
  techniques like POSTing to a localhost server won't work. Use the Blob download
  approach instead.
- **No virtual DOM recycling**: Unlike some virtualized lists, Wix keeps previously
  loaded rows in the DOM. Once a batch loads it stays — you don't need to scrape
  while scrolling.
