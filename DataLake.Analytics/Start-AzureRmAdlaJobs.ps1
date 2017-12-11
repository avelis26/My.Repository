Function Start-AzureDataLakeAnalyticsJobs {
	[CmdletBinding()]
	Param(
		# startDate and endDate will be included in processing
		# Month and Day must be 2 digit and follow format mm-dd-yyyy
		[string]$startDate = '02-15-2017',
		[string]$endDate = '02-15-2017',
		# Number of nodes to commit to job
		[int]$parallel = 83,
		# NO CHANGES BELOW THIS LINE ARE NEEDED
		[int]$alter = 3,
        [string]$tempRoot = 'c:\temp\',
		[string]$subId = 'da908b26-f6f8-4d61-bf60-b774ff3087ec',
		[string]$adla = 'mscrmprodadla',
		[switch]$aggregate,
		[switch]$structure
	)
	Function Confirm-Run {
		Param(
			[string]$jobType
		)
		Write-Host '********************************************************************' -ForegroundColor Magenta
		Write-Host "Start Date    :: $startDate"
		Write-Host "End Date      :: $endDate"
		Write-Host "Nodes Per Job :: $parallel"
		Write-Host "Job Type      :: $jobType"
		Write-Host '********************************************************************' -ForegroundColor Magenta
        $ignore = Read-Host -Prompt "Did you copy the new script files? (y/n)"		
        $answer = Read-Host -Prompt "Are you sure you want to kick off $($range*3) jobs? (y/n)"
		Return $answer
	}
	$startDateObj = Get-Date -Date $startDate
	$endDateObj = Get-Date -Date $endDate
	[int]$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
	$continue = $null
	If ($aggregate -eq $true) {
		$usqlRootPath = 'C:\Scripts\USQL\Aggregate\'
		$continue = Confirm-Run -jobType 'Aggregate'
	}
	ElseIf ($structure -eq $true) {
		$usqlRootPath = 'C:\Scripts\USQL\Structure\'
		$continue = Confirm-Run -jobType 'Structure'
	}
	Else {
		$missingSwitchError = New-Object System.SystemException "Please choose either Aggregate or Structure switch!!!"
		Throw $missingSwitchError
	}
	$scripts = Get-ChildItem -Path $usqlRootPath -File
	$i = 0
	$x = $i
    $user = 'gpink003@7-11.com'
    $password = ConvertTo-SecureString -String $(Get-Content -Path 'C:\Users\graham.pinkston\Documents\Secrets\op1.txt')
	If ($continue -eq 'y') {
		Try {
			Import-Module AzureRM -ErrorAction Stop
			Get-AzureRmContext
            $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
			Login-AzureRmAccount -SubscriptionId $subId -Credential $credential -ErrorAction Stop
			Set-AzureRmContext -Subscription $subId
            If (!(Test-Path -LiteralPath $tempRoot)) {
			    Write-Verbose -Message "Creating folder:  $tempRoot ..."
			    New-Item -ItemType Directory -Path $tempRoot -Force
		    }
			$endDay = $endDateObj.Day.ToString("00")
			$endMonth = $endDateObj.Month.ToString("00")
			$endYear = $endDateObj.Year.ToString("0000")
			$endWhile = $endYear + $endMonth + $endDay
			$processDate = 'start'
			While ($processDate -ne $endWhile) {
				$day = $($startDateObj.AddDays($i)).day.ToString("00")
				$month = $($startDateObj.AddDays($i)).month.ToString("00")
				$year = $($startDateObj.AddDays($i)).year.ToString("0000")
				$processDate = $year + $month + $day
				ForEach ($script in $scripts) {
					$x++
					$code = Get-Content -Path $script.FullName
					$code[$alter] = "DECLARE @datedFolder string = ""$processDate"";"
					$scratchPad = "$tempRoot$processDate-$($script.Name)"
					$code | Set-Content -Path $scratchPad -Force
					Write-Verbose "----------------------------------------------------------------"
					Write-Verbose "Starting job $x of $($range*3) :: $($script.BaseName + '-' +$processDate)..."
					$params = @{
						Account = $adla;
						Name = $($script.BaseName + '-' + $processDate);
						ScriptPath = $scratchPad;
						DegreeOfParallelism = $parallel
					}
					Submit-AdlJob @params
					Start-Sleep -Seconds 2
				}
				$i++
			}
		}
		Catch {
			$_
		}
	}
	Else {
		Write-Output 'Exiting...'
		Exit 0
	}
}
Start-AzureDataLakeAnalyticsJobs -structure -Verbose
