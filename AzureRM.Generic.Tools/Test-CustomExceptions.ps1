<#
class MyEXCP1: System.Exception {
	$Emessage
	MyEXCP1([string]$msg) {
		$this.Emessage=$msg
	}
}
class MyEXCP2: System.Exception {
	$Emessage
	MyEXCP2([string]$msg){
		$this.Emessage=$msg
	}
}
#>
$var = 1
try {
	if ($var -eq 1) {
		throw [MyEXCP1]
	}
	if ($var -eq 2) {
		throw [MyEXCP2]
	}
}
catch [MyEXCP1] {
	Write-Error -Exception MyEXCP1 -Message "The first thing went wrong" -Category AuthenticationError -ErrorId 1 -RecommendedAction "Fix the first thing"
	Exit 1
}
catch [MyEXCP2] {
	Write-Error -Exception MyEXCP2 -Message "The second thing went wrong" -Category ConnectionError -ErrorId 2 -RecommendedAction "Fix the second thing"
	Exit 2
}