# Worked example of a finished Template v2 documentation doc, built for an
# invented dashboard ("Example Operations Dashboard"). Adapt the content per
# dashboard; keep the mechanics exactly as they are here. Every function and
# ordering choice below survived a real review cycle - see SKILL.md's
# "Word COM mechanics" section for why each one exists.

$ErrorActionPreference = 'Stop'

# The output goes in the vault's documentation folder, read from
# 99 System/Skill Preferences.md, section "## Dashboard audit & documentation",
# key "documentation folder:". Substitute it here before running.
$docFolder = "C:\Path\To\Documentation Folder"
$path = Join-Path $docFolder "Example Operations Dashboard - Documentation.docx"

$navy     = 31 + 56*256 + 100*65536
$gray     = 128 + 128*256 + 128*65536
$hdrShade = 217 + 226*256 + 243*65536
$green    = 0 + 97*256 + 0*65536
$teal     = 23 + 130*256 + 140*65536
$amber    = 156 + 101*256 + 12*65536
$auto     = -16777216

$word = New-Object -ComObject Word.Application
$word.Visible = $false
# Disable AutoCorrect while typing; restore in the finally block. Without this,
# Word "corrects" typed text (sentence caps, replacements) behind your back.
$acSent = $word.AutoCorrect.CorrectSentenceCaps
$acRepl = $word.AutoCorrect.ReplaceText
$word.AutoCorrect.CorrectSentenceCaps = $false
$word.AutoCorrect.ReplaceText = $false

try {
    $doc = $word.Documents.Add()
    $sel = $word.Selection

    # House style (Template v2): body/title/section headers 11pt,
    # tab headings 16pt, tables 10pt. Set sizes and colors on the STYLE
    # OBJECTS, never as direct formatting on typed runs.
    $s = $doc.Styles("Normal"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.ParagraphFormat.SpaceAfter = 8
    $s = $doc.Styles("Title"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.Font.Bold = $true; $s.Font.Color = $navy
    $s = $doc.Styles("Heading 1"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.Font.Bold = $true; $s.Font.Color = $navy
    $s.ParagraphFormat.SpaceBefore = 18; $s.ParagraphFormat.SpaceAfter = 8
    $b = $s.ParagraphFormat.Borders.Item(-3); $b.LineStyle = 1; $b.LineWidth = 4; $b.Color = $navy
    $s = $doc.Styles("Heading 2"); $s.Font.Name = "Calibri"; $s.Font.Size = 16; $s.Font.Bold = $true; $s.Font.Color = $navy
    $s.ParagraphFormat.SpaceBefore = 12; $s.ParagraphFormat.SpaceAfter = 5
    $s = $doc.Styles("Heading 3"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.Font.Bold = $true; $s.Font.Color = $teal
    $s.ParagraphFormat.SpaceBefore = 8; $s.ParagraphFormat.SpaceAfter = 3

    # Reset direct formatting to the CURRENT paragraph style's font. Never
    # reset to hardcoded values: hardcoding once silently shrank 16pt tab
    # headings back to 11pt.
    function Reset-Font {
        $st = $sel.Style
        $sel.Font.Bold = $st.Font.Bold
        $sel.Font.Italic = $st.Font.Italic
        $sel.Font.Color = $st.Font.Color
        $sel.Font.Size = $st.Font.Size
    }
    function Add-Para([string]$text, [string]$style) {
        $sel.Style = $doc.Styles($style); Reset-Font; $sel.TypeText($text); $sel.TypeParagraph()
    }
    function Add-Gray([string]$text, [string]$style) {
        $sel.Style = $doc.Styles($style); Reset-Font
        $sel.Font.Italic = $true; $sel.Font.Color = $gray
        $sel.TypeText($text); Reset-Font; $sel.TypeParagraph()
    }
    # The stamp is "Validated YYYY-MM-DD" and nothing else. Use the audit date.
    # A tab whose audit did not pass, or was not audited, gets NO stamp at all:
    # skip the Add-Check call for that tab.
    function Add-Check {
        $sel.Style = $doc.Styles("Normal"); Reset-Font
        $sel.Font.Bold = $true; $sel.Font.Color = $green; $sel.TypeText("Validated 2026-03-20")
        Reset-Font; $sel.TypeParagraph()
    }
    function Add-Lead([string]$lead, [string]$body, [string]$style, [int]$leadColor = 0) {
        if ($leadColor -eq 0) { $leadColor = $navy }
        $sel.Style = $doc.Styles($style); Reset-Font
        $sel.Font.Bold = $true; $sel.Font.Color = $leadColor; $sel.TypeText($lead)
        Reset-Font; $sel.TypeText($body); $sel.TypeParagraph()
    }
    function Add-TabHeading([string]$name) {
        $sel.Style = $doc.Styles("Heading 2"); Reset-Font
        $sel.Font.Color = $teal; $sel.TypeText("Tab:  ")
        $sel.Font.Color = $navy; $sel.TypeText($name)
        Reset-Font; $sel.TypeParagraph()
    }
    function New-Table($rows, $colWidths, $hasHeader) {
        $tbl = $doc.Tables.Add($sel.Range, $rows.Count, $colWidths.Count)
        $tbl.Style = "Table Grid"
        $tbl.Range.Font.Size = 10
        for ($c = 0; $c -lt $colWidths.Count; $c++) {
            $tbl.Columns.Item($c + 1).Width = $word.CentimetersToPoints($colWidths[$c])
        }
        for ($r = 0; $r -lt $rows.Count; $r++) {
            for ($c = 0; $c -lt $colWidths.Count; $c++) {
                $tbl.Cell($r + 1, $c + 1).Range.Text = $rows[$r][$c]
            }
        }
        if ($hasHeader) {
            $tbl.Rows.Item(1).Shading.BackgroundPatternColor = $hdrShade
            for ($c = 1; $c -le $colWidths.Count; $c++) { $tbl.Cell(1, $c).Range.Font.Bold = $true }
        }
        $tbl
    }
    function After-Table { $sel.EndKey(6) | Out-Null; $sel.Style = $doc.Styles("Normal"); Reset-Font; $sel.TypeParagraph() }

    # ================= title =================
    Add-Para "Example Operations Dashboard" "Title"
    Add-Gray "Live HTML Documentation  |  C2 Group  |  HTML Documentation Template v2" "Normal"

    # ================= 1. general information =================
    Add-Para "1. General Information" "Heading 1"
    $rows = @(
        @("Project", "Example operations program dashboard"),
        @("Scope", "The three-tab page 'Example Operations Dashboard.html': Overview, Team Performance, Data Quality. The separate executive summary page is not covered here."),
        # These four cells are ONE short answer each. No history in Creation
        # Date, no email or generator path in Author / Owner, no "who opens
        # which copy" in Audience, no scheduled task name in Update cadence.
        @("Creation Date", "2026-02-16"),
        @("Author / Owner", "Jordan Rivera"),
        @("Audience", "Operations team"),
        @("Live location", "OneDrive - C2 Group/Operations - Shared/04 Reporting/Example Operations Dashboard.html"),
        @("Update cadence", "Nightly from regenerate.py"),
        # Data sources are a LIST INSIDE ONE CELL: one source per line, its
        # description indented under it, lines joined with [char]11 (a soft
        # line break; a real newline would split the cell).
        @("Data sources", (@(
            "1)  Operations - Shared/Operations Master.xlsx",
            "      work orders, stages, due dates",
            "2)  Operations - Shared/Timesheet Export.xlsx ('Data' tab)",
            "      hours logged",
            "3)  Operations - Shared/Quality Checks.xlsx",
            "      QC scores per work order",
            "All under OneDrive - C2 Group, read live at build time."
        ) -join [char]11))
    )
    New-Table $rows @(4.2, 12.0) $false | ForEach-Object {
        for ($r = 1; $r -le $rows.Count; $r++) {
            $_.Cell($r, 1).Range.Font.Bold = $true
            $_.Cell($r, 1).Shading.BackgroundPatternColor = $hdrShade
        }
    }
    After-Table

    # ================= 2. purpose =================
    Add-Para "2. Purpose" "Heading 1"
    # "What it is" is ONE sentence: what kind of page, and how often it
    # rebuilds. Not which modules it reads, not that it is a build-time snapshot.
    Add-Lead "What it is: " "One self-contained HTML file holding all three operations dashboards, rebuilt nightly." "List Bullet"
    Add-Lead "What it shows: " "Where every work order stands (due dates, schedule health, stage, ownership), how the team's effort is spent (hours, throughput, QC scores), and whether the source feeds themselves are healthy." "List Bullet"

    # ================= 3. tab breakdown =================
    # One block per tab: teal Tab: heading, What it shows, a
    # Metric/Source/Logic table, that tab's OWN How to Use, and the stamp.
    # How to Use is written from the page's real controls, verified in the
    # page HTML, never invented.
    Add-Para "3. Tab Breakdown" "Heading 1"

    # ---- overview
    Add-TabHeading "Overview"
    Add-Lead "What it shows: " "The landing tab. It shows what is due this week and what is late. There are three at-a-glance counters (Open, Due This Week, Late), a card listing this week's due work orders, and a scrolling list of late work orders that have not been closed." "Normal"
    New-Table @(
        @("Metric", "Source", "Logic"),
        @("Due This Week", "Operations Master: Due Date", "Computed live against the viewer's clock, not the build clock. Excludes work orders already closed. Canceled and On Hold work orders are excluded from every list on this tab."),
        @("Late (Not Yet Closed)", "Operations Master: 'Status'", "The master's own 'Late' bucket, refreshed each rebuild. A late work order with no close date stays on the list until it is closed.")
    ) @(4.0, 4.6, 7.6) $true | Out-Null
    After-Table
    Add-Para "How to Use" "Heading 3"
    Add-Lead "Start of day: " "the three counters give a quick read on what needs attention. The card splits this week's items by due date." "List Bullet"
    Add-Lead "Interactions: " "this tab has no filters. Click any work order to open the owning person's row on Team Performance." "List Bullet"
    Add-Lead "Good to know: " "this week is computed from your device's date. The data itself refreshes only on the nightly rebuild." "List Bullet"
    Add-Check

    # ---- team performance
    Add-TabHeading "Team Performance"
    # No "(18 people at the audited build)": counts taken from the audited
    # build are stale within a rebuild cycle. Describe the rule, not the reading.
    Add-Lead "What it shows: " "One row per person, grouped into tables by department: Operations and Support. Each table carries the columns that describe that department's work. A dash means no value exists; a zero is a real zero." "Normal"
    New-Table @(
        @("Metric", "Source", "Logic"),
        @("Orders completed", "Operations Master: Assigned To", "Work orders naming the person and carrying a close date inside the window shown on the page. A person counts once per work order."),
        @("Open right now", "Operations Master: Assigned To + Status", "Assigned work orders not yet Closed, Canceled, or On Hold."),
        @("Hours logged", "Timesheet Export 'Data' tab", "Hours on order-coded rows only. General time (meetings, travel, training) shows in the profile, not here."),
        @("Hours per day", "Timesheet Export", "Order hours divided by the days the person actually booked order time. Recomputed live when the view is filtered."),
        @("QC score", "Quality Checks + timesheet", "Plain average of QC scores across the work orders the person logged hours to. Blank for Support because the score measures operations work.")
    ) @(4.0, 4.6, 7.6) $true | Out-Null
    After-Table
    Add-Para "How to Use" "Heading 3"
    Add-Lead "Filter by department: " "the Operations / Support / All dropdown re-scopes the tables and their totals." "List Bullet"
    Add-Lead "Open a profile: " "click a person's row to see their open and completed work orders, hours by month, general and order time, and QC score with per-order detail." "List Bullet"
    Add-Lead "Reading the numbers: " "dashes are not zeros, and hours cover only the window shown on the page." "List Bullet"
    Add-Check

    # ---- data quality
    Add-TabHeading "Data Quality"
    Add-Lead "What it shows: " "Health of the three source feeds at the last build: last-modified time per feed, row counts against the prior build, and a list of rows the build rejected (missing IDs, unparseable dates) with the reason for each." "Normal"
    New-Table @(
        @("Metric", "Source", "Logic"),
        @("Feed freshness", "All three source files", "Last-modified timestamp of each file compared to the build time. A feed older than 48 hours at build is flagged amber."),
        @("Rejected rows", "Operations Master, Timesheet Export", "Rows the build skipped, with the reason. Rejected rows are excluded from every other tab; the count here is the only place they appear.")
    ) @(4.0, 4.6, 7.6) $true | Out-Null
    After-Table
    Add-Para "How to Use" "Heading 3"
    Add-Lead "Controls: " "this tab has no filters." "List Bullet"
    Add-Lead "Interactions: " "click a rejected row to see the raw source values that caused the rejection." "List Bullet"
    Add-Lead "Good to know: " "a flagged feed does not stop the build. The page still publishes from whatever data was readable." "List Bullet"
    Add-Check

    # ================= 4. validations =================
    # This whole section, and the stamps above, come from the audit file
    # (<Dashboard Name> - Audit.md), including the vault owner's caveat
    # answers. Do not write it from memory.
    Add-Para "4. Validations" "Heading 1"
    # The scope line is ONE sentence: what was audited, and the skill. No build
    # timestamps, no feed-freshness narrative, no count of figures compared.
    Add-Para "Scope: The full three-tab page via the validate-live-html skill." "Normal"
    New-Table @(
        @("Validation", "How it was checked", "Result", "By / Date"),
        @("Source data", "All 3 feeds predate the build. No garbage values in the timesheet rows or work orders.", "PASS. Note: timesheet data ends March 15.", "Claude, 2026-03-20"),
        @("Calculations", "Every embedded dataset recomputed from the raw sources with independent code. Everything matches.", "PASS", "Claude, 2026-03-20"),
        @("Output", "Cross-checks inside and between datasets: Overview counters match their own lists. Team Performance departments, profiles, and monthly sums all tally. The name match between master and timesheet is clean.", "PASS.", "Claude, 2026-03-20"),
        # The Human spot check row is the ONE place specific values belong:
        # the values checked are the evidence.
        @("Human spot check", "Team Performance: 4 values re-derived inside the live workbooks using Excel's own engine (Alvarez 812.25 h; Chen 41 completed; Okafor 12 open; Ito 4.6 QC average). All match the page.", "PASS 4/4", "Jordan 3/20/2026")
    ) @(2.6, 7.4, 3.4, 2.8) $true | ForEach-Object {
        for ($r = 2; $r -le 5; $r++) {
            $_.Cell($r, 1).Range.Font.Bold = $true
            $_.Cell($r, 3).Range.Font.Color = $green
        }
    }
    After-Table
    # ONE amber note. Operational note, Not covered by this audit and Standing
    # finding stay in the audit file and are not carried into the document.
    # Nothing in this note may also appear in a tab's How to Use: say it once.
    Add-Lead "By design, not faults: " "some timesheet work orders are not on the master and go unused by the page. Support staff showing 0.0 order hours are genuine zeros because their time is general-coded." "Normal" $amber

    # SaveAs fails when the user has the doc open in Word. Catch it, save a
    # (v2) copy beside it, and tell them; swap the copy in after they close
    # the original, then delete the copy so the folder stays clean.
    try {
        $doc.SaveAs([ref]$path)
        Write-Output "SAVED OK: $path"
    } catch {
        $alt = Join-Path $docFolder "Example Operations Dashboard - Documentation (v2).docx"
        $doc.SaveAs([ref]$alt)
        Write-Output "ORIGINAL LOCKED (probably open in Word) - saved as: $alt"
        $path = $alt
    }
    $doc.Close($false)

    # Post-save verification: reopen read-only and check heading styles,
    # sizes, and table count before reporting done.
    $chk = $word.Documents.Open($path, $false, $true)   # ReadOnly = $true
    $h2Size = $chk.Styles("Heading 2").Font.Size
    $tblCount = $chk.Tables.Count
    $chk.Close($false)
    if ($h2Size -ne 16) { throw "VERIFY FAILED: Heading 2 is ${h2Size}pt, expected 16pt" }
    if ($tblCount -ne 5) { throw "VERIFY FAILED: found $tblCount tables, expected 5" }
    Write-Output "VERIFIED: Heading 2 = ${h2Size}pt, $tblCount tables"
}
finally {
    $word.AutoCorrect.CorrectSentenceCaps = $acSent
    $word.AutoCorrect.ReplaceText = $acRepl
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
}
