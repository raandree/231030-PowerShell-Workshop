# PowerShell Workshop October 30 2023

## Agenda

| Thema | Beschreib/Fragestellung |	Tag |Intens-Level | Zeit-h
| --- | --- | --- | --- | --- |
Intro Flo | Organisatorisches Kursinhalt Zielgruppe | 1 | 0 | 5min
Windows PowerShell versus PowerShell 7 | Warum auf PWSH? | 1 | 1 | 1
Enter the Pipeline (F. Weinmann) | Begin, Process, End block | 1 | 2 | 2
Refactory a long long long Script | Invoke-ClusterUpdate.ps1 | 1 | 3 | 4
Parameter Options | [CmdletBinding()]<br>ByValue(Object Data Type)<br>ByPropertyName(Object Property Name)<br>[ValidateScript()]<br>[ValidateLength()]<br>ParameterSetName Etc. | 2 | 1 | 1
Nutzung von .net Static Members/Methods | Bsp. [System.Net.Dns]::Resolve($env:COMPUTERNAME)<br>- Beispiele gängiger Methoden aus .net-Klassen<br>- Suchmöglichkeiten nach den Members/Methods | 2 | 2| 2
Debugging mit ISE, VSCode, Shell | | 2 | 3 | 4
Remoting | Invoke-Command vs. New-PSSession<br>Load Modules in a remote session<br>Copy-Items between two computers | 3 | 1 | 2
REST API | Wie kommt man zu den Infos?<br>•	URL<br>•	Methoden<br>•	Etc. | 3 | 2 | 1
Pester Tests mit Pester v5x | Simple Tests (should -not throw)<br>Unit Tests (Functions, Modules, Scripts / Mocking)<br>Infrastruktur Tests (Hyper-V, VMware, Windows, etc.) | 3 | 3 | 4
RegEx | Warum RegEx?<br>Anwendungsbeispiele<br>- IPv4Address<br>- IPv6Address<br>- Subenet<br>- Etc. | 4 | 1 | 1
Verschiedene Logging-Möglichkeiten | PSFramework<br>Transcript<br>etc. | 4 | 1 | 2
Script- und Module Entwicklung für NuGet Repositories | Nexus Repo | 4 | 2 | 4

### Additional topics added to the agends:

- The object-oriented approach in PowerShell
- DSC basics and DSC in an fully automated DevOps approach (DscWorkshop)
- C# code in PowerShell (Add-Type)
- Markdown
- Git basics
- Parallel job execution with threads
- Scheduled jobs
- Code Quality / Linting

---

## Useful Tools

[ILSpy - the open-source .NET assembly browser and decompiler](https://github.com/icsharpcode/ILSpy)
[AutomatedLab](https://automatedlab.org/en/latest/)


---

## Documentation Links

- [Deep dive articles](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/overview?view=powershell-7.3), previously published by Kevin Marquette as [PowerShell Explained](https://powershellexplained.com/).
- [ValueFromPipeline and ValueFromPipelineByPropertyName explained](https://learn-powershell.net/2013/05/07/tips-on-implementing-pipeline-support/)
 - [PowerShell.one](https://powershell.one/)
 - [PowerShell training material](https://github.com/raandree/PowerShellTraining) that explains functions and modules.

---

## Visual Studio Code

### Extesions

> Note: You can automatically install extensions into VSCode by calling ```code --install-extension <path>```

- [Powershell Extension Pack - A good collection](https://marketplace.visualstudio.com/items?itemName=justin-grote.powershell-extension-pack)
- [PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- [GitLense](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
- [vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons)

---

### Config

Each VSCode project can have it own settings when storing them in the file ```settings.json``` which must be in the ```.vscode``` folder. These settings may contain code style settings and settings for extensions.

### Debugging
- You can create yourself debug configs for each project. This is stored in the ```launch.json``` file in the ```.vscode``` folder.
 
  > Here you can find more information about [debugging](https://code.visualstudio.com/Docs/editor/debugging).
 
- Breakpoints can have added expressions or hit count, which makes debugging of loops much more comfortable.
- The watch pane is most effective way to get an overview of you variables and their content.
- Use the call stack that shows you the path to the current breakpoint in your code. You can easily navigate back to the part of the code that called the code you are currently having the breakpoint in.
- Remote debugging works in the ISE by opening a script with the command ```psEdit``` in the remote machine within a interactive session. If the workflow to start the script remotely is more complex, you can use the cmdlet ```Wait-Debugger``` to halt the process and attache to it with ```Enter-PSHostProcess```. You need to know the process ID which is reflected by the variable ```$PID```.

### Git Integration

A simple Git implementation is built into VSCode by default. The extension [GitLense](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) additionally gives you a graphical file and commit history.

---

## Code Samples

### Using scriptblocks

Convert strings to scriptblock to generate code dynamically.

```powershell
$s = 'param ($Year = {0}) Get-Date -Year $Year' -f (Get-Date).Year
$s = [scriptblock]::Create($s)
$s.GetType()
```

---

### A faster way of filtering

The `.Where` filter method is around 3 to 4 times faster then using the Where-Object cmdlet. The downside is, that it does not support the pipeline in the same comfortable way as `Where-Object`.

```powershell
$a = 1..100000
Measure-Command { $a | Where-Object { $_ -eq 4000 } }                                                     
Measure-Command { $a.Where({ $_ -eq 4000 }) }
```

---

### String Quoting

Single and double quotes make a big difference, see [about_Quoting_Rules](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.3)

```powershell
$d = Get-Date
  $a = 50   
'$a = $a' 
"$a = $a" 
"`$a = $a"
"`$a = $a and the year is $($d.Year)"
```

Another way to format string is the `-f` operator, a shortcut to `[string]::Format()`.

```powershell
"Test{0:d4}" -f 50

"LogFile_{0:yyMMdd}.txt" -f (Get-Date)
[string]::Format("LogFile_{0:yyMMdd}.txt", (Get-Date))
```

[about_Operators](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.3)

[String.Format Method](https://learn.microsoft.com/en-us/dotnet/api/system.string.format?view=net-7.0)

---

### Operators

There are always more operators used than expected. The following line uses 10 operators:

```powershell
(dir -Path c:\ | Where-Object { $_.Length -gt\ 1mb}).Length
```

> This is because: In computer programming, operators are constructs defined within programming languages which behave generally like functions, but which differ syntactically or semantically (from Wikipedia article Operator (computer programming)](https://en.wikipedia.org/wiki/Operator_(computer_programming))).

More documentation on [about_Operators](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.3).

---

### PSCustomObject and custom views

PSCustomObject are the most effective way of creating objects on the fly that store your data in a structured way. 

[Everything you wanted to know about PSCustomObject](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7.3)

You can write your own custom view that will be applied whenever an object of the type you defined is put on the pipeline. The type name defined in the view must match the type of the object. You can change the type name of a PSCustomObject like this:

```powershell
$o = [pscustomobject]@{
    Name = 'Test1'
    Value = 'Value1'
}

$o.psobject.TypeNames.Insert(0, 'MyType')

$o | Get-Member
```

The result is 

```
   TypeName: MyType

Name        MemberType   Definition                    
----        ----------   ----------                    
Equals      Method       bool Equals(System.Object obj)
GetHashCode Method       int GetHashCode()             
GetType     Method       type GetType()                
ToString    Method       string ToString()             
Name        NoteProperty string Name=Test1             
Value       NoteProperty string Value=Value1           
```

> Note the type name.

Examples for a custom views:
- [NTFSSecurity.types.ps1xml](
https://github.com/raandree/NTFSSecurity/blob/master/NTFSSecurity/NTFSSecurity.types.ps1xml)
- [GenericMeasureInfo.format.ps1xml](https://gist.github.com/raandree/bf804ad22eff23bef38e9b6d07f9030a)

-----------

### ValueFromPipeline

A very simple demo for `ValueFromPipeline`.

```powershell
function Test
{
    param(
        [Parameter(ValueFromPipeline)]
        [int[]]$i
    )
    
    begin {
        Write-Host Beginning
    }
    
    process {
        if ($i.Count -eq 1)
        {
            Write-Host $i
        }
        else
        {
            foreach ($j in $i)
            {
                Write-Host $j
            }
        }
    }
    
    end {
        Write-Host finished.
    }
}

Test -i (1..10)
11..20 | Test
```

> Note: The function can be called using the pipeline as well as parameters given the foreach-loop

------------

### Foreach loops

The loop with the `foreach`-keyword is faster then the `ForEach-Object` cmdlet but lacks pipeline support. Additionally, the `foreach`-keyword supports the `continue` and `break` keyword, whereas the `ForEach-Object` cmdlet only supports `break`.

```powershell
$chars = 'a', 'b', 'c'
$numbers = 1, 2, 3

<# Exprected output
        a - 1
        a - 2
        ...
        c - 2
        c - 3
#>

foreach ($char in $chars)
{
    if ($char -eq 'b')
    {
        continue #only available in foeach keyword loop
    }
    
    foreach ($number in $numbers)
    {
        "$char - $number"
    }
}

$chars | ForEach-Object {
    $temp = $_
    $numbers | ForEach-Object {
        "$temp - $_"
    }
}
```

---

### Member Access Enumeration

Starting in PowerShell 3.0, the member-access enumeration feature improves the convenience of using the member-access operator (`.`) on list collection objects.

```powershell
(Get-Process | Select-Object -First 5) | ForEach-Object { $_.Threads } | ForEach-Object { $_.StartTime.Minute }

(Get-Process | Select-Object -First 5).Threads.StartTime.Minute

#There is always a count property
(5).Count
```

----

### Function OutputType

PowerShell functions do not have, unlike C# or Java, a dedicated return type, they emit whatever data is not consumed within the function.

In C# this function can only return an integer and you get a compilation error if not.

```c#
public int Add(int i1, int i2)
{
    return i1 + i2
}
```

In PowerShell, the function should return an integer, but PowerShell isn't enforcing this.

```powershell
function Add
{
    [OutputType([int])]
    param (
        [int]$i1,
        [int]$i2
    )
    Get-Date
    $i1 + $i2
    Write-Host $i1 + $i2 #this is not part of the output and only written to the console
    $al = New-Object System.Collections.ArrayList
    $al.Add(1) | Out-Null
    $null = $al.Add(2)
    [void]($al.Add(3))
}

$result = Add -i1 8 -i2 3
$result.Count #Contains two items
```

> Note: The [OutputType Attribute](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_outputtypeattribute?view=powershell-7.3) is not enforces and only for the users information and comfort. It can also take a list of types.  

---

### Array Performance

The `+=` operator is very slow when adding thousands of object to an array, as explained in [PowerShell scripting performance considerations](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/script-authoring-considerations?view=powershell-7.3#array-addition).

```powershell
$items = 1..100000
$list = [System.Collections.ArrayList]::new() #@()

$items | ForEach-Object {
    #$list += "Test $_"
    [void]$list.Add("Test $_")
}
```

---

### Should Process

This is perfectly explained in [Everything you wanted to know about ShouldProcess](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.3).

```powershell
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
                Write-Host "Would have removed computer '$name'."
            }
        }
    }
}

$c = Get-Computer -ComputerName Server1
$c | Remove-Computer #-Confirm:$false
```

---

### Reference Types vs. Value Types

In .net, all classes are reference types, all structs are value types.
structs are value types. It requires some extra code to create a copy of a reference type like [DeepCopy-Object](https://github.com/microsoft/PowerShellForGitHub/blob/9ec863b14277a524aa8f2931b742bb3dfed10d5a/Helpers.ps1#L363).

Changing a value in an array changes the value of the false copy as well:

```powershell
PS D:\> $a = 1,2,3

PS D:\> $b = $a

PS D:\> $b[0] = 5

PS D:\> $b
5
2
3

PS D:\> $a
5
2
3
```

---

### Error handling

`Try`, `catch` requires terminating exceptions (`-ErrorAction Stop`). Most cmdlets do not throw terminating errors, hence the script will never jump into the catch block.

There can be multiple catch blocks if the code in the try-block throws different exceptions depending on the error.

The article [about_Try_Catch_Finally](https://superuser.com/questions/1535816/why-do-commands-in-try-catch-sometimes-need-erroraction-stop-and-sometimes-not) explains the details.

```powershell
try
{
    $s = New-CimSession -ComputerName localhost123 -ErrorAction Stop 
}
catch [Microsoft.Management.Infrastructure.CimException] {
    Write-Error -Message "Something went wrong. The error was: $($_.Exception.Message)" -Exception $_.Exception
}
catch [System.Management.Automation.ParameterBindingException] {
    Write-Error 'Please read the docs'
}
catch {
    Write-Error 'Something unknown went wrong'
}
```

Errors can also be ignored and the return value is checked instead.

```powershell
$s = New-CimSession -ComputerName localhost123 -ErrorAction Ignore
if (-not $s)
{
    Write-Error "Connection to 'localhost123' could not be created."
}
```

---


### Custom Error Exceptions

PowerShell supports to add .net types with the `Add-Type` cmdlet. It could be used to add a custom exception class that stores additional data.

[Custom Error Class](./assets/IxException.cs)

```powershell
Add-Type -Path .\assets\IxException.cs
```

--------------

### Splatting

Splatting is a method of passing a collection of parameter values to a command as a unit. PowerShell associates each value in the collection with a command parameter. More information in [about_Splatting](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-7.3).

Spatting can massively reduce the complexity in your code when used correctly.

The function `Stop-IxComputer` without splatting:

```powershell
function Stop-IxComputer {
    param (
        [Parameter(Mandatory)]
        [string]$ComputerName,
        
        [pscredential]$Credential,
        
        [switch]$UseSsl
    )
    
    if ($Credential)
    {
        if ($UseSsl)
        {
            Invoke-Command -ComputerName $ComputerName -Credential $Credential -UseSSL -ScriptBlock {
                Stop-Computer
            }
        }
        else
        {
            Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
                Stop-Computer
            }
        }
    }
    else
    {
        if ($UseSsl)
        {
            Invoke-Command -ComputerName $ComputerName -UseSSL -ScriptBlock {
                Stop-Computer
            }
        }
        else
        {
            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                Stop-Computer
            }
        }
    }

}

Stop-IxComputer -ComputerName abc -UseSsl
```

The same function with splatting is much shorter and simpler:

```powershell
function Stop-IxComputer {
    param (
        [Parameter(Mandatory)]
        [string]$ComputerName,
        
        [pscredential]$Credential,
        
        [switch]$UseSsl
    )
    
    $param = $PSBoundParameters
    $param.ScriptBlock = {
        Stop-Computer
    }
    
    Invoke-Command @param

}

Stop-IxComputer -ComputerName abc -UseSsl
```

---

### Static Class Members

Not all .NET Framework classes can be created using New-Object. For example, if you try to create a System.Environment or a System.Math object with New-Object, you will get the following error messages:

```powershell 
New-Object System.Environment
```

```
New-Object : Constructor not found. Cannot find an appropriate constructor for
type System.Environment.
At line:1 char:11
+ New-Object  <<<< System.Environment
```

More information in the article [Using static classes and methods](https://learn.microsoft.com/en-us/powershell/scripting/samples/using-static-classes-and-methods?view=powershell-7.3).

Another demo of defining a class with a static member in C#, adding it to PowerShell and accessing its instance and static members:

```powershell
Add-Type -Path .\assets\Car.cs

#Accessing the static member 'MaxSpeed'
[Car.Car]::MaxSpeed

$car1 = New-Object Car.Car
$car1.Manufacturer = 'VW'
$car1.Model = 'Golf'
$car1.Accelerate(210)
$car1

$car2 = New-Object Car.Car
$car2.Manufacturer = 'VW'
$car2.Model = 'Golf'
$car2.Accelerate(260)
$car2
```

Other .net standard classes that publish static members:

```powershell
$fo = New-Object System.IO.FileInfo('D:\temp.txt')
$fo.Create()

[System.IO.File]::Create('D:\temp.txt')

$a = Get-Process -Id 0

[System.Diagnostics.Process]::Start(
[System.Diagnostics.Process]::GetProcessById(0)

$math = New-Object System.Math
[System.Math]::...

$a = 2.55
[System.Math]::Round($a, 1)


$wi = [System.Security.Principal.WindowsIdentity]::GetCurrent()

$wi.Groups | ForEach-Object {
    $_.Translate([System.Security.Principal.NTAccount])
}

$dnsRecord = [System.Net.Dns]::GetHostByName($env:COMPUTERNAME)
$dnsRecord
```

---

### Remoting

- Invoke-Command vs. New-PSSession
- Send variables to a remote session
- Load Modules in a remote session
- Copy-Items between two computers

Simple remoting

```powershell
$computers = Get-ADComputer -Filter *
$result = Invoke-Command -ComputerName $computers.DnsHostName -ScriptBlock { Get-Date }
$result | Format-Table -Property PSComputerName, @{ Name = 'Date'; Expression = { $_ } }
```

---

Remoting runs by default in parallel (`-ThrottleLimit 32`). It is recommended not to use a foreach-loop around `Invoke-Command` as it moves from a parallel execution to a serial one.

```powershell
$computers = Get-ADComputer -Filter *
$param = @{
    ComputerName  = $computers.DnsHostName
    ScriptBlock   = { Get-Date }
    ErrorAction   = 'SilentlyContinue'
    ErrorVariable = 'connectionError'
}
$result = Invoke-Command @param

if ($connectionError) {
    Write-Error -Message "Could not reach computers: '$($connectionError.TargetObject -join ', ')'"
}

$result | Format-Table -Property PSComputerName, @{ Name = 'Date'; Expression = { $_ } }
```

#### Kerberos Authentication and the double-hop issue
PowerShell Remoting uses Kerberos by default. Another remote connection from a remote machine is not possible.

The following `dir` command should fail if the remove machine is not a domain controller or not enabled for Kerberos Delegation.

```powershell
$cred = Get-Credential contoso\install
Enter-PSSession -ComputerName dscfile02 -Credential $cred
dir -Path contoso.com\sysvol #throws Access Denied exception
```

If a double-hop authentication is required, refer to [Making the second hop in PowerShell Remoting](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/ps-remoting-second-hop?view=powershell-7.3).

---

#### Peristant Sessions

If you connect to a remote machine a number of times, consider a persistant session. It may increase the speed a lot:

```powershell
Measure-Command -Expression {
    1..10 | ForEach-Object {
        Invoke-Command -ComputerName dscfile02 -ScriptBlock { Get-Date }
    }
}

Measure-Command -Expression {
    $s = New-PSSession -ComputerName dscfile02
    1..10 | ForEach-Object {
        Invoke-Command -Session $s -ScriptBlock { Get-Date }
    }
    $s | Remove-PSSession
}
```


#### Sending files to remote machine via PowerShell remoting.

> Note: This approach is much slower than SMB but maybe the only option.

```powershell
$s = New-PSSession -ComputerName dscfile02
Copy-Item -Path C:\npp.8.5.1.Installer.x64.exe -Destination c:\ -ToSession $s
$s | Remove-PSSession
```

#### Sending Variables, Functions and Modules via a PSSession
[AutomatedLab.Common](https://github.com/AutomatedLab/AutomatedLab.Common) offers functions to send variables, functions and modules to remote sessions / machines.

```powershell
function f1 { 'Some Value' }
$s = New-PSSession -ComputerName dscfile02
$a = 'Test'
Add-VariableToPSSession -Session $s -PSVariable (Get-Variable -Name a)
Add-FunctionToPSSession -Session $s -FunctionInfo (Get-Command -Name f1)
Send-ModuleToPSSession -Session $s -Module (Get-Module -ListAvailable -Name NTFSSecurity) -Scope CurrentUser

Invoke-Command -Session $s -ScriptBlock {
    "The value of `$a is '$a'"
    $r = f1
    "Function f1 returned '$r'"
}

Invoke-Command -ComputerName dscfile02 -ScriptBlock {

    param (
        $P1,
        $P2,
        $P3
    )
    
    $PSBoundParameters | Out-String

} -ArgumentList v1, f1, v3
```

---

### The `PSDefaultParameterValues` feature

The `$PSDefaultParameterValues`` preference variable lets you specify custom default values for any cmdlet or advanced function. Cmdlets and advanced functions use the custom default value unless you specify another value in the command ([about_Parameters_Default_Values](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parameters_default_values?view=powershell-7.3)).

```powershell
$cred = Get-Credential contoso\install

$PSDefaultParameterValues = @{
    '*-AD*:Credntial' = $cred
}

$users = Get-ADUser -Filter * -ResultSetSize 10 #-Credential $cred 
$ous = Get-ADOrganizationalUnit -Filter * #-Credential $cred
```
----------------------

### Background Jobs and Thread Jobs

Windows PowerShell provides `*-Job` cmdlets that allow you to move work into background jobs. Background Jobs however are separate PowerShell processes and depending on the work you want to put into the background and the amount of jobs you need to create, it is recommended to use the module [ThreadJob](https://www.powershellgallery.com/packages/ThreadJob/2.0.3). `ThreadJobs` are running within the same PowerShell processes but in a new thread which makes them much more lightweight and efficient.  

For using `ThreadJobs`, you only have to replace the cmdlet `Start-Job` with `Start-ThreadJob`. The mechanics for both types are the same.

```powershell
$start = Get-Date
$jobs = 1..50 | ForEach-Object {
    Start-ThreadJob -ScriptBlock { #instead of 'Start-Job'
        Start-Sleep -Seconds 5
        Get-Date
    } -ThrottleLimit 20
}

Write-Host 'Waiting for jobs to complete...' -NoNewline
while ($jobs | Where-Object State -in 'Running', 'NotStarted')
{
    Write-OutPut . -NoNewline
    Start-Sleep -Milliseconds 200
}
Write-Host finished.

#$jobs | Wait-Job -Timeout 60
$result = $jobs | Receive-Job -AutoRemoveJob -Wait
$result

$end = Get-Date
"Runtime: $($end - $start)"
```

--------------

### Debugging

Breakpoints can be retreived and exported / imported with `Get-PSBreakpoint` and `Set-PSBreakpoint`.

```powershell
Get-PSBreakpoint | Export-Clixml -Path D:\breakpoints.xml
Import-Clixml -Path D:\breakpoints.xml | ForEach-Object { Set-PSBreakpoint -Line $_.Line -Script $_.Script }
```

> Note: This does not work in VSCode unless you are in the debugger.

---

### Schedules Jobs

PowerShell comes with two different ways of managing schedules tasks. The more classical approach is provided by the module `ScheduledTasks`. The module `PSScheduledJob` provides a way that is similar to background jobs / thread jobs. The details are described in [about_Scheduled_Jobs_Advanced](https://learn.microsoft.com/en-us/powershell/module/psscheduledjob/about/about_scheduled_jobs_advanced?view=powershell-5.1).

```powershell
Unregister-ScheduledJob Test1
Get-ScheduledJob
$t = New-JobTrigger -At 12:00 -DaysInterval 1 -Daily
Register-ScheduledJob -FilePath D:\Untitled2.ps1 -Name Test1 -Trigger $t

$accountId = 'NT AUTHORITY\SYSTEM'
$principal = New-ScheduledTaskPrincipal -UserId $accountId -LogonType ServiceAccount -RunLevel Highest

$psJobsPathInScheduler = '\Microsoft\Windows\PowerShell\ScheduledJobs'
if ($RunAsLocalSystem) {
    Set-ScheduledTask -TaskPath $psJobsPathInScheduler -TaskName Test1 -Principal $principal | Out-Null
}
```

---

### DSC

PowerShell Desired State Configuration (DSC) is a configuration management platform from Microsoft that enables administrators to automate the deployment and configuration of software and services on Windows-based systems. It uses a declarative language to define the desired state of a system, and then uses PowerShell to enforce that state. DSC can be used to configure local and remote systems, and can be used to manage both Windows and Linux systems.

DSC should not be used as just a new way of scripting. The whitepaper [The Release Pipeline Model](https://learn.microsoft.com/en-us/powershell/dsc/further-reading/whitepapers?view=dsc-1.1&viewFallbackFrom=powershell-6) summarizes the best DSC's role in a DevOps approach.

The DscWorkshop tries to tackle these problems:
- The most DSC approaches are ignoring the complexity of configuration data. It gets quickly unmanageable.
- Most concepts lack configuration data in a form that allows for exceptions, supports multiple levels of configuration and a free definition of how these levels interact with each other (does a higher level override a property or is it merged with the levels below).
- Usually there is no single build script that takes care about all steps required for a successful build, test, and release.
- Most solutions lack a concept for verifying the configuration data as well as the results after the configuration has been applied.

The DscWorkshop is a project template that implements the best practices and patterns learned by the [DSC Community](https://dsccommunity.org/) over the last 10 years. With this template, DSC goes from a framework to a solution. With this template, DSC moves from a framework to a solution that increases flexibility, robustness, and trust.

The tooling the DscWorkshop blueprint provides allows an easy integration into CI/CD release pipelines hosted on the common automation services like Azure DevOps, GitLab, GitHub or Jenkins. The configuration data management is no longer done as described in [Separating configuration and environment data](https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/separatingEnvData?view=powershell-7) but rather with [Datum](https://github.com/gaelcolas/Datum) that allows defining configuration data as a multi-layer YAML file structure.

The approach is explained in detail in the conference session [The DSC project blueprint or how to start a DSC project the right way](https://www.youtube.com/watch?v=SyYuxmiEgZ4).

Some additional key features are:
- Sophisticated configuration data management using Datum (similar to Puppet Hiera).
- A single build script that creates all artifacts (MOF, MetaMOF, Compressed Modules) by implementing the extensible PowerShell module templating solution [Sampler](https://github.com/gaelcolas/Sampler).
- Build and Release based on Azure DevOps Service or Azure DevOps Server. Manually triggered local builds do also work.
- Fully automated dependency management using [PSDepends](https://github.com/RamblingCookieMonster/PSDepend). No manual module / DSC resource download required.
- The concept works with on-prem Push and Pull or Azure Automation Account Pull, and [Azure Machine Configuration](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview).
- Support of maintenance windows.

The concept follows what is documented in the Microsoft white paper [The Release Pipeline Model](https://docs.microsoft.com/en-us/powershell/dsc/further-reading/whitepapers#the-release-pipeline-model). There is a series of exercises within the project repository that introduces the overall concept.

The [CommonTasks](https://github.com/dsccommunity/CommonTasks) repository is an essential part of this solution. It demonstrates how to provide configurations as building blocks that can be assigned to layers (roles, locations, nodes, etc.). For Microsoft365DSC the equivalent is [DscConfig.M365](https://github.com/raandree/DscConfig.M365).

Technologies / products / open-source tools involved are:

-	Azure DevOps, Azure DevOps Server
-	Azure DevOps Artifacts Feed
-	SQL Server 2019 and Reporting Services
-	Active Directory
-	Active Directory Certificate Services
-	JEA
-	PSDepend
-	InvokeBuild
-	Sampler
-	Pester
-	Datum

---

### Module Design and a Module Release Pipeline using [Sampler](https://github.com/gaelcolas/Sampler)

[Sampler](https://github.com/gaelcolas/Sampler) is a PowerShell module that provides a streamlined way to quickly create and manage projects. It provides a set of tools to help users quickly scaffold projects, create project templates, and manage project dependencies. It also provides a command-line interface to help users quickly set up and manage their projects. Sampler is designed to help users save time and effort when creating and managing projects, allowing them to focus on the actual project development.

Sampler covers
- ModuleBuilder (generate one module from various script files)
- Linting and Code Quality Checks
- Unit and Integration Testing and Code Coverage with Pester
- Automated Changelog Management
- Automated Versioning (GitVersion)
- Automated Deployment to an internal or external NuGet repository

During the workshop we have created the sample [raandreeSamplerTest1](https://github.com/raandree/raandreeSamplerTest1).

Additional resources:
- Setup a DSC Pull Server with SQL Database support (instead of local MDB / EDB database): [SetupDscPullServerSql.ps1](https://github.com/AutomatedLab/AutomatedLab/blob/develop/LabSources/PostInstallationActivities/SetupDscPullServer/SetupDscPullServerSql.ps1)
- When configures to use a SQL Server, the DSC Pull Server creates a database automatically given that the account has the required permissions. The database schema created is very minimal. A more sophisticated approach is part of AutomatedLab: [CreateDscSqlDatabase.ps1](https://github.com/AutomatedLab/AutomatedLab/blob/develop/LabSources/PostInstallationActivities/SetupDscPullServer/CreateDscSqlDatabase.ps1). This database schema can be used with 

---

### Regular Expressions

Regular expressions (also known as regex or regexp) are a powerful tool used for pattern matching and text processing. They are used to search for patterns within strings, and can be used to validate, extract, and replace text. Regular expressions are used to help make searching and manipulating strings more efficient and effective. They can be used to validate user input, search for patterns in large datasets, and perform complex text manipulations.

PowerShell implements Regular Expressions by means of the `-match` operator or the `[RegEx]` class.

To build Regular Expressions, use a tool like [regex101](https://regex101.com/).

The code sample extracts data from strings and passes this data as a PSCustomObject:

```powershell
$osList = 'Windows Server 2022 Datacenter (Desktop Experience)',
'Windows Server 2022 Datacenter',
'WindowsServer 2022 Datacenter',
'Windows 10 Professional',
'Windows 11 Enterprise',
'Windows 11'

$pattern = '^Windows (?<IsServer>Server )?(?<Version>\d{2,4}) (?<SKU>\w+)(?<IsDesktop> \(Desktop Experience\))?'
foreach ($os in $osList)
{
    if ($os -match $pattern) {
        #[pscustomobject]$Matches #Splat the $Matches variable in to a PSCustomObject
        [pscustomobject]@{
            IsServer = [bool]$Matches.IsServer
            IsServerWithGui = [bool]$Matches.IsDesktop
            Version = $Matches.Version
            SKU = $Matches.SKU
        }
    }
    else
    {
        Write-Warning "The string '$os' could not be parsed."
    }
}
```

> Note: Regular Expressions are not for every scenario like described in [Regular Expressions: Now You Have Two Problems](https://blog.codinghorror.com/regular-expressions-now-you-have-two-problems/).

Capturing groups (`()`) and non-capturing groups (`(?:)`)

```powershell
$osList[0] -match '(?:Windows Server)(?<Value>[\d\w\s]+)(?:Datacenter)'
$Matches.Value.Trim()
```

Gettings string from the event log message with a Regular Expression and the more effective way of accessing the `ReplacementStrings` array:

```powershell
$e = Get-EventLog -LogName system -InstanceId 2147489661 -Newest 1
$e.Message -match '\d+'
$Matches[0]
$e.ReplacementStrings[4]
```

---

### Logging with [PSFramework](https://psframework.org/)

PSFramework is a powerful and feature-rich PowerShell logging framework that provides a consistent and reliable way to log events in PowerShell. It allows you to easily create log entries with a variety of levels, such as error, warning, information, and verbose. It also provides a way to easily filter and search log entries, and it supports both text-based and structured logging. Additionally, PSFramework supports a wide range of logging targets, including the Windows Event Log, text files, and the console.

```powershell
function f1
{
    Write-PSFMessage -Level Warning -Message '123' -Tag t1, t2
    $x = Get-Process
    Write-PSFMessage -Level Host -Message 'Doing some more work'
    Write-PSFMessage -Level Verbose -Message 'some more date' -Target m1
}

function f2
{
    $ex = [System.Exception]::new('Something went wrong')
    Write-PSFMessage -Level Error -Exception $ex -Message 'Some Error'
}

Set-PSFLoggingProvider -Name logfile -FilePath d:\log.csv -Enabled $true -EnableException
Set-PSFLoggingProvider -Name filesystem -EnableException -LogPath d:\
Set-PSFLoggingProvider -Name eventlog -Enabled $true

Write-PSFMessage -Level Host -Message 'Doing some work'
f1
f2
Write-PSFMessage -Level Host -Message 'Finished'
Wait-PSFMessage
```
