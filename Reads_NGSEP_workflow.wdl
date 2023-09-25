version 1.0

workflow PairReadsProccessing{
    input{
        File barcodeMap
        File rawdataPaths
    }
    call get_rawdata{
        input: rawdata_list = rawdataPaths
    }
    scatter(i in get_rawdata.rawdata){
        call Demultiplexing {
            input: rawreads=i, barcodes=barcodeMap
        }
    }
    output{
        Array[String] print=get_rawdata.rawdata
        File outada = write_json(print)
    }
    
}

task Demultiplexing{
    input{
        File rawreads
        File barcodes
    }
    command <<<
       NGSEPcore.jar Demultiplex -i '~{barcodes}' -f '~{rawreads}'
    >>>
    output{
        File demultiplex =stdout()
    }
    runtime{
        docker: "duartetorreserick/ngsepcore-image"
    }
}

task get_rawdata{
    input{
    File rawdata_list
    }
    command{
        cat ${rawdata_list}
    }
    output{
        Array[String] rawdata=read_lines(stdout())
    }
}