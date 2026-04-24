$root = 'C:\Users\rudyv\Documents\COURS GE4\S8\Projet GES8\Rapport\rapport2\images'
$report = 'C:\Users\rudyv\Documents\COURS GE4\S8\Projet GES8\Rapport\rapport2'
$map = @()
Get-ChildItem -Path $root -Recurse -File | Where-Object { $_.Name -match '[^\u0000-\u007F]' -or $_.Name -match '\s' } | ForEach-Object {
    $old = $_.FullName
    $name = $_.Name
    $base = [IO.Path]::GetFileNameWithoutExtension($name)
    $ext = [IO.Path]::GetExtension($name)
    $base2 = ($base.Normalize([Text.NormalizationForm]::FormD) -replace '\p{Mn}','')
    $base2 = $base2 -replace '[^\w\-]','_'
    if ($base2 -eq '') { $base2 = 'file' }
    $newName = $base2 + $ext
    $dir = $_.DirectoryName
    $target = Join-Path $dir $newName
    $i = 1
    while (Test-Path $target) {
        $newName = "${base2}_$i$ext"
        $target = Join-Path $dir $newName
        $i++
    }
    Rename-Item -LiteralPath $old -NewName $newName
    $map += [PSCustomObject]@{Old=$old; New=$target; OldName=$name; NewName=$newName}
}
if ($map.Count -eq 0) { Write-Output 'No files to rename'; exit 0 }
$map | ConvertTo-Csv -NoTypeInformation | Set-Content mapping.csv
Write-Output 'Renamed files:'
$map | Format-Table | Out-String | Write-Output
Get-ChildItem -Path $report -Recurse -Filter *.tex | ForEach-Object {
    $file = $_.FullName
    $content = Get-Content -Raw -LiteralPath $file
    $changed = $false
    foreach ($m in $map) {
        $escaped = [regex]::Escape($m.OldName)
        if ($content -match $escaped) {
            $content = $content -replace $escaped, $m.NewName
            $changed = $true
        }
    }
    if ($changed) {
        Set-Content -LiteralPath $file -Value $content
        Write-Output "Updated: $file"
    }
}
Write-Output 'Done'