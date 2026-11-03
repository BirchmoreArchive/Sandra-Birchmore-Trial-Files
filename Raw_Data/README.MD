# Sandra Birchmore Trial — X Source Packet

This packet contains archival source data collected from public X/Twitter reporting related to the federal trial of **Matthew Farwell in connection with the death of Sandra Birchmore**.

It is intended primarily for **archivists, researchers, journalists, and others who want access to the underlying reporting data without having to reproduce the extraction work from scratch**.

## Quick Start

If you simply want the usable source material:

1. Open the folder for the date you need.
2. Use the **canonical JSONL** as the archival/master dataset.
3. Use the **canonical CSV** if you want an easier human-readable or spreadsheet-compatible version.
4. Read that day's **manifest** for collection method, counts, validation information, and any known limitations.
5. Treat the contents of all canonical buckets together as the recovered source universe unless the manifest states otherwise.

You do **not** need to rerun the original X queries in order to use these records.

---

## Recommended File Hierarchy

Each completed day should contain some or all of the following:

```text
YYYY-MM-DD/
├── canonical.jsonl
├── canonical.csv
├── manifest.json
├── recovery/
│   ├── both.csv
│   ├── spine_only.csv
│   └── query_only.csv
└── media/
```

Some dates may contain additional provenance, manual-recovery, or validation files.

### `canonical.jsonl`

The preservation/master copy of the recovered records.

Use this when:

- preserving the dataset;
- reproducing analysis;
- programmatically processing posts;
- checking exact source fields;
- comparing archival versions.

### `canonical.csv`

A human-accessible derivative of the canonical JSONL.

It is useful for:

- spreadsheets;
- filtering;
- reviewing chronology;
- searching text;
- importing into database or research tools.

**Important:** X status IDs, conversation IDs, reply IDs, and similar identifiers are identifiers, not numbers. They should be treated as strings. Spreadsheet software may otherwise silently alter long IDs through numeric precision loss.

### `manifest.json`

The manifest documents how that day's archive was constructed.

Depending on the collection version, it may contain:

- wrapper/tool version;
- query window;
- account searched;
- terminal-status selection;
- reconstructed thread root;
- record counts;
- ancestry-chain counts;
- query-only counts;
- chunk/retrieval provenance;
- hashes;
- validation results;
- known problems or exceptions.

**Read the manifest before making claims about completeness.**

---

# How the Archive Was Reconstructed

## Important limitation of historical X search

Historical X `SearchTimeline` results proved unreliable as a completeness mechanism.

Identical or nearly identical searches could return:

- overlapping but incomplete result sets;
- different records on repeated runs;
- only a fraction of an existing thread;
- missing replies even when later replies clearly referenced them.

A repeated query returning the same results therefore means only that the query has locally stabilized. It does **not** establish that the historical record is complete.

For that reason, historical search results should be treated as **discovery evidence**, not the sole structural basis of the archive.

---

## Parent-chain reconstruction

Where possible, the archive instead reconstructs Grant Smith Ellis's courtroom reporting using the reply/thread structure itself.

The basic method is:

```text
identify terminal courtroom post
        ↓
walk reply-to / parent ancestry backward
        ↓
identify thread root
        ↓
construct contiguous courtroom-reporting spine
        ↓
compare against historical SearchTimeline results
        ↓
add valid query-only records
        ↓
deduplicate and preserve provenance
```

This produces three useful recovery categories.

### `both`

Records found in both:

- the reconstructed ancestry/thread spine; and
- the historical search query.

### `spine_only`

Records recovered through the reply ancestry that the historical query failed to return.

These records are particularly important because they demonstrate why historical SearchTimeline alone cannot safely be treated as a complete archive.

### `query_only`

Records found by the time-bounded search but not belonging to the selected courtroom ancestry.

These can include:

- standalone commentary;
- independent posts;
- quote posts;
- retweets;
- posts made outside the principal courtroom thread.

### Complete recovered universe

Unless a day's manifest says otherwise:

```text
both + spine_only + query_only
```

represents the day's canonical recovered X dataset.

Do **not** use `both.csv` alone as the full archive.

---

# Preservation Philosophy

The archive distinguishes between:

1. **what X returned;**
2. **what was recovered through structural reconstruction;**
3. **what was normalized for practical use;**
4. **what was manually recovered from other surviving primary evidence.**

These distinctions are intentional.

Original source records should not be silently rewritten to make later recovery work appear to have been part of the original extraction.

Where normalization is necessary—for example, reversible character-encoding corruption—the archival source and the normalized derivative should remain distinguishable.

The goal is not to preserve every experimental extraction attempt forever.

The goal is to preserve enough source data and provenance that another researcher can understand:

- what survived;
- where it came from;
- how records were merged;
- what was excluded as redundant;
- what recovery steps were required;
- what remains uncertain.

---

# Deduplication

A duplicate status ID does not automatically mean duplicate archival value.

Different extractions of the same post may contain different metadata, especially:

- media references;
- nested quoted-post information;
- source URLs;
- author/profile metadata;
- reply relationships.

For that reason, redundant pulls were compared before being discarded.

The canonical dataset is organized by unique X status ID while retaining useful provenance and richer metadata where available.

---

# Manual Recoveries

Occasionally a post may be independently confirmed even though it is missing from surviving machine pulls.

Examples of confirmation can include:

- a surviving direct X URL;
- screenshots;
- a later tweet whose `reply_to` field identifies the missing status;
- contemporaneous archival material.

Such records should be explicitly labeled as **manual recoveries or sidecar records**.

They should not be silently inserted into an original extraction file as though the extractor returned them.

---

# Media

Media archival work is separate from the tweet-record reconstruction.

Where media has been recovered, filenames should be deterministic and traceable to the originating status, for example:

```text
2110713997108425076_01.jpg
2110713997108425076_02.jpg
```

A media manifest may map:

```text
tweet ID
→ original/source media URL
→ archived filename
→ recovery status
→ MIME/type
→ hash
```

Possible recovery statuses may include:

- recovered;
- externally linked;
- unavailable;
- not attempted.

Absence of an archived image or video does not necessarily mean the original post contained no media. Consult the record and media manifest.

---

# Validation

A historical search returning many records is not, by itself, evidence of completeness.

Stronger validation indicators include:

- a continuous parent/reply ancestry;
- a confirmed thread root;
- a confirmed terminal post;
- parent traversal terminating normally;
- no unresolved ancestry gaps;
- successful comparison against earlier independent pulls;
- manifest validation reporting no structural problems.

For mature trial days, the reconstructed wrapper dataset has sometimes recovered records that were absent even from earlier apparently complete full-day pulls.

Accordingly, **the manifest and structural validation should control over assumptions based solely on query size.**

---

# Dates and Time Zones

X timestamps are normally stored in UTC.

Trial chronology should be interpreted using the relevant **Eastern Time** local date and time.

Do not infer the courtroom date solely from the UTC calendar date if a post falls near midnight.

Time-bounded extraction windows may also be recorded as Unix epoch timestamps in the manifest.

---

# Retweets, Replies, and Commentary

The canonical dataset may contain more than the courtroom transcript-style thread.

Depending on the day's collection, it may also contain:

- replies;
- quote posts;
- standalone observations;
- retweets;
- supplemental commentary.

These records are preserved because they form part of the public source environment.

Researchers attempting to reconstruct only courtroom testimony should therefore filter by record type, ancestry membership, chronology, and context rather than assuming every canonical record is transcript content.

---

# Source vs. Transcript

These files are **source material**, not an official court transcript.

Grant Smith Ellis's posts are contemporaneous journalistic reporting from the courtroom.

Any transcript-like documents produced elsewhere in the Sandra Birchmore Trial Archive are reconstructions based on that reporting and other available source material.

They should not be represented as certified or official transcripts.

---

# Completeness

No representation is made that every public X post, deleted post, unavailable media item, or platform-side record has necessarily survived.

The archive instead attempts to document the **best recoverable source universe supported by the surviving evidence**.

Known gaps should be preserved as known gaps rather than filled through inference.

If two pieces of evidence conflict, preserve the conflict until it can be resolved.

---

# Reusing This Material

Researchers are encouraged to:

- retain status IDs;
- retain original URLs;
- preserve manifests with derivative datasets;
- distinguish source records from editorial reconstruction;
- document transformations;
- retain hashes where supplied;
- cite the original reporter when using substantive reporting;
- identify this archive as an archival reconstruction rather than an official X export.

If creating a derivative dataset, it is helpful to record:

```text
source packet/version
date(s) used
files used
filters applied
normalization performed
records removed
records added manually
date derivative was created
```

That small amount of provenance dramatically improves later reproducibility.

---

# If You Want to Re-run the Collection

The packet is intentionally designed so most users should **not need to** reproduce the X extraction.

For researchers who do attempt independent recovery:

- historical SearchTimeline should not be assumed complete;
- repeated identical search results do not prove completeness;
- reconstructing known courtroom threads through parent ancestry is substantially more reliable;
- query results should then be unioned with the reconstructed thread;
- deduplicate by status ID
