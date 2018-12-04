# Author - Joshua Button - U168860

$DocumentsBackup		     = [System.Convert]::ToBoolean($ConfigFile.Backup.Documents.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$MusicBackup				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Music.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$CustomBackup1			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder1.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$CustomBackup2			 	 = [System.Convert]::ToBoolean($ConfigFile.Backup.CustomFolder2.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$DesktopBackup 				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Desktop.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$VideosBackup				 = [System.Convert]::ToBoolean($ConfigFile.Backup.Videos.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.
$PicturesBackup 			 = [System.Convert]::ToBoolean($ConfigFile.Backup.Pictures.toBackup) #Pulls checked status from Config file. XML can only store strings so it converts it to a boolean.

$CustomPath1                 = $ConfigFile.Backup.CustomFolder1.path #Pulls custom folder string from XML file
$CustomPath2                 = $ConfigFile.Backup.CustomFolder2.path #Pulls custom folder string from XML file
$DocumentsPath 				 = [environment]::getfolderpath("mydocuments")
$MusicPath 					 = [environment]::getfolderpath("mymusic")
$DesktopPath 				 = [environment]::getfolderpath("desktop")
$VideosPath 				 = [environment]::getfolderpath("myvideos")
$PicturesPath 				 = [environment]::getfolderpath("mypictures")

#https://redmondmag.com/articles/2016/01/15/for-each-loop-in-powershell.aspx

$toBackUpList 				 = @($DocumentsBackup, $DocumentsPath, 
								$MusicBackup, $MusicPath,
								$PicturesBackup, $PicturesPath,
								$VideosBackup, $VideosPath,
								$DesktopBackup, $DesktopPath,
								$CustomBackup1, $CustomPath1,
								$CustomBackup2, $CustomPath2
								) 

$backupTrue = $false
foreach ($item in $toBackUpList)
{
	if ($item -ne $true -and $item -ne $false)
	{
		if ($backupTrue -eq $true)
		{
			Write-Host '3'$item
			Write-Host '3'$backupTrue
			Compress-Archive -Path $item -Update -DestinationPath $item"\backup.zip"
			$backupTrue = $false
		}
	}
	if ($item -eq $true) 
	{
		$backupTrue = $true
	}
}

#DIALOG BOX
#[System.Windows.Forms.Messagebox]::Show("$DocumentsBackup`n$MusicBackup`n$PicturesBackup`n$VideosBackup`n$DesktopBackup",[System.Windows.Forms.MessageBoxButtons]::OKCancel)
#
#USB DRIVE CHECK CODE##
#
#do {
#  	$UsbDisk = gwmi win32_diskdrive | ?{$_.interfacetype -eq "USB"} | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"} |  %{gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"} | %{$_.deviceid} 
#	if ( $UsbDisk -eq $null ) {  
#		pause("Press any key to search again!")
#		# DO NOT RUN THIS WITHOUT SOME SORT OF "PAUSE" function, otherwise this will loop until a USB stick is inserted.
#	}
#}
#while ($UsbDisk -eq $null)
#
# After the do loop, $UsbDisk will be the name of the drive letter (example: E:)