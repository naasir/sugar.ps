# sugar.ps: A PowerShell utility module with some sweet, syntactic goodness.

# -- ALIASES --------------------------------------

Set-Alias ~> Copy-Files
Set-Alias => Copy-FilesAndStructure
Set-Alias ?: Invoke-Ternary

# -- PUBLIC ---------------------------------------

function Copy-Files([string]$srcPattern, [string]$destPattern) {
    return copy-filesFromPattern $srcPattern $destPattern
}

function Copy-FilesAndStructure([string]$srcPattern, [string]$destPattern) {
    return copy-filesFromPattern $srcPattern $destPattern -preserveStructure
}

# shorthand if-then-else function
# borrowed from: http://blogs.msdn.com/b/powershell/archive/2006/12/29/dyi-ternary-operator.aspx
function Invoke-Ternary([scriptblock]$decider, [scriptblock]$ifTrue, [scriptblock]$ifFalse) {
   if (&$decider) { 
      &$ifTrue
   } else { 
      &$ifFalse 
   }
}

# -- PRIVATE --------------------------------------

# copy files specified by ANT styled paths
# ref: http://ant.apache.org/manual/dirtasks.html#patterns
function copy-filesFromPattern([string]$srcPattern, [string]$destPattern, [switch]$preserveStructure) {
    $baseDir = get-basePathFromPattern $srcPattern
    get-filesFromPattern $srcPattern | foreach-object {
        $path = ?: { $preserveStructure } { return $_.FullName.Replace($baseDir, "") } { return "" }
        $destination = ?: { [System.IO.Path]::HasExtension($destPattern) } { return $destPattern } { return join-path $destPattern $path }
        $destDir = [System.IO.Path]::GetDirectoryName($destination)

        if (!(test-path $destDir)) {
            new-item $destDir -type directory -force
        }

        write-host "Copying $_ -> $destination"
        copy-item $_.FullName -destination $destination -recurse -force
    }
}

function get-filesFromPattern($pattern) {
    $regex = convert-antSearchPatternToRegex $pattern
    $baseDir = get-basePathFromPattern $pattern
    return get-filesFromRegex $baseDir $regex
}

function get-basePathFromPattern($pattern) {
    $separatorIndex = 0
    
    for($i=0; $i -lt $pattern.length; $i++) {
        $char = $pattern[$i]
        if ($char -match '(\\|/)') { $separatorIndex = $i }
        if ($char -match '(\*|\?)') { break }
    }
    
    $base = $pattern.substring(0, $separatorIndex + 1)
    return $base
}

# ref: http://ant.apache.org/manual/dirtasks.html#patterns
function convert-antSearchPatternToRegex($searchPattern) {
    
    # shorthand: /dir/subdir/ is interpreted as /dir/subdir/**
    if (test-isDirectoryPattern $searchPattern) {
        $searchPattern += "**"
    }
    
    $regex = "^{0}`$" -f [regex]::Escape($searchPattern)
    $regex = $regex.replace("\?", ".+").replace("\*\*\\", ".*").replace("\*\*", ".*").replace("\*", "[^\\]*")   
    return $regex
}

function get-filesFromRegex($baseDir, $regex) {
    return get-childitem $baseDir -recurse | where-object {
        !$_.PsIsContainer -and
        $_.FullName -match $regex
    }
}

function test-isDirectoryPattern($pattern) {
    return $pattern.EndsWith("/") -or $pattern.EndsWith("\")
}

# -- EXPORT --------------------------------------
Export-ModuleMember -function Copy-Files, Copy-FilesAndStructure, Invoke-Ternary -alias ~>, =>, ?: