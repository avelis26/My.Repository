Clear-Host
$apiKey = 'fc82f9f1916e4cb4856202622231907'
$zipCode = '65536'
$days = '1'
$uri = "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$zipCode&days=$days&aqi=no&alerts=no"
if (!$results) {
    Write-Host -ForegroundColor Green "Calling API..."
    $results = Invoke-RestMethod -Method Get -Uri $uri
}
$today = $results.forecast.forecastday[0].day.maxtemp_f
$tmrw = $results.forecast.forecastday[1].day.maxtemp_f
switch ($true) {
    { $tmrw -gt $today } { Write-Host -ForegroundColor Red "Tomorrow will be hotter than today" }
    { $tmrw -eq $today } { Write-Host -ForegroundColor Gray "Tomorrow will be equal to today" }
    { $tmrw -lt $today } { Write-Host -ForegroundColor Blue "Tomorrow will be colder than today" }
}