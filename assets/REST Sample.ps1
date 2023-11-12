$InstanceName = 'feeds.dev.azure.com/randree'
$CollectionName = 'Test1'
#$ApiVersion = '7.0'
$PersonalAccessToken = '4a63nsosm3mfbnoq6w4ye5ebcejp35mg4i3p7ycapx6rwebrk6lq'

function Get-TfsAccessTokenString
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $True)]
        [String] $PersonalAccessToken
    )

    $tokenString = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f '',$PersonalAccessToken)))
    return ("Basic {0}" -f $tokenString)
}

if ($SkipCertificateCheck.IsPresent)
{
    $null = [ServerCertificateValidationCallback]::Ignore()
}

$requestUrl = if ($UseSsl) { 'https://' } else { 'http://' }
$requestUrl += if ($Port -gt 0)
{
    '{0}{1}/{2}/_apis/packaging/feeds' -f $InstanceName, ":$Port", $CollectionName
}
else
{
    '{0}/{1}/_apis/packaging/feeds' -f $InstanceName, $CollectionName
}
    
if ($ApiVersion)
{
    $requestUrl += '?api-version={0}' -f $ApiVersion
}

$requestParameters = @{
    Uri = $requestUrl
    Method = 'Get'
    ErrorAction = 'Stop'
}

if ($PSEdition -eq 'Core' -and (Get-Command -Name Invoke-RestMethod).Parameters.ContainsKey('SkipCertificateCheck'))
{
    $requestParameters.SkipCertificateCheck = $SkipCertificateCheck.IsPresent
}

if ($Credential)
{
    $requestParameters.Credential = $Credential
}
else
{
    $requestParameters.Headers = @{ Authorization = Get-TfsAccessTokenString -PersonalAccessToken $PersonalAccessToken }
}

try
{
    $result = Invoke-RestMethod @requestParameters
    $result
}
catch
{
    if ($_.ErrorDetails.Message)
    {
        $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
        if ($errorDetails.typeKey -eq 'ProjectDoesNotExistWithNameException')
        {
            return $null
        }
    }
    Write-Error -ErrorRecord $_
}
