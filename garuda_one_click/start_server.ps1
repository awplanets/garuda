param([switch]$NoBrowser)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Port = 4188
$Listener = $null

function Get-MimeType($Path) {
    switch ([IO.Path]::GetExtension($Path).ToLowerInvariant()) {
        ".html" { "text/html; charset=utf-8"; break }
        ".css"  { "text/css; charset=utf-8"; break }
        ".js"   { "text/javascript; charset=utf-8"; break }
        ".json" { "application/json; charset=utf-8"; break }
        ".jpg"  { "image/jpeg"; break }
        ".jpeg" { "image/jpeg"; break }
        ".png"  { "image/png"; break }
        ".webp" { "image/webp"; break }
        ".gif"  { "image/gif"; break }
        ".mp3"  { "audio/mpeg"; break }
        ".wav"  { "audio/wav"; break }
        ".mp4"  { "video/mp4"; break }
        default { "application/octet-stream"; break }
    }
}

function New-GarudaListener {
    param([int]$StartPort)

    for ($p = $StartPort; $p -lt ($StartPort + 20); $p++) {
        $candidate = [Net.HttpListener]::new()
        $candidate.Prefixes.Add("http://127.0.0.1:$p/")
        try {
            $candidate.Start()
            return @{ Listener = $candidate; Port = $p }
        }
        catch {
            $candidate.Close()
        }
    }

    return $null
}

try {
    $Started = New-GarudaListener -StartPort $Port
    if (-not $Started) {
        throw "Could not start local server."
    }

    $Listener = $Started.Listener
    $Port = $Started.Port
    $Url = "http://127.0.0.1:$Port/"

    Write-Host "GARUDA is running at $Url"
    Write-Host "Keep this window open while playing. Close it to stop the game."
    if (-not $NoBrowser) {
        Start-Process $Url
    }

    while ($Listener.IsListening) {
        $Context = $Listener.GetContext()
        $Request = $Context.Request
        $Response = $Context.Response

        try {
            $LocalPath = [Uri]::UnescapeDataString($Request.Url.AbsolutePath)
            if ($LocalPath -eq "/") {
                $LocalPath = "/index.html"
            }

            $RelativePath = $LocalPath.TrimStart("/").Replace("/", [IO.Path]::DirectorySeparatorChar)
            $FullPath = [IO.Path]::GetFullPath([IO.Path]::Combine($Root, $RelativePath))
            $RootPath = [IO.Path]::GetFullPath($Root)

            if (-not $FullPath.StartsWith($RootPath, [StringComparison]::OrdinalIgnoreCase) -or -not [IO.File]::Exists($FullPath)) {
                $Response.StatusCode = 404
                $Bytes = [Text.Encoding]::UTF8.GetBytes("Not found")
                $Response.OutputStream.Write($Bytes, 0, $Bytes.Length)
                continue
            }

            $Bytes = [IO.File]::ReadAllBytes($FullPath)
            $Response.StatusCode = 200
            $Response.ContentType = Get-MimeType $FullPath
            $Response.Headers["Cache-Control"] = "no-store"
            $Response.ContentLength64 = $Bytes.Length
            $Response.OutputStream.Write($Bytes, 0, $Bytes.Length)
        }
        catch {
            $Response.StatusCode = 500
            $Bytes = [Text.Encoding]::UTF8.GetBytes("Server error")
            $Response.OutputStream.Write($Bytes, 0, $Bytes.Length)
        }
        finally {
            $Response.OutputStream.Close()
        }
    }
}
catch {
    Write-Host "Local server failed. Opening index.html directly as fallback."
    Start-Process (Join-Path $Root "index.html")
}
finally {
    if ($Listener) {
        $Listener.Close()
    }
}
