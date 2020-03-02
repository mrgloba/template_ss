$dtype = $args[0]


switch ($dtype) {
    "pool" {
        $StoragePools = Get-StoragePool | Where-Object {$_.FriendlyName -ne 'Primordial'}

        echo "{`n `"data`":[`n"
        foreach ($sp in $StoragePools) {
            $line = "{ `n`"{#POOL}`":`"" + $sp.FriendlyName + "`",`n`"{#PDN}`":`"" + $($sp.UniqueId -replace '[{}]') + "`",`n`"{#PH}`":`"0`"`n}`n,"
            echo $line
        }

        echo "{`n`"{#POOL}`":`"PLACEHOLDER`",`n`"{#PDN}`":`"PLACEHOLDER`",`n`"{#PH}`":`"1`"`n}`n"
        echo " ]`n}"
    }

    "enclosure" {
        $Enclosures = Get-StorageEnclosure | select *
        echo "{`n `"data`":[`n"
        foreach ($en in $Enclosures) {
            $line = "{ `n`"{#ENCLOSURE}`":`"" + $en.FriendlyName + "`",`n`"{#EDN}`":`"" + $en.UniqueId + "`",`n`"{#PH}`":`"0`"`n}`n,"
            echo $line    
        }
        echo "{`n`"{#ENCLOSURE}`":`"PLACEHOLDER`",`n`"{#EDN}`":`"PLACEHOLDER`",`n`"{#PH}`":`"1`"`n}`n"
        echo " ]`n}"    
    }
    
    "vdisks" {
        $StoragePools = Get-StoragePool
        echo "{`n `"data`":[`n"
        foreach ($sp in $StoragePools)
        {
            $VirtualDisks = Get-VirtualDisk -StoragePool $sp
            foreach ($vd in $VirtualDisks)
            {
           
                $line = "{ `n`"{#VDISK}`":`"" + $vd.FriendlyName + "`",`n`"{#VDN}`":`"" + $vd.UniqueId + "`",`n`"{#PH}`":`"0`"`n}`n,"
                echo $line
            }      

        }  

        echo "{`n`"{#VDISK}`":`"PLACEHOLDER`",`n`"{#VDN}`":`"PLACEHOLDER`",`n`"{#PH}`":`"1`"`n}`n"
        echo " ]`n}"     
    }

    "pdisks" {
        $pdisks = Get-PhysicalDisk | where {($_.canpool) -or ($_.CannotPoolReason -match 'In a Pool')}
        echo "{`n `"data`":[`n"
        foreach ($pd in $pdisks)
        {


            $line = "{ `n`"{#PDISK}`":`"" + $pd.SerialNumber + "`",`n`"{#PDN}`":`"" + $pd.UniqueId + "`",`n`"{#PH}`":`"0`"`n}`n,"
            echo $line

        }
        echo "{`n`"{#PDISK}`":`"PLACEHOLDER`",`n`"{#PH}`":`"1`"`n}`n"
        echo " ]`n}"     
    }
}
    

