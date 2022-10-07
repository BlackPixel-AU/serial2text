# serial2text PS Script
# Created 28/10/2021

$txtfile = "C:\serial_text.txt" # <- Change text file location here #

$serial = WMIC BIOS GET SERIALNUMBER # get sn
$compname = Invoke-Expression hostname # get pc name

if([System.IO.File]::Exists($txtfile)){ # check file exists 
    Write-Host File Found.

    $search = (Get-Content $txtfile | Select-String -Pattern "$serial").Matches.Success # check for sn duplicate

    if($search){
        Write-Host "Serial number already in file!"
        $title    = 'Warning'
        $notice = 'Serial number already in file, do you want to add it again anyway?'

        $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
        $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

        $decision = $Host.UI.PromptForChoice($title, $notice, $choices, 1)
        if ($decision -eq 0) {
            Write-Host 'Proceeding...'
        } else {
            Write-Host 'Cancelled by user, exiting...'
            Start-Sleep 1
            exit
        }

    } else {
        "Serial number not in file, proceeding..."
    }

}else{
    Write-Host "File not present, generating one..."
}


Write-Host "Writing to: " $txtfile

"$compname - $serial" | out-file $txtfile -append # write to txt file

Write-Host "Done!"

# legacy duplication check #

#Write-Host ---------------

#Write-Host "Duplicates in file:"

#Get-Content $txtfile | Group-Object | Where-Object { $_.Count -gt 1 } | Select -ExpandProperty Name # Write-Host duplicates in txt file

start-sleep 3

# end