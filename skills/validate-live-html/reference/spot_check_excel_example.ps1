# Excel-engine spot check: re-derives a handful of displayed values inside the
# live workbooks via Worksheet.Evaluate (a third computation path, independent
# of both the generator and the Python recompute).
# Genericized copy of a real, working check. Fill the paths from the real
# dashboard's generator and swap the example names/patterns for people who
# actually appear in your sources.
$ErrorActionPreference = 'Stop'
$tsheet = "C:\path\to\Timesheet Master.xlsx"
$master = "C:\path\to\Engineering Project Master.xlsx"

$xl = New-Object -ComObject Excel.Application
$xl.Visible = $false
$xl.DisplayAlerts = $false

function ColLetter([int]$c) {
    $s = ""
    while ($c -gt 0) { $r = ($c - 1) % 26; $s = [char](65 + $r) + $s; $c = [int](($c - $r - 1) / 26) }
    $s
}
function HeaderMap($ws) {
    $map = @{}
    $lastCol = $ws.UsedRange.Column + $ws.UsedRange.Columns.Count - 1
    for ($c = 1; $c -le $lastCol; $c++) {
        $h = $ws.Cells.Item(1, $c).Value2
        if ($h) { $map[$h.ToString().Trim()] = ColLetter $c }
    }
    $map
}
function Ev($ws, $f) {
    $v = $ws.Evaluate($f)
    if ($v -is [int] -and $v -lt -2000000000) { "ERROR($v) from $f" } else { $v }
}

try {
    # ---------- Timesheet Master ----------
    $wb = $xl.Workbooks.Open($tsheet, 0, $true)
    $ws = $wb.Worksheets.Item("Data")
    $cols = HeaderMap $ws
    $n = $ws.UsedRange.Row + $ws.UsedRange.Rows.Count - 1
    $P = $cols["Person"]; $PR = $cols["Project"]; $H = $cols["Hours"]
    "TSHEET  Person=$P Project=$PR Hours=$H lastRow=$n"
    # Wildcard-match first, then read the exact stored spelling - never assume it.
    $mrow = Ev $ws ('MATCH("*mith-jon*",{0}2:{0}{1},0)' -f $P, $n)
    if ($mrow -is [double]) {
        $exact = $ws.Range("$P$([int]($mrow+1))").Value2
        "TSHEET  exact Person spelling: '$exact'"
        $cnt = Ev $ws ('COUNTIF({0}2:{0}{1},"{2}")' -f $P, $n, $exact)
        $hrs = Ev $ws ('SUMIFS({0}2:{0}{3},{1}2:{1}{3},"{4}",{2}2:{2}{3},"*PRJ*")' -f $H, $P, $PR, $n, $exact)
        "TSHEET  '$exact': $cnt rows total, project-coded hours = $hrs"
    } else {
        "TSHEET  no Person matching *mith-jon*: $mrow"
    }
    $wb.Close($false)

    # ---------- Project Master ----------
    $wb = $xl.Workbooks.Open($master, 0, $true)
    $ws = $wb.Worksheets.Item("Project Master")
    $cols = HeaderMap $ws
    $n = $ws.UsedRange.Row + $ws.UsedRange.Rows.Count - 1
    $D1 = $cols["Assigned Drafter 1"]; $D2 = $cols["Assigned Drafter 2"]; $D3 = $cols["Assigned Drafter 3"]
    $PN = $cols["Project Number"]; $QA = $cols["QAQC Assigned To"]; $SV = $cols["Survey Assigned To"]
    "MASTER  D1=$D1 D2=$D2 D3=$D3 PN=$PN QA=$QA SV=$SV lastRow=$n"
    $f = 'SUMPRODUCT(--((({0}2:{0}{4}="Jane Smith-Jones")+({1}2:{1}{4}="Jane Smith-Jones")+({2}2:{2}{4}="Jane Smith-Jones")>0)*({3}2:{3}{4}<>"")))' -f $D1, $D2, $D3, $PN, $n
    "MASTER  Jane Smith-Jones drafted = $(Ev $ws $f)"
    "MASTER  John Doe QAQC count = $(Ev $ws ('COUNTIF({0}2:{0}{1},"John Doe")' -f $QA, $n))"
    "MASTER  Alex Lee Survey count = $(Ev $ws ('COUNTIF({0}2:{0}{1},"Alex Lee")' -f $SV, $n))"
    $wb.Close($false)
}
finally {
    $xl.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl) | Out-Null
}
