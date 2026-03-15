---
name: anki-chinese
description: >
  Generates Anki flashcard import files from Chinese vocabulary lists. Use this skill
  whenever the user provides a list of Chinese characters/words and wants to create
  flashcards, an Anki deck, or an Anki-compatible import file. Also trigger when the
  user uploads a .txt or similar file containing Chinese vocabulary and mentions Anki,
  flashcards, studying, or spaced repetition. The output is a tab-separated .txt file
  ready to import directly into Anki.
---

# Anki Chinese Flashcard Generator

Converts a list of Chinese vocabulary words into a tab-separated Anki import file
with Chinese characters, English translation, and pinyin (tone marks by default).

## Output Format

The output file must begin with these exact three header lines:

```
#separator:tab
#html:true
#tags column:4
```

Each vocabulary entry is one line with four tab-separated columns:

```
<Chinese>	<English>	<Pinyin>	<tags>
```

- Column 1: Chinese word/phrase as-is from the input
- Column 2: English translation (concise, accurate)
- Column 3: Pinyin with tone diacritics (e.g. `pǔtōnghuà`, not `pu3tong1hua4`)
- Column 4: Tags — leave blank unless the user specifies tags

The line must end with a trailing tab (even when tags are blank), matching the format:
`词语\tenglish\tpīnyīn\t`

## Special Cases

**Measure words (量词)**: Note the grammatical role in the translation.
Example: `艘	(measure word for boats/ships)	sōu	`

**Placeholder phrases**: Preserve the `。。。` or `...` placeholder in both the Chinese and English columns.
Example: `为。。。发愁	to worry about...	wèi...fāchóu	`

**Chengyu / four-character idioms**: Give a natural English equivalent rather than a literal translation when one exists.

**Proper nouns / names**: Translate or transliterate as appropriate, noting the category (e.g., "place name", "given name").

## Pinyin Guidelines

- Always use tone diacritics (ā á ǎ à, ē é ě è, etc.), not tone numbers
- Neutral tone syllables have no mark (e.g., `māma`)
- Use standard Mandarin (Putonghua) pronunciation
- For multi-syllable words, write pinyin as one unspaced unit per word if it is a single lexical item (e.g., `pǔtōnghuà`), or spaced if it is a phrase (e.g., `bǎkòng shíjiān`)

## Workflow

1. Read the input — either a plain list of Chinese words (one per line) or an uploaded file
2. For each word, determine: English translation, pinyin
3. Apply special-case handling where needed (measure words, placeholders, etc.)
4. Output the complete file with headers followed by one entry per line
5. Save as a `.txt` file and present it to the user for download

## Example Input / Output

Input list:
```
禁止
艘
为。。。发愁
```

Output file:
```
#separator:tab
#html:true
#tags column:4
禁止	to prohibit / forbidden	jìnzhǐ	
艘	(measure word for boats/ships)	sōu	
为。。。发愁	to worry about...	wèi...fāchóu	
```

## Notes

- If the user specifies numbered pinyin instead of tone marks, use that format throughout
- If the user wants tags added (e.g., a chapter name or topic), add them to column 4 for all entries or selectively as instructed
- Do not add entries that were not in the original list
- Do not reorder entries — preserve the original order
