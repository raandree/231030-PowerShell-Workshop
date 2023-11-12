
param (
    [string]$ComputerName
)

function Write-Log([string]$Message)
{
    Write-Host $Message
}

function Get-Computer
{
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [string]$ComputerName,
        
        [Parameter(Mandatory, ParameterSetName = 'ByIpAddress')]
        [string]$IpAddress,
        
        [Parameter(ParameterSetName = 'ByName')]
        [Parameter(Mandatory, ParameterSetName = 'ByIpAddress')]
        [pscredential]$Credential,
        
        [switch]$Force
    )
    
    if ($PSCmdlet.ParameterSetName -eq 'ByName')
    {
        [pscustomobject]@{
            ComputerName = $ComputerName
            IpAddress = '10.0.0.1'
            OS = 'Windows Server 2022'
        }
    }
    
    if ($PSCmdlet.ParameterSetName -eq 'ByIpAddress')
    {
        [pscustomobject]@{
            ComputerName = 'Server2'
            IpAddress = $IpAddress
            OS = 'Windows Server 2019'
        }
    }
}

function Remove-Computer
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ComputerName,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('OS')]
        [string]$OperatingSystem
    )
    
    process {
        foreach ($name in $ComputerName)
        {
            Write-Log -Message "Working on '$name'"
            Import-Module -Name NTFSSecurity #-Verbose:$false
            #Dont use Read-Host
            #$answer = Read-host -Prompt "Shall we delete the object"
            #if ($answer -eq 'Yes')
            
            #https://tinuwalther.github.io/posts/function.html#whatif-and-confirm
            if ($PSCmdlet.ShouldProcess("Computer Object with name '$name'", 'Remove it from Active Directory'))
            {
                Write-Host "Removing computer '$name'."
            }
            else
            {
                Write-Host "Would have remoted computer '$name'."
            }
        }
        
        Write-Host Finished
    }
}

$PSDefaultParameterValues = @{
    'Import-Module:Verbose' = $false
}

Write-ScreenInfo -Message 123
Write-Host "PID: $PID"

$c = Get-Computer -ComputerName $ComputerName
$c | Remove-Computer -Confirm:$false


$a = 5
$a