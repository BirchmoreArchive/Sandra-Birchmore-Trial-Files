# Day 17 — Source audit and editorial QA

**Status: integrity checks PASS for the supplied canonical file; editorial draft staged; publication HOLD.**

## Relevance review revision

The current editorial draft retains **217 posts** after **13 clearly unrelated posts** were excluded on full captured text and nested-context review. All **195 selected-thread posts** remain. See `relevance-review.md` for full excluded text, individual reasons, translations by meaning, and uncertain items retained conservatively; `relevance-decisions.csv` accounts for all 230 records. Original P-numbers remain stable with intentional gaps. `relevance-checks.json` verifies the filtered draft's count, order, retained bodies and nested text, with zero failures and the unchanged canonical hash.

The 230-post checks below and `integrity-checks.json` describe the unabridged baseline, now retained as `Day-17_2026-11-03_full-capture-reference.md`. `provenance.csv` likewise remains the complete 230-record source map. No record was removed from source or provenance. The current editorial draft is the relevance-reviewed version, not the full-capture reference.

This audit concerns the uploaded capture, not independent verification of the trial, the reporting, or the underlying legal/scientific claims. No website or publication was changed.

## Inputs and scope

The referenced chat supplied two accessible attachments: `GrantSmithEllis_2026-11-03_manifest(2).json` and `GrantSmithEllis_2026-11-03_canonical(2).jsonl`. Byte-preserving copies are retained under `source/`. The manifest is metadata plus 211 candidate post texts; JSONL is the declared authoritative corpus. All 230 top-level post texts and the captured nested quote/repost texts were inspected. Media metadata and source structure were inspected; remote media, link destinations, and courtroom exhibits were not opened.

The workspace was empty when production began. No prior-day draft, staging instructions, AGENTS.md, or archive template was available here. The recovered conversation establishes Markdown-first production, source audit, faithful reconstruction, editorial review, and publication as a separate step. This folder follows those recovered requirements; exact conformity to an unavailable historical filename/layout convention is not certified.

## Verified integrity

- Canonical size: **1,259,449 bytes**, matching manifest.
- Canonical SHA-256: **2e06f8d410b030c2617116655d6bd273b5d16fce317c53ea6b2f9d87314bcf8b**, matching manifest.
- 230 parseable records, 230 distinct top-level IDs, all authored by GrantSmithEllis.
- 195 selected-ancestry records and 35 window-only records, matching declared counts; no ancestry-only records.
- Ancestry sequence 1–195 is contiguous. Every successive reply points to the preceding chain ID. Root `2117616281251979716` has no parent; terminal seed is `2117687815236718745`. Both match the manifest.
- All 211 manifest candidate texts match their canonical records exactly.
- Draft has 230 numbered chronological post entries. Captured top-level bodies are preserved, including typos, quotation problems, allegations, objections, qualifications, source uncertainty, and mixed commentary. Captured nested quote/repost text is added under its owning post with separate attribution; it is not counted as another top-level entry.
- Times are converted from UTC to America/New_York: captured range **05:42:15–15:51:41 EST**; selected trial chain **08:53:59–13:38:14 EST**, November 3, 2026. The declared search window is 05:00–18:00 EST. An empty portion of that window does not establish that no other posts existed.

Machine-readable results are in `integrity-checks.json`; per-post line references, URLs, parent IDs, retrieval buckets, UTC/EST times, entity data, nested source data and media metadata are in `provenance.csv`. Numeric IDs should be treated as text when importing CSV; use the JSONL as authority.

## Source limitations and editorial flags

| Source post(s) | Finding | Draft treatment / review need |
| --- | --- | --- |
| `2117616281251979716`; `2117677570259046594` | Opening forecasts “Two DNA experts”; later witness is reported as Angie Christensen, discussing forensic anthropology and hyoid evidence. | Keep opening forecast; do not silently relabel both witnesses as DNA experts. |
| `2117631898352824450`–`2117633065761861638` | Grant announces bathroom break at 09:56:02 and return at 10:00:41 EST. | Preserve both notices. The 4m39s interval is a reporting limitation, not evidence of a missing captured post or a complete account of intervening testimony. |
| `2117634350468768171`–`2117634833933291720` | Overflow exhibit-display outage; Grant describes making his own recreation. | Preserve limitation and recreation as Grant's work; do not represent recreation as an official exhibit. No restoration time inferred. |
| `2117657278354460902`–`2117660741377446217` | Break, intended return, delay, then resumed testimony reporting. | Do not reconstruct unreported intervening testimony. |
| `2117683738868113899`; `2117683772082860271` | Identical top-level jury-scheduling text under two distinct IDs; latter also quotes former. | Retain both with provenance. Distinct captured posts do not establish two separate courtroom statements. |
| `2117684472841633909`; `2117684560536256753` | Later post repeats scheduling text and adds Grant's interpretation of Farwell's decision whether to testify. | Retain both posts intact. The interpretation remains Grant's; it does not establish that Farwell will testify. |
| `2117624813594271884` | Same reported explanation contains 46 chromosomes and later 45. | Preserve; flag numerical inconsistency without choosing a correction. |
| `2117624428284502201`; `2117635517101588612` | “20 million to 5million … per millimeter”; “8%%”. | Preserve exact source; units and values require checking before any normalized edition. |
| `2117644850153525282`; `2117662064940613766` | William Farwell testing answer “Yea” versus later “To my knowledge … not tested.” | Preserve sequence; no harmonized conclusion. |
| `2117661721988850049` | Reported 90/5/3/2 percentages followed by “96 was Ms. Birchmore”. | Preserve inconsistency. No silent arithmetic or transcription repair. |
| `2117662878924767652` | Transition into government questioning is written “Recross.” | Editorial heading uses neutral “government questioning”; source word remains. |
| `2117644555537313868`; `2117674441928847683` | Grant explicitly summarizes STRmix and separately attributes an explanation of “advantageous inclusion” to Google. | Preserve as reporter-supplied explanations, not verbatim witness answers or validated scientific definitions. |
| `2117663309302264313`; `2117671529727103429` | Awkward/possibly erroneous sperm-fraction wording; Pickard names, exclusion/inclusion questions and missing dialogue context. | No speculative correction or speaker attribution. |
| `2117670859993403796`; `2117676842077298805`; `2117677462989717504` | Underwear packaging/custody answers evolve across questioning. | Preserve all exchanges in order; do not substitute an editorial custody finding. |
| `2117675029773058076` | “6.2 trillion times more likely … present than not” appears in reported questioning. | Retain as reported dialogue. Do not convert it into a probability of guilt or an independently verified statistical conclusion. |
| `2117681257446322514`; `2117682320819798255`; `2117682736291065946`; `2117683320427270174` | Field-specific qualification of “perimortem”; subsequent timing language, hanging questions, and lack of specific literature review. | Preserve qualifications and answers together; no editorial cause-of-death conclusion. |
| `2117680583879053639`; `2117680668507582782` | Witness's uncertain description of Dr. Smock's role followed by Grant's correction. | Preserve both in chronology; correction is attributed to Grant. |
| Preliminary slides; notice objections; `2117660899251011588` | Withdrawn slides, reserved rulings, sustained objections and struck material. | Preserve rulings with surrounding text. Do not present excluded/struck material as admitted evidence. |
| `2117684783824183577`–`2117687262762967262` | Motion rulings include qualifications and reservations; Rule 106/1006 wording is corrected within the exchange. | Keep complete sequence; no simplified blanket final disposition. |
| Window-only replies and allegations | Includes assertions about named people and other cases, off-topic reposts, promotional/support posts and a later stream notice. | Retain with attribution and retrieval label. They are captured posts, not editorial findings or courtroom testimony. |

Spelling variants (including Nourredine/Max/Maher, StarMix/STRmix, “swaps,” names, institutions and case citations) and unbalanced quotation marks remain as supplied. Anonymous alternating quotes have not been converted to invented Q/A or speaker labels. Existing `[unclear]` wording remains source text.

## Completeness boundary

The manifest's “PASS” and 100% ancestry coverage describe reconciliation within the acquired source pack. The matching canonical hash and continuous parent chain support that claim for the supplied records. They do not establish a verbatim transcript, complete courtroom coverage, all X posts for the day, or the absence of deleted/omitted posts.

The manifest lists 11 other package members (CSV derivatives, reconciliation report, raw window and parent-chunk captures, README, recovery tables and ancestry files). Those files were not attached here, so their listed hashes, collection behavior, and raw-to-canonical reconciliation cannot be independently rechecked. The manifest itself has no supplied trusted external hash or signature. The local hashes provide reproducibility, not source authenticity certification.

## Publication gate

Mechanical integrity and body-preservation checks pass. Source/content review flags remain explicit. This is a reviewable staged draft, **not publication-approved**. The user's subsequent instruction authorizes excluding clearly irrelevant posts after full-text review; that review is documented above. Before publication, review the retained ambiguity table and uncertain relevance items, inspect media if the published edition will describe or embed it, and approve the final editorial version. Do not manufacture corrections to resolve unavailable evidence.
