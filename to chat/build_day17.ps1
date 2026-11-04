$ErrorActionPreference = 'Stop'
$base = Join-Path $PSScriptRoot 'day-17_2026-11-03'
$source = Join-Path $base 'source'
New-Item -ItemType Directory -Force -Path $source | Out-Null
$manifestPath = (Join-Path $source 'GrantSmithEllis_2026-11-03_manifest(2).json')
$canonicalPath = (Join-Path $source 'GrantSmithEllis_2026-11-03_canonical(2).jsonl')
$m = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$lines = @(Get-Content -LiteralPath $canonicalPath)
$r = @($lines | ForEach-Object { $_ | ConvertFrom-Json })
$byId = @{}
foreach ($x in $r) { if ($byId.ContainsKey([string]$x.id)) { throw 'Duplicate ID' }; $byId[[string]$x.id] = $x }
$chain = @($r | Where-Object { $_._archive.in_selected_ancestry } | Sort-Object { [int]$_._archive.ancestry_sequence })
$issues = [System.Collections.Generic.List[string]]::new()
for ($i=0; $i -lt $chain.Count; $i++) {
 if ([int]$chain[$i]._archive.ancestry_sequence -ne $i+1) { $issues.Add("Sequence error at $i") }
 if ($i -gt 0 -and [string]$chain[$i].reply_to -ne [string]$chain[$i-1].id) { $issues.Add("Parent mismatch at $($chain[$i].id)") }
}
$candidateDiffs = @($m.seed_candidates | Where-Object { !$byId.ContainsKey([string]$_.id) -or $_.text -cne $byId[[string]$_.id].text })
$expected = $m.files | Where-Object { $_.path -eq 'GrantSmithEllis_2026-11-03_canonical.jsonl' }
$actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $canonicalPath).Hash.ToLowerInvariant()
$tz = [TimeZoneInfo]::FindSystemTimeZoneById('Eastern Standard Time')
function UtcTime($value) { if($value -is [DateTime]) { return [DateTimeOffset]$value }; return [DateTimeOffset]::Parse([string]$value) }
function LocalTime($x) { [TimeZoneInfo]::ConvertTime((UtcTime $x.created_at), $tz).ToString('HH:mm:ss') }
$ordered = @($r | Sort-Object { UtcTime $_.created_at }, { [string]$_.id })
$draft = [System.Text.StringBuilder]::new()
[void]$draft.AppendLine(@'
# Sandra Birchmore archive — Day 17
## November 3, 2026 · Editorial draft · NOT PUBLISHED

Reconstructed from Grant Smith Ellis's captured X reporting. This is a chronological source-based editorial draft, not an official court transcript. Quotation marks, testimony, questions, objections, descriptions, humor, reactions, and commentary are Grant's reporting as captured; questions and allegations are not adopted as established facts. Unnamed speakers have not been assigned identities by the editor.

Post bodies are preserved without spelling, scientific, numerical, or quotation repairs. Each block is attributed to its source post; added headings and metadata are editorial. Times are post publication times in America/New_York (EST, UTC−05:00), not asserted courtroom event times. Links and media metadata are preserved in provenance; linked content and images have not been independently inspected.

All 230 captured posts are included to avoid silent omissions. “Selected trial thread” identifies the manifest's 195-post reply chain; “Window-only” identifies the other 35 posts, including off-topic reposts, related commentary, and overlapping trial reports. These labels describe retrieval structure, not whether a post contains testimony or commentary. Mixed content stays intact within each post.

### Editorial navigation

- 08:53:59 — Courthouse opening and preliminary matters.
- 09:09:24 — Defense calls Dr. Max/Maher Nourredine; qualifications, teaching slides, serology and DNA.
- 10:23:42 — Reporting turns to case samples and ligature analysis.
- 10:54:37 — Break, objections and jury-charge discussion.
- 11:50:39 — Resumed reporting; remaining direct examination.
- 12:00:51 — Government questioning (source transition says “Recross”; retained).
- 12:53:18 — Redirect and recross.
- 12:57:31 — Defense calls Angie Christensen; hyoid evidence.
- 13:22:02 — Jury released; scheduling, exhibits and motions.

See QA.md for source limitations and unresolved editorial flags. Publication remains on hold.

## Captured chronology
'@)
$provenance = @()
$phases = @{15='Courthouse opening and preliminary matters';20='Nourredine — qualifications and DNA background';84='Nourredine — case evidence';115='Break, objections and jury charge';133='Nourredine — resumed reporting';142='Nourredine — government questioning';181='Nourredine — redirect and recross';189='Christensen — hyoid evidence';210='Jury release and post-jury matters';222='Later captured posts'}
for($i=0;$i -lt $ordered.Count;$i++) {
 $x=$ordered[$i]; $n=$i+1; $clock=LocalTime $x
 if($phases.ContainsKey($i)){[void]$draft.AppendLine("`n## $($phases[$i])")}
 $label=if($x._archive.in_selected_ancestry){'Selected trial thread'}else{'Window-only'}
 $type=if($x.is_retweet){'repost'}elseif($x.is_quote){'quote post'}elseif($x.is_reply){'reply'}else{'post'}
 [void]$draft.AppendLine("`n### P$('{0:D3}' -f $n) · $clock EST`n`n[Source post $($x.id)]($($x.url)) · $label · $type`n")
 foreach($line in ($x.text -split "`n",0,'SimpleMatch')) { [void]$draft.AppendLine(('> '+$line)) }
 foreach($key in @('quoted','retweeted')) {
  if($x.$key){
   $context=$x.$key
   [void]$draft.AppendLine("`nCaptured $key context · @$($context.author.username) · [post $($context.id)]($($context.url)) (nested source; not an additional chronological entry):`n")
   foreach($line in ($context.text -split "`n",0,'SimpleMatch')){[void]$draft.AppendLine(('> '+$line))}
  }
 }
 [void]$draft.AppendLine()
 $provenance += [pscustomobject]@{draft_post=('P{0:D3}' -f $n);id=[string]$x.id;created_at_utc=((UtcTime $x.created_at).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'));time_est=$clock;url=$x.url;bucket=$x._archive.bucket;ancestry_sequence=$x._archive.ancestry_sequence;reply_to=[string]$x.reply_to;type=$type;canonical_line=($i+1);media=($x.media|ConvertTo-Json -Depth 30 -Compress);entities=($x.entities|ConvertTo-Json -Depth 30 -Compress);quoted=($x.quoted|ConvertTo-Json -Depth 30 -Compress);retweeted=($x.retweeted|ConvertTo-Json -Depth 30 -Compress)}
}
$draftPath=Join-Path $base 'Day-17_2026-11-03_editorial-draft.md'
[IO.File]::WriteAllText($draftPath,$draft.ToString(),[Text.UTF8Encoding]::new($false))
$provenance | Export-Csv -LiteralPath (Join-Path $base 'provenance.csv') -NoTypeInformation -Encoding utf8
$draftText=[IO.File]::ReadAllText($draftPath)
$bodyFailures=@()
foreach($x in $ordered){$quoted=(($x.text -split "`n",0,'SimpleMatch'|ForEach-Object {'> '+$_}) -join [Environment]::NewLine);if(!$draftText.Contains($quoted)){$bodyFailures += $x.id}}
$duplicates=@($r|Group-Object text|Where-Object Count -gt 1|ForEach-Object { [pscustomobject]@{ids=@($_.Group.id);count=$_.Count} })
$result=[ordered]@{canonical_count=$r.Count;unique_ids=$byId.Count;chain_count=$chain.Count;window_only=@($r|Where-Object {!$_. _archive.in_selected_ancestry}).Count;hash_expected=$expected.sha256;hash_actual=$actualHash;hash_match=($actualHash -eq $expected.sha256);bytes_expected=$expected.bytes;bytes_actual=(Get-Item -LiteralPath $canonicalPath).Length;root_match=($chain[0].id -eq $m.ancestry.root_id);root_parent=[string]$chain[0].reply_to;seed_match=($chain[-1].id -eq $m.seed.id);chain_problems=@($issues);manifest_candidate_count=@($m.seed_candidates).Count;manifest_candidate_text_differences=@($candidateDiffs.id);identical_text_groups=$duplicates;draft_body_failures=$bodyFailures;draft_post_count=([regex]::Matches($draftText,'(?m)^### P\d{3}')).Count;first_time_est=(LocalTime $ordered[0]);last_time_est=(LocalTime $ordered[-1])}
$result.manifest_candidate_text_differences=@($candidateDiffs | ForEach-Object { $_.id })
$result|ConvertTo-Json -Depth 20|Set-Content -LiteralPath (Join-Path $base 'integrity-checks.json') -Encoding utf8
$result|ConvertTo-Json -Depth 20
if(Test-Path -LiteralPath (Join-Path $base 'relevance-decisions.csv')) { & (Join-Path $PSScriptRoot 'filter_day17.ps1') }
