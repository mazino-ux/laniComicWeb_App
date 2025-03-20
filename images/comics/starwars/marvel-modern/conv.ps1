Get-ChildItem . -Filter *.jpg | Foreach-Object {
    $pngname = $_.Fullname + ".png"
    magick $_.Fullname $pngname
    magick $pngname $_.Fullname
    del $pngname
}