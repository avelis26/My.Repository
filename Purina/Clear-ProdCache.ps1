admin
iL0v3Ansira
$urls = @{
	url1 = 'http://ec2-50-16-123-85.compute-1.amazonaws.com/c.php';
	url2 = 'http://ec2-54-158-156-77.compute-1.amazonaws.com/c.php';
	url3 = 'http://ec2-54-163-103-255.compute-1.amazonaws.com/c.php';
	url4 = 'http://ec2-54-204-142-227.compute-1.amazonaws.com/c.php';
	url5 = 'http://ec2-54-211-139-102.compute-1.amazonaws.com/';
}
ForEach ($url in $urls) {
	Invoke-WebRequest -Uri $url
}
