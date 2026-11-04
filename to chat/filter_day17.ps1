$ErrorActionPreference='Stop'
$base=Join-Path $PSScriptRoot 'day-17_2026-11-03'
$draftPath=Join-Path $base 'Day-17_2026-11-03_editorial-draft.md'
$baseline=Join-Path $base 'Day-17_2026-11-03_full-capture-reference.md'
if(!(Test-Path -LiteralPath $baseline)){Copy-Item -LiteralPath $draftPath -Destination $baseline}
$records=@(Get-Content -LiteralPath (Join-Path $base 'source/GrantSmithEllis_2026-11-03_canonical(2).jsonl')|ForEach-Object {$_|ConvertFrom-Json})
$exclude=[ordered]@{
 '2117568029349548449'='Full nested repost concerns claimed UAV destruction over Bandar Khamir, Iran; no Birchmore, trial, or surrounding local-case connection in the text.'
 '2117568131808079927'='Full nested repost concerns returning fighter jets and a presumed operation; no trial or local-case reference. The complete short text was reviewed, not just the repost preview.'
 '2117568377141317763'='Full nested repost concerns Israeli warplanes targeting Kfar Tebnit in southern Lebanon; no trial connection in the text.'
 '2117589157383921971'='Full Arabic nested repost reports foreign media reserving rooftops overlooking the southern suburbs, anticipating an unsettling phase. The whole text concerns regional conflict coverage, with no Birchmore or trial connection.'
 '2117589216016384364'='The otherwise ambiguous reaction “That''s bad.” quotes the same complete Arabic rooftop/media report. Excluded only after reading that quoted context.'
 '2117591631138337122'='Full Arabic nested repost disputes rumors about 30–40 foreign reporters renting Lebanese apartments/rooftops and Iranian nuclear-attack instructions, warns about alarmist WhatsApp groups, and ends with a pineapple-pizza joke. All lines were reviewed; none concerns this archive.'
 '2117606009740972325'='Full Arabic nested repost describes aerial clashes between the IRGC and US military in the Strait of Hormuz; no trial connection in the text.'
 '2117607791548412261'='Full nested repost is UKMTO maritime-security warning 194-26 with a link to the warning; its entire caption concerns maritime security, not the trial.'
 '2117607840714002884'='The reaction “That sounds bad.” quotes the complete UKMTO maritime-warning caption. Excluded only after reading the quoted context.'
 '2117653347742142816'='Full nested court-report notice lists Malden v. Supervisor of Public Records and Commonwealth v. Ramos. No Birchmore, Farwell, or surrounding trial-reporting connection appears in its complete text.'
 '2117691555628859741'='Complete nested repost says “Bomb Shelters Opened in Israel”; no trial connection.'
 '2117702336248266757'='Full nested repost concerns anti-aircraft activity in the Ramshir–Omidiyeh area of Khuzestan, Iran, plus a delayed-post notice; no trial connection.'
 '2117721397757628441'='Full Hebrew nested repost objects to censorship demands about aircraft movements already broadcast on Flightradar or tracking apps, saying there are enough other things to argue about. The complete text concerns aircraft-tracking censorship, not the trial.'
}
$all=[IO.File]::ReadAllText($baseline)
$parts=[regex]::Split($all,'(?m)(?=^### P\d{3} · )')
$intro=$parts[0].Replace('All 230 captured posts are included to avoid silent omissions.','Relevance-reviewed edition: 217 of 230 captured posts are included; 13 clearly unrelated posts are excluded after review of their complete captured text and nested quote/repost context. Original P-numbers are retained, so gaps are intentional. See relevance-review.md for every decision and the full-capture reference for the unabridged chronology.').Replace('including off-topic reposts, related commentary, and overlapping trial reports','including related commentary, overlapping trial reports, and uncertain items retained conservatively')
$out=[Text.StringBuilder]::new($intro)
$ledger=[Text.StringBuilder]::new(@'
# Day 17 — Relevance review

**13 excluded; 217 retained. Not published.**

Every exclusion below follows review of the complete captured top-level text and, where present, full nested quote/repost text. Arabic and Hebrew text was reviewed for meaning; English topic summaries below are editorial paraphrases, not replacement source text. Language itself is not an exclusion criterion. Remote linked documents and media were not inspected; these decisions concern complete captured tweet text, not claims about unseen media. The unabridged reference and authoritative source files preserve every record.

## Conservative retention decisions

- The Juston Root repost is retained: its truncated preview hides explicit Sandra Birchmore and John Fanning discussion in the full nested text.
- “واضح انه الي جاي اسوء (:” roughly means “It is clear that what is coming is worse.” This short Arabic repost has no specific subject or nested context establishing what it concerns. Retained as uncertain, not excluded because it is Arabic.
- The link-only hey_itsmyturn repost is retained: neither its complete caption nor nested text identifies the video's subject. Account history alone is insufficient to exclude it.
- TheEmilySee's notes, “Home stretch,” and the KyleSharkey8 photo post are retained because their complete captions do not establish irrelevance; media would need review for a firmer decision.
- Penton and McNamara/Stoughton/Calter court-document reposts, Karen Read/Kearney appeal commentary, and the combined Birchmore livestream notice remain as potentially related surrounding-case context. No exclusion is inferred from a different case name alone.
- The entire 195-post selected trial chain remains intact, including mixed commentary, breaks, support messages, humor, and source limitations. Related window-only reactions and quoted testimony remain in chronology.

## Excluded posts — complete captured text and reasons
'@)
$review=@()
for($i=0;$i -lt $records.Count;$i++){
 $x=$records[$i];$p='P{0:D3}' -f ($i+1);$isExcluded=$exclude.Contains([string]$x.id)
 if(!$isExcluded){[void]$out.Append($parts[$i+1])}
 else{
  [void]$ledger.AppendLine("`n### $p · [Source $($x.id)]($($x.url))`n`nDecision: exclude from editorial draft.`n`nReason: $($exclude[[string]$x.id])`n`nComplete captured top-level text:`n")
  foreach($line in ($x.text -split "`n",0,'SimpleMatch')){[void]$ledger.AppendLine('> '+$line)}
  foreach($key in @('quoted','retweeted')){if($x.$key){$c=$x.$key;[void]$ledger.AppendLine("`nComplete captured $key text · @$($c.author.username) · [source $($c.id)]($($c.url)):`n");foreach($line in ($c.text -split "`n",0,'SimpleMatch')){[void]$ledger.AppendLine('> '+$line)}}}
 }
 $review += [pscustomobject]@{draft_post=$p;id=[string]$x.id;decision=$(if($isExcluded){'exclude'}else{'retain'});reason=$(if($isExcluded){$exclude[[string]$x.id]}elseif($x._archive.in_selected_ancestry){'Selected trial thread; retained intact'}else{'Related or insufficient evidence of irrelevance; retain conservatively'})}
}
[IO.File]::WriteAllText($draftPath,$out.ToString(),[Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText((Join-Path $base 'relevance-review.md'),$ledger.ToString(),[Text.UTF8Encoding]::new($false))
$review|Export-Csv -LiteralPath (Join-Path $base 'relevance-decisions.csv') -NoTypeInformation -Encoding utf8
$filtered=[IO.File]::ReadAllText($draftPath)
$filteredBlocks=@([regex]::Split($filtered,'(?m)(?=^### P\d{3} · )')|Select-Object -Skip 1)
$fail=@();$kept=@($review|Where-Object decision -eq 'retain')
for($i=0;$i -lt $kept.Count;$i++){
 $x=$records|Where-Object id -eq $kept[$i].id
 $body=(($x.text -split "`n",0,'SimpleMatch'|ForEach-Object {'> '+$_}) -join [Environment]::NewLine)
 if(!$filteredBlocks[$i].StartsWith('### '+$kept[$i].draft_post+' · ') -or !$filteredBlocks[$i].Contains($body)){$fail+=$x.id}
 foreach($key in @('quoted','retweeted')){if($x.$key){$body=(($x.$key.text -split "`n",0,'SimpleMatch'|ForEach-Object {'> '+$_}) -join [Environment]::NewLine);if(!$filteredBlocks[$i].Contains($body)){$fail+=$x.$key.id}}}
}
$checks=[ordered]@{captured=230;retained=$kept.Count;excluded=$exclude.Count;draft_blocks=$filteredBlocks.Count;selected_chain_retained=@($records|Where-Object {$_. _archive.in_selected_ancestry -and !$exclude.Contains([string]$_.id)}).Count;body_or_order_failures=$fail;source_sha256=(Get-FileHash -LiteralPath (Join-Path $base 'source/GrantSmithEllis_2026-11-03_canonical(2).jsonl')).Hash.ToLowerInvariant()}
$checks|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $base 'relevance-checks.json') -Encoding utf8
if($fail.Count -gt 0 -or $kept.Count -ne 217 -or $filteredBlocks.Count -ne 217){throw 'Filtered draft QA failed'}
$checks|ConvertTo-Json -Depth 5
