$qtype = $args[0]

if ($args.Count -lt 3) {
    echo "There is no arguments!"
    exit
}

switch ($qtype) {
    "pool" {
        $qparam = $args[1]
        $qid = $args[2]
        
        $sp = Get-StoragePool -UniqueId "{$qid}"
        if (-not $sp) {
            echo "Object not found!"
            exit
        }

        switch ($qparam) {
            "size" { echo ($sp.Size / 1 ) }
            "allocated" { echo ($sp.AllocatedSize / 1) }
            "opstatus" { echo $sp.OperationalStatus }
            "healthstatus" { echo $sp.HealthStatus }
        }

    }
    "enclosure" {
        $qparam = $args[1]
        $qid = $args[2]

        $en = Get-StorageEnclosure -UniqueId "$qid"

        if (-not $en) {
            echo "Object not found!"
            exit
        }

        switch ($qparam) {
            "firmware" { echo $en.FirmwareVersion }
            "slots" { echo $en.NumberOfSlots }
            "healthstatus" { echo $en.HealthStatus }
            "opstatus" { echo $en.OperationalStatus }
        }

    }
    "vdisks" {
        $qparam = $args[1]
        $qid = $args[2]

        $vd = Get-VirtualDisk -UniqueId "$qid"

        if (-not $vd) {
            echo "Object not found!"
            exit
        }

        switch ($qparam) {
            "storagepool" { 
                $sp = Get-StoragePool -VirtualDisk $vd
                echo $sp.FriendlyName
            }
            "size" { echo ($vd.Size / 1) }
            "writecachesize" { echo ($vd.WriteCacheSize / 1) }
            "istiered" { if ($vd.IsTiered) { echo 1 } else {echo 0 } }
            "ssdtiersize" { 
                if ($vd.IsTiered) { 
                    $StorageTiers = $vd  | Get-StorageTier
                    echo (($StorageTiers | Where-Object {$_.MediaType -eq 'SSD'}).Size / 1)

                } else {
                    echo 0
                }
             }

             "hddtiersize" {
                if ($vd.IsTiered) {
                    $StorageTiers = $vd  | Get-StorageTier
                    echo (($StorageTiers | Where-Object {$_.MediaType -eq 'HDD'}).Size / 1)
                } else {
                    echo 0
                }
             }

             "opstatus" { echo $vd.OperationalStatus }
             "healthstatus" { echo $vd.HealthStatus }
             "resiliency" { echo $vd.ResiliencySettingName }
             "datacopyes" { echo $vd.NumberOfDataCopies }
             "columns" { echo $vd.NumberofColumns }

        }

    }
    "pdisks" {
        $qparam = $args[1]
        $qid = $args[2]

        $pd = Get-PhysicalDisk -UniqueId "$qid"

        if ($qparam -in ("readlatency","writelatency","readerrors","writeerrors","poweronhours","temperature","temperaturemax")) {
            $opsdata = Get-StorageReliabilityCounter -PhysicalDisk $pd
        }
        

        if (-not $pd) {
            echo "Object not found!"
            exit
        }

        switch ($qparam) {
            "manufacturer" { echo $pd.Manufacturer }
            "model" { echo $pd.Model }
            "slot" { echo $pd.SlotNumber }
            "enclosureid" { 
                $findstrg = $pd.PhysicalLocation -match '[0-9a-z]{16}'
                $EnslosureID = $matches[0]
                echo ($EnslosureID)
             }
            "mediatype" { echo $pd.MediaType }
            "size" { echo ($pd.Size / 1) }
            "firmware" { echo $pd.FirmwareVersion }
            "usage" { echo $pd.Usage }
            "opstatus" { echo $pd.OperationalStatus }
            "healthstatus" { echo $pd.HealthStatus }
            "readlatency" { echo $opsdata.ReadLatencyMax }
            "writelatency" { echo $opsdata.WriteLatencyMax }
            "readerrors" { if ( $opsdata.ReadErrorsTotal -eq 0 -Or $opsdata.ReadErrorsTotal -gt 0 ) { echo $opsdata.ReadErrorsTotal } else { echo 0 } }
            "writeerrors" { if ( $opsdata.WriteErrorsTotal -eq 0 -Or $opsdata.WriteErrorsTotal -gt 0 ) { echo $opsdata.ReadErrorsTotal } else { echo 0 } }
            "poweronhours" { echo $opsdata.PowerOnHours }
            "temperature" { echo $opsdata.Temperature }
            "temperaturemax" { echo $opsdata.TemperatureMax }
        }

    }

    default {
        echo "Query type is not walid!"
        exit
    }
}