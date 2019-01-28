$tsvInput = @'
#	Time	Action	Message	Duration / Fetch
3	1	16:18:53	UPDATE `purina_profiles`.`breed` SET `image_path`='https://d1a5qjjt8mb7fh.cloudfront.net/api/breeds/dogs/kooikerhondjes2_stacked.jpg' WHERE `id`='714'	1 row(s) affected
 Rows matched: 1  Changed: 1  Warnings: 0	0.063 sec
3	2	16:18:53	INSERT INTO `breed` (`id`, `pet_type_id`, `key_name`, `name`, `image_path`) VALUES (NULL, '1', 'CURLY_COATED_RETRIEVER_2', 'Curly-Coated Retriever', 'https://d1a5qjjt8mb7fh.cloudfront.net/api/breeds/dogs/sporting_curly-coated-retriever.jpg')	1 row(s) affected	0.078 sec
3	3	16:18:53	INSERT INTO `breed` (`id`, `pet_type_id`, `key_name`, `name`, `image_path`) VALUES (NULL, '1', 'SPINONE_ITALIANO_2', 'Spinone Italiano', 'https://d1a5qjjt8mb7fh.cloudfront.net/api/breeds/dogs/sporting_spinone-italiano.jpg')	1 row(s) affected	0.062 sec
'@
$tsvInput = $tsvInput.Remove(0, 38)
$tsvObj = ConvertFrom-Csv -InputObject $tsvInput -Delimiter `t -Header 'Status', 'Row', 'Time', 'Action', 'Message', 'Duration'
$output = "||Action||Message||"
ForEach ($line in $tsvObj) {
	$output += "`r`n" + '|' + $line.Action + '|' + $line.Message + '|'
}
Set-Clipboard -Value $output