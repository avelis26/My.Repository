$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'
$file = 'C:\tmp\test.csv'
$database = '7ELE'
$schema = 'dbo'
$table = 'test'
$user = 'sqladmin'
$pass = 'Password20!7!'
$server = 'mstestsqldw.database.windows.net'
$command = "bcp $table in $file -S $server -d $database -U $user -P $pass -q -c -t ',' -F 2"
Write-Debug -Message $command
Invoke-Expression -Command $command -Verbose