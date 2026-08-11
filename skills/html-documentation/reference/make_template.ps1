$ErrorActionPreference = 'Stop'
# The output goes in the vault's documentation folder, read from
# 99 System/Skill Preferences.md, section "## Dashboard audit & documentation",
# key "documentation folder:". Substitute it here before running.
$path = "C:\Path\To\Documentation Folder\HTML Documentation Template.docx"

$navy     = 31 + 56*256 + 100*65536
$gray     = 128 + 128*256 + 128*65536
$hdrShade = 217 + 226*256 + 243*65536
$green    = 0 + 97*256 + 0*65536
$teal     = 23 + 130*256 + 140*65536
$amber    = 156 + 101*256 + 12*65536
$auto     = -16777216

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$acSent = $word.AutoCorrect.CorrectSentenceCaps
$acRepl = $word.AutoCorrect.ReplaceText
$word.AutoCorrect.CorrectSentenceCaps = $false
$word.AutoCorrect.ReplaceText = $false

try {
    $doc = $word.Documents.Add()
    $sel = $word.Selection

    # House style (Template v2): body/title/section headers 11pt,
    # tab headings 16pt, tables 10pt. Teal = usage labels, navy = structure,
    # green = validated, amber = caveats. Plain prose, no dash clauses.
    $s = $doc.Styles("Normal"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.ParagraphFormat.SpaceAfter = 8
    $s = $doc.Styles("Title"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.Font.Bold = $true; $s.Font.Color = $navy
    $s = $doc.Styles("Heading 1"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.Font.Bold = $true; $s.Font.Color = $navy
    $s.ParagraphFormat.SpaceBefore = 18; $s.ParagraphFormat.SpaceAfter = 8
    $b = $s.ParagraphFormat.Borders.Item(-3); $b.LineStyle = 1; $b.LineWidth = 4; $b.Color = $navy
    $s = $doc.Styles("Heading 2"); $s.Font.Name = "Calibri"; $s.Font.Size = 16; $s.Font.Bold = $true; $s.Font.Color = $navy
    $s.ParagraphFormat.SpaceBefore = 12; $s.ParagraphFormat.SpaceAfter = 5
    $s = $doc.Styles("Heading 3"); $s.Font.Name = "Calibri"; $s.Font.Size = 11; $s.Font.Bold = $true; $s.Font.Color = $teal
    $s.ParagraphFormat.SpaceBefore = 8; $s.ParagraphFormat.SpaceAfter = 3

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
    function Add-Check([string]$when) {
        $sel.Style = $doc.Styles("Normal"); Reset-Font
        $sel.Font.Bold = $true; $sel.Font.Color = $green; $sel.TypeText("Validated $when")
        Reset-Font; $sel.TypeParagraph()
    }
    function Add-Lead([string]$lead, [string]$ph, [string]$style, [int]$leadColor = 0) {
        if ($leadColor -eq 0) { $leadColor = $navy }
        $sel.Style = $doc.Styles($style); Reset-Font
        $sel.Font.Bold = $true; $sel.Font.Color = $leadColor; $sel.TypeText($lead)
        Reset-Font; $sel.Font.Italic = $true; $sel.Font.Color = $gray
        $sel.TypeText($ph); Reset-Font; $sel.TypeParagraph()
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
    function Gray-Cell($tbl, [int]$r, [int]$c) {
        $tbl.Cell($r, $c).Range.Font.Italic = $true
        $tbl.Cell($r, $c).Range.Font.Color = $gray
    }
    function After-Table { $sel.EndKey(6) | Out-Null; $sel.Style = $doc.Styles("Normal"); Reset-Font; $sel.TypeParagraph() }

    # ================= title =================
    Add-Para "[Dashboard Name]" "Title"
    Add-Gray "Live HTML Documentation  |  C2 Group  |  HTML Documentation Template v2" "Normal"

    # ================= 1. general information =================
    Add-Para "1. General Information" "Heading 1"
    $rows = @(
        @("Project", "[Program or client this HTML belongs to]"),
        @("Scope", "[Which pages/tabs this document covers, and what it does not]"),
        @("Creation Date", "[When it went into production; when auto-publish went live]"),
        @("Author / Owner", "[Name (email). Where it is built from. Generator: path/to/build script]"),
        @("Audience", "[Who opens it and which copy they open]"),
        @("Live location", "[Path to the copy people actually open, written like OneDrive - C2 Group/folder/file.html]"),
        @("Update cadence", "[How and when it rebuilds; whether every rebuild publishes live]"),
        @("Data sources", (@(
            "1)  [folder/source-file-1.xlsx]",
            "      [what it provides]",
            "2)  [folder/source-file-2.xlsx]",
            "      [what it provides]",
            "[Where they all live and when they are read]"
        ) -join [char]11))
    )
    $tbl = New-Table $rows @(4.2, 12.0) $false
    for ($r = 1; $r -le $rows.Count; $r++) {
        $tbl.Cell($r, 1).Range.Font.Bold = $true
        $tbl.Cell($r, 1).Shading.BackgroundPatternColor = $hdrShade
        Gray-Cell $tbl $r 2
    }
    After-Table

    # ================= 2. purpose =================
    Add-Para "2. Purpose" "Heading 1"
    Add-Lead "What it is: " "[One or two sentences: what kind of page this is, how it gets its data, how often it updates]" "List Bullet"
    Add-Lead "What it shows: " "[What the viewer learns from it]" "List Bullet"

    # ================= 3. tab breakdown =================
    Add-Para "3. Tab Breakdown" "Heading 1"
    Add-Gray "Duplicate this block for each tab. Delete this line when done." "Normal"

    Add-TabHeading "[Tab Name]"
    Add-Lead "What it shows: " "[What is on this tab: layout, lists, counters]" "Normal"
    $tbl = New-Table @(
        @("Metric", "Source", "Logic"),
        @("[Metric name]", "[Source file / column]", "[How it is calculated, including what is excluded]"),
        @("[Metric name]", "[Source file / column]", "[How it is calculated]")
    ) @(4.0, 4.6, 7.6) $true
    for ($r = 2; $r -le 3; $r++) { for ($c = 1; $c -le 3; $c++) { Gray-Cell $tbl $r $c } }
    After-Table
    Add-Para "How to Use" "Heading 3"
    Add-Lead "Controls: " "[Dropdowns, search boxes, view switches, or 'this tab has no filters']" "List Bullet"
    Add-Lead "Interactions: " "[What clicking things does, where links go]" "List Bullet"
    Add-Lead "Good to know: " "[The one behavior that could confuse someone, if any]" "List Bullet"
    Add-Check "[YYYY-MM-DD]"
    Add-Gray "The green stamp goes in only after the tab passes the validate-live-html audit. Until then delete it or leave the date blank." "Normal"

    # ================= 4. validations =================
    Add-Para "4. Validations" "Heading 1"
    Add-Gray "[Scope: which tabs, audited against which build, on what date. Method in one sentence.]" "Normal"
    $tbl = New-Table @(
        @("Validation", "How it was checked", "Result", "By / Date"),
        @("Source data", "[Feed freshness vs build time, garbage-value scan, row volumes]", "[PASS / FAIL + notes]", "[Who, date]"),
        @("Calculations", "[What was recomputed independently and from where]", "[PASS / FAIL]", "[Who, date]"),
        @("Output", "[Internal and cross-dataset consistency checks]", "[PASS / FAIL + what was not verified]", "[Who, date]"),
        @("Human spot check", "[Which displayed values were checked against which source cells]", "[PASS n/n]", "[Who, date]")
    ) @(2.6, 7.4, 3.4, 2.8) $true
    for ($r = 2; $r -le 5; $r++) {
        $tbl.Cell($r, 1).Range.Font.Bold = $true
        for ($c = 2; $c -le 4; $c++) { Gray-Cell $tbl $r $c }
    }
    After-Table
    Add-Lead "Operational note: " "[Anything found during the audit that needs action outside the dashboard]" "Normal" $amber
    Add-Lead "Not covered by this audit: " "[The blind spots, stated plainly]" "Normal" $amber
    Add-Lead "Standing finding: " "[Anything that should become a permanent every-build check]" "Normal" $amber
    Add-Lead "By design, not faults: " "[Behaviors that look wrong but are intentional]" "Normal" $amber

    $doc.SaveAs([ref]$path)
    $doc.Close($false)
    Write-Output "SAVED OK: $path"
}
finally {
    $word.AutoCorrect.CorrectSentenceCaps = $acSent
    $word.AutoCorrect.ReplaceText = $acRepl
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
}
