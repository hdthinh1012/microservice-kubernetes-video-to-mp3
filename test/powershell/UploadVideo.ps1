param ( [Parameter(Mandatory=$true)] [string]$FilePath)

$username = 'admin@gmail.com'
$password = '123456'

$pair = "$($username):$($password)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$LoginHeaders = @{
    Authorization = $basicAuthValue
}

$loginResponse = Invoke-WebRequest -Uri http://mp3converter.com/login -Method Post -Headers $LoginHeaders

$jwtToken = ""
if ($loginResponse.StatusCode -eq 200)
{
    $jwtToken = $loginResponse.Content
    Write-Output "Login success"
    Write-Output $jwtToken
}
else 
{
    Write-Output "Login failed!"
    Exit
}

$UploadHeaders = @{
    Authorization = "Bearer $jwtToken"
}

# Both method of uploading mp4 or not working for Flask API request.files -> Just use Postman
#####################################################################################################################################

# Using Invoke-RestMethod -> INCORRECT only use for txt file, this method limit usage on REST API
# $fileBytes = [System.IO.File]::ReadAllBytes($FilePath);
# $fileEnc = [System.Text.Encoding]::GetEncoding('UTF-8').GetString($fileBytes);
# $boundary = [System.Guid]::NewGuid().ToString(); 
# $LF = "`r`n";

# $bodyLines = ( 
#     "--$boundary",
#     "Content-Disposition: form-data; name=`"file`"; filename=`"sintel_trailer-1080p.mp4`"",
#     "Content-Type: application/octet-stream$LF",
#     $fileEnc,
#     "--$boundary--$LF" 
# ) -join $LF

# $uploadResponse = Invoke-RestMethod -Uri http://mp3converter.com/upload -Method Post -Headers $UploadHeaders -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLines

# Write-Output $uploadResponse

#####################################################################################################################################

# Using Invoke-RequestMethod
$uploadResponse = Invoke-WebRequest -Uri http://mp3converter.com/upload -Method Post -Headers $UploadHeaders -InFile $FilePath -ContentType "video/mp4";
Write-Output $uploadResponse

#####################################################################################################################################