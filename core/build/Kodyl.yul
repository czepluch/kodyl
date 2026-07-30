object "KodylDeploy" {
  code {
    function usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$MemoryWordReader (ptr, currentHeadOffset) -> _result {
      let raw
      let _v0
      _v0 := usr$WordReader_advance$ABIDecoderLty_readerJ$address_MemoryWordReader(ptr, currentHeadOffset)
      let _v1
      _v1 := usr$WordReader_read$ABIDecoderLty_readerJ$address_MemoryWordReader(_v0)
      raw := _v1
      let _v2
      _v2 := usr$shr(160, raw)
      let _v3
      _v3 := usr$Eq_eq$word(_v2, 0)
      usr$require(_v3, false, 2092978087, 911)
      let _v4
      _v4 := usr$Typedef_abs$address(raw)
      _result := _v4
      leave
    }
    function usr$Add_add$word (l, r) -> _result {
      let _v5
      _v5 := usr$addWord(l, r)
      _result := _v5
      leave
    }
    function usr$Assign_assign$a$storageLaddressJ_address (l, r) {
      usr$CanStore_store$storageLaddressJ(l, r)
      leave
    }
    function usr$CanStore_store$storageLaddressJ (l, r) {
      let _v6
      _v6 := usr$Typedef_rep$storageLtJ$address(l)
      usr$StorageType_store$address(_v6, r)
      leave
    }
    function usr$Eq_eq$word (x, y) -> _v7 {
      let _v8
      _v8 := usr$eqWord(x, y)
      _v7 := _v8
      leave
    }
    function usr$HasWordReader_getWordReader$memoryLbytesJ (x) -> _result {
      let _v9
      _v9 := usr$Typedef_rep$memoryLtJ$bytes(x)
      _result := _v9
      leave
    }
    function usr$StorageType_store$address (ptr, value) {
      let _v10
      _v10 := usr$Typedef_rep$address(value)
      usr$StorageType_store$word(ptr, _v10)
      leave
    }
    function usr$StorageType_store$word (ptr, value) {
      usr$sstore(ptr, value)
      leave
    }
    function usr$Typedef_abs$address (x) -> _result {
      _result := x
      leave
    }
    function usr$Typedef_rep$address (x) -> _result {
      _result := x
      leave
    }
    function usr$Typedef_rep$memoryLtJ$bytes (x) -> _result {
      _result := x
      leave
    }
    function usr$Typedef_rep$memoryLtJ$string (x) -> _result {
      _result := x
      leave
    }
    function usr$Typedef_rep$storageLtJ$address (x) -> _result {
      _result := x
      leave
    }
    function usr$WordReader_advance$ABIDecoderLty_readerJ$address_MemoryWordReader (decoder, offset) -> _result {
      let _v11
      _v11 := usr$WordReader_advance$MemoryWordReader(decoder, offset)
      _result := _v11
      leave
    }
    function usr$WordReader_advance$MemoryWordReader (reader, offset) -> _result {
      let _v12
      _v12 := usr$Add_add$word(reader, offset)
      _result := _v12
      leave
    }
    function usr$WordReader_read$ABIDecoderLty_readerJ$address_MemoryWordReader (decoder) -> _result {
      let _v13
      _v13 := usr$WordReader_read$MemoryWordReader(decoder)
      _result := _v13
      leave
    }
    function usr$WordReader_read$MemoryWordReader (reader) -> _result {
      let _v14
      _v14 := usr$mload(reader)
      _result := _v14
      leave
    }
    function usr$_start () {
      mstore(64, memoryguard(128))
      if lt(codesize(), datasize("KodylDeploy")) {revert(0, 0)}
      if callvalue() {mstore(0, 3046674083)
                      revert(28, 4)}
      let _v15
      let _v16
      _v16 := usr$copy_arguments_for_constructor()
      _v15 := _v16
      usr$invokable_invoke$t_init_774970(_v15)
      let size := datasize("Kodyl")
      codecopy(0, dataoffset("Kodyl"), datasize("Kodyl"))
      return(0, size)
    }
    function usr$abi_decode$memoryLbytesJ_address_MemoryWordReader_address (decodable) -> _result {
      let _v17
      let _v18
      _v18 := usr$HasWordReader_getWordReader$memoryLbytesJ(decodable)
      _v17 := _v18
      let _v19
      _v19 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$MemoryWordReader(_v17, 0)
      _result := _v19
      leave
    }
    function usr$add (a, b) -> _result {
      let res
      res := add(a, b)
      _result := res
      leave
    }
    function usr$addWord (l, r) -> _result {
      let _v20
      _v20 := usr$add(l, r)
      _result := _v20
      leave
    }
    function usr$copy_arguments_for_constructor () -> _result {
      let _v21
      let memoryDataOffset
      let programSize := datasize("KodylDeploy")
      let argSize := sub(codesize(), programSize)
      memoryDataOffset := mload(64)
      mstore(64, add(memoryDataOffset, argSize))
      codecopy(memoryDataOffset, programSize, argSize)
      let _v22
      _v22 := memoryDataOffset
      let _v23
      _v23 := usr$abi_decode$memoryLbytesJ_address_MemoryWordReader_address(_v22)
      _v21 := _v23
      _result := _v21
      leave
    }
    function usr$eq (a, b) -> _result {
      let res
      res := eq(a, b)
      _result := res
      leave
    }
    function usr$eqWord (x, y) -> _v24 {
      let _v25
      _v25 := usr$eq(x, y)
      let _v26
      _v26 := usr$tobool(_v25)
      _v24 := _v26
      leave
    }
    function usr$get_free_memory () -> _result {
      let _v27
      _v27 := usr$mload(64)
      _result := _v27
      leave
    }
    function usr$init_ (maintainer_) {
      let _v28
      let _v29
      _v29 := usr$Typedef_rep$address(maintainer_)
      let _v30
      _v30 := usr$Eq_eq$word(_v29, 0)
      _v28 := _v30
      switch _v28
        case false {}
        case true {usr$revertStr1(3276808962, 12, 40887397721084264092108329832772105599086794631758206071443851012543883509760)}
      usr$Assign_assign$a$storageLaddressJ_address(0, maintainer_)
    }
    function usr$invokable_invoke$t_init_774970 (arg774972) {
      let _v31
      _v31 := arg774972
      usr$init_(_v31)
      leave
    }
    function usr$mload (a) -> _result {
      let res
      res := mload(a)
      _result := res
      leave
    }
    function usr$mstore (a, b) { mstore(a, b) }
    function usr$not (_v32) -> _v33 {
      switch _v32
        case false {_v33 := true
                    leave}
        case true {_v33 := false
                   leave}
    }
    function usr$require (_v34, _v35, _v36, _v37) {
      let _v38
      let _v39
      _v39 := usr$not(_v34)
      _v38 := _v39
      switch _v38
        case false {}
        case true {usr$revertWithError(_v35, _v36, _v37)}
    }
    function usr$revertStr1 (sel, len, w0) {
      let p
      let _v40
      _v40 := usr$get_free_memory()
      p := _v40
      usr$mstore(p, sel)
      let _v41
      _v41 := usr$Add_add$word(p, 32)
      usr$mstore(_v41, 32)
      let _v42
      _v42 := usr$Add_add$word(p, 64)
      usr$mstore(_v42, len)
      let _v43
      _v43 := usr$Add_add$word(p, 96)
      usr$mstore(_v43, w0)
      let _v44
      _v44 := usr$Add_add$word(p, 28)
      usr$revert_(_v44, 100)
    }
    function usr$revertWithError (_v45, _v46, _v47) {
      switch _v45
        case false {usr$mstore(0, _v46)
                    usr$revert_(28, 4)}
        case true {switch _v46
                     case false {usr$revert_(0, 0)}
                     case true {let msg_
                                let _v48
                                _v48 := usr$Typedef_rep$memoryLtJ$string(_v47)
                                msg_ := _v48
                                let _v49
                                _v49 := usr$Add_add$word(msg_, 32)
                                let _v50
                                _v50 := usr$mload(msg_)
                                usr$revert_(_v49, _v50)}}
    }
    function usr$revert_ (a, b) { revert(a, b) }
    function usr$shr (a, b) -> _result {
      let res
      res := shr(a, b)
      _result := res
      leave
    }
    function usr$sstore (a, b) { sstore(a, b) }
    function usr$tobool (x) -> _v51 {
      switch x
        case 0 {_v51 := false
                leave}
      default {_v51 := true
               leave}
    }
    usr$_start()
  }
  object "Kodyl" {
    code {
      function usr$__strlit_6 () -> _result {
        let p
        p := mload(64)
        mstore(p, 39)
        mstore(add(p, 32), 30477106892176362553526263225394298383959468819133800297929437971225195342190)
        mstore(add(p, 64), 14655040199316904820848530892847058275391897890470469465131138761810147016704)
        mstore(64, add(p, 96))
        _result := p
        leave
      }
      function usr$__strlit_5 () -> _result {
        let p
        p := mload(64)
        mstore(p, 30)
        mstore(add(p, 32), 30477106892176362553526263225394298383959468819133800330875011096155104018432)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$__strlit_2 () -> _result {
        let p
        p := mload(64)
        mstore(p, 19)
        mstore(add(p, 32), 30936501257503946468417235338555865335093964167246240734211252359372369559552)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$__strlit_8 () -> _result {
        let p
        p := mload(64)
        mstore(p, 23)
        mstore(add(p, 32), 30943589378177172661448681333301876517720025701657846299772998957559162339328)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$__strlit_7 () -> _result {
        let p
        p := mload(64)
        mstore(p, 24)
        mstore(add(p, 32), 30943589378177172661448681333301876517720025702210278305315773143978476568576)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$__strlit_4 () -> _result {
        let p
        p := mload(64)
        mstore(p, 29)
        mstore(add(p, 32), 31418774560093942245853067647636428571532538231315546774649129130877815619584)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$__strlit_3 () -> _result {
        let p
        p := mload(64)
        mstore(p, 26)
        mstore(add(p, 32), 31418774560093955145672949586624771581025301394720068236547710327342397128704)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$__strlit_1 () -> _result {
        let p
        p := mload(64)
        mstore(p, 15)
        mstore(add(p, 32), 37714105614416016935998082170447238770793777342373596859359559391151638183936)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$__strlit_0 () -> _result {
        let p
        p := mload(64)
        mstore(p, 12)
        mstore(add(p, 32), 40887397721084264092108329832772105599086794631758206071443851012543883509760)
        mstore(64, add(p, 64))
        _result := p
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let raw
        let _v52
        _v52 := usr$WordReader_advance$ABIDecoderLty_readerJ$address_CalldataWordReader(ptr, currentHeadOffset)
        let _v53
        _v53 := usr$WordReader_read$ABIDecoderLty_readerJ$address_CalldataWordReader(_v52)
        raw := _v53
        let _v54
        _v54 := usr$shr(160, raw)
        let _v55
        _v55 := usr$Eq_eq$word(_v54, 0)
        usr$require(_v55, false, 2092978087, 911)
        let _v56
        _v56 := usr$Typedef_abs$address(raw)
        _result := _v56
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLcalldataLarrayLbaseTypeJJ_CalldataWordReaderJ$address_address (ptr, currentHeadOffset) -> _result {
        let _v57
        let _v58
        _v58 := usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLaddressJJ_CalldataWordReader(ptr, currentHeadOffset)
        _v57 := _v58
        let dataOffset
        let _v59
        _v59 := usr$WordReader_read$ABIDecoderLty_readerJ$calldataLarrayLaddressJJ_CalldataWordReader(_v57)
        dataOffset := _v59
        let _v60
        let _v61
        _v61 := usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLaddressJJ_CalldataWordReader(ptr, dataOffset)
        _v60 := _v61
        let _v62
        let _v63
        _v63 := usr$getReader$calldataLarrayLaddressJJ_CalldataWordReader(_v60)
        _v62 := _v63
        let addr
        let _v64
        _v64 := usr$Typedef_rep$CalldataWordReader(_v62)
        addr := _v64
        let _v65
        _v65 := usr$Typedef_abs$calldataLtJ$arrayLaddressJ(addr)
        _result := _v65
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLcalldataLarrayLbaseTypeJJ_CalldataWordReaderJ$memoryLbytesJ_memoryLbytesJ (ptr, currentHeadOffset) -> _result {
        let _v66
        let _v67
        _v67 := usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLmemoryLbytesJJJ_CalldataWordReader(ptr, currentHeadOffset)
        _v66 := _v67
        let dataOffset
        let _v68
        _v68 := usr$WordReader_read$ABIDecoderLty_readerJ$calldataLarrayLmemoryLbytesJJJ_CalldataWordReader(_v66)
        dataOffset := _v68
        let _v69
        let _v70
        _v70 := usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLmemoryLbytesJJJ_CalldataWordReader(ptr, dataOffset)
        _v69 := _v70
        let _v71
        let _v72
        _v72 := usr$getReader$calldataLarrayLmemoryLbytesJJJ_CalldataWordReader(_v69)
        _v71 := _v72
        let addr
        let _v73
        _v73 := usr$Typedef_rep$CalldataWordReader(_v71)
        addr := _v73
        let _v74
        _v74 := usr$Typedef_abs$calldataLtJ$arrayLmemoryLbytesJJ(addr)
        _result := _v74
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLcalldataLarrayLbaseTypeJJ_CalldataWordReaderJ$uint256_uint256 (ptr, currentHeadOffset) -> _result {
        let _v75
        let _v76
        _v76 := usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLuint256JJ_CalldataWordReader(ptr, currentHeadOffset)
        _v75 := _v76
        let dataOffset
        let _v77
        _v77 := usr$WordReader_read$ABIDecoderLty_readerJ$calldataLarrayLuint256JJ_CalldataWordReader(_v75)
        dataOffset := _v77
        let _v78
        let _v79
        _v79 := usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLuint256JJ_CalldataWordReader(ptr, dataOffset)
        _v78 := _v79
        let _v80
        let _v81
        _v81 := usr$getReader$calldataLarrayLuint256JJ_CalldataWordReader(_v78)
        _v80 := _v81
        let addr
        let _v82
        _v82 := usr$Typedef_rep$CalldataWordReader(_v80)
        addr := _v82
        let _v83
        _v83 := usr$Typedef_abs$calldataLtJ$arrayLuint256J(addr)
        _result := _v83
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLmemoryLbytesJ_readerJ$CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let _v84
        _v84 := usr$decodeBytesLike$bytes_CalldataWordReader(ptr, currentHeadOffset)
        _result := _v84
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLmemoryLstringJ_readerJ$CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let _v85
        _v85 := usr$decodeBytesLike$string_CalldataWordReader(ptr, currentHeadOffset)
        _result := _v85
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$address_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJ_CalldataWordReader_address_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJ (ptr, currentHeadOffset) -> _v86, _v87, _v88, _v89 {
        let _v90
        _v90 := ptr
        let _v91
        _v91 := ptr
        let _v92
        let _v93
        _v93 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader(_v90, currentHeadOffset)
        _v92 := _v93
        let _v94
        let _v95
        let _v96
        let _v97
        _v97 := usr$Add_add$word(currentHeadOffset, 32)
        let _v98
        let _v99
        let _v100
        _v98, _v99, _v100 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLmemoryLbytesJ_memoryLbytesJJ_CalldataWordReader_uint256_pairLmemoryLbytesJ_memoryLbytesJJ(_v91, _v97)
        _v94 := _v98
        _v95 := _v99
        _v96 := _v100
        _v86 := _v92
        _v87 := _v94
        _v88 := _v95
        _v89 := _v96
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$calldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJ_CalldataWordReader_calldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJ (ptr, currentHeadOffset) -> _v101, _v102, _v103, _v104 {
        let _v105
        _v105 := ptr
        let _v106
        _v106 := ptr
        let _v107
        let _v108
        _v108 := usr$ABIDecode_decode$ABIDecoderLcalldataLarrayLbaseTypeJJ_CalldataWordReaderJ$address_address(_v105, currentHeadOffset)
        _v107 := _v108
        let _v109
        let _v110
        let _v111
        let _v112
        _v112 := usr$Add_add$word(currentHeadOffset, 32)
        let _v113
        let _v114
        let _v115
        _v113, _v114, _v115 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$calldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJ_CalldataWordReader_calldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJ(_v106, _v112)
        _v109 := _v113
        _v110 := _v114
        _v111 := _v115
        _v101 := _v107
        _v102 := _v109
        _v103 := _v110
        _v104 := _v111
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$calldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJ_CalldataWordReader_calldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJ (ptr, currentHeadOffset) -> _v116, _v117 {
        let _v118
        _v118 := ptr
        let _v119
        _v119 := ptr
        let _v120
        let _v121
        _v121 := usr$ABIDecode_decode$ABIDecoderLcalldataLarrayLbaseTypeJJ_CalldataWordReaderJ$memoryLbytesJ_memoryLbytesJ(_v118, currentHeadOffset)
        _v120 := _v121
        let _v122
        let _v123
        _v123 := usr$Add_add$word(currentHeadOffset, 32)
        let _v124
        _v124 := usr$ABIDecode_decode$ABIDecoderLcalldataLarrayLbaseTypeJJ_CalldataWordReaderJ$memoryLbytesJ_memoryLbytesJ(_v119, _v123)
        _v122 := _v124
        _v116 := _v120
        _v117 := _v122
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$calldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJ_CalldataWordReader_calldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJ (ptr, currentHeadOffset) -> _v125, _v126, _v127 {
        let _v128
        _v128 := ptr
        let _v129
        _v129 := ptr
        let _v130
        let _v131
        _v131 := usr$ABIDecode_decode$ABIDecoderLcalldataLarrayLbaseTypeJJ_CalldataWordReaderJ$uint256_uint256(_v128, currentHeadOffset)
        _v130 := _v131
        let _v132
        let _v133
        let _v134
        _v134 := usr$Add_add$word(currentHeadOffset, 32)
        let _v135
        let _v136
        _v135, _v136 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$calldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJ_CalldataWordReader_calldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJ(_v129, _v134)
        _v132 := _v135
        _v133 := _v136
        _v125 := _v130
        _v126 := _v132
        _v127 := _v133
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$memoryLbytesJ_memoryLbytesJ_CalldataWordReader_memoryLbytesJ_memoryLbytesJ (ptr, currentHeadOffset) -> _v137, _v138 {
        let _v139
        _v139 := ptr
        let _v140
        _v140 := ptr
        let _v141
        let _v142
        _v142 := usr$ABIDecode_decode$ABIDecoderLmemoryLbytesJ_readerJ$CalldataWordReader(_v139, currentHeadOffset)
        _v141 := _v142
        let _v143
        let _v144
        _v144 := usr$Add_add$word(currentHeadOffset, 32)
        let _v145
        _v145 := usr$ABIDecode_decode$ABIDecoderLmemoryLbytesJ_readerJ$CalldataWordReader(_v140, _v144)
        _v143 := _v145
        _v137 := _v141
        _v138 := _v143
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_address_CalldataWordReader_uint256_address (ptr, currentHeadOffset) -> _v146, _v147 {
        let _v148
        _v148 := ptr
        let _v149
        _v149 := ptr
        let _v150
        let _v151
        _v151 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v148, currentHeadOffset)
        _v150 := _v151
        let _v152
        let _v153
        _v153 := usr$Add_add$word(currentHeadOffset, 32)
        let _v154
        _v154 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader(_v149, _v153)
        _v152 := _v154
        _v146 := _v150
        _v147 := _v152
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_memoryLstringJ_CalldataWordReader_uint256_memoryLstringJ (ptr, currentHeadOffset) -> _v155, _v156 {
        let _v157
        _v157 := ptr
        let _v158
        _v158 := ptr
        let _v159
        let _v160
        _v160 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v157, currentHeadOffset)
        _v159 := _v160
        let _v161
        let _v162
        _v162 := usr$Add_add$word(currentHeadOffset, 32)
        let _v163
        _v163 := usr$ABIDecode_decode$ABIDecoderLmemoryLstringJ_readerJ$CalldataWordReader(_v158, _v162)
        _v161 := _v163
        _v155 := _v159
        _v156 := _v161
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJ_CalldataWordReader_uint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJ (ptr, currentHeadOffset) -> _v164, _v165, _v166, _v167, _v168 {
        let _v169
        _v169 := ptr
        let _v170
        _v170 := ptr
        let _v171
        let _v172
        _v172 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v169, currentHeadOffset)
        _v171 := _v172
        let _v173
        let _v174
        let _v175
        let _v176
        let _v177
        _v177 := usr$Add_add$word(currentHeadOffset, 32)
        let _v178
        let _v179
        let _v180
        let _v181
        _v178, _v179, _v180, _v181 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$address_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJ_CalldataWordReader_address_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJ(_v170, _v177)
        _v173 := _v178
        _v174 := _v179
        _v175 := _v180
        _v176 := _v181
        _v164 := _v171
        _v165 := _v173
        _v166 := _v174
        _v167 := _v175
        _v168 := _v176
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJ_CalldataWordReader_uint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJ (ptr, currentHeadOffset) -> _v182, _v183, _v184, _v185, _v186 {
        let _v187
        _v187 := ptr
        let _v188
        _v188 := ptr
        let _v189
        let _v190
        _v190 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v187, currentHeadOffset)
        _v189 := _v190
        let _v191
        let _v192
        let _v193
        let _v194
        let _v195
        _v195 := usr$Add_add$word(currentHeadOffset, 32)
        let _v196
        let _v197
        let _v198
        let _v199
        _v196, _v197, _v198, _v199 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$calldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJ_CalldataWordReader_calldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJ(_v188, _v195)
        _v191 := _v196
        _v192 := _v197
        _v193 := _v198
        _v194 := _v199
        _v182 := _v189
        _v183 := _v191
        _v184 := _v192
        _v185 := _v193
        _v186 := _v194
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLmemoryLbytesJ_memoryLbytesJJ_CalldataWordReader_uint256_pairLmemoryLbytesJ_memoryLbytesJJ (ptr, currentHeadOffset) -> _v200, _v201, _v202 {
        let _v203
        _v203 := ptr
        let _v204
        _v204 := ptr
        let _v205
        let _v206
        _v206 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v203, currentHeadOffset)
        _v205 := _v206
        let _v207
        let _v208
        let _v209
        _v209 := usr$Add_add$word(currentHeadOffset, 32)
        let _v210
        let _v211
        _v210, _v211 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$memoryLbytesJ_memoryLbytesJ_CalldataWordReader_memoryLbytesJ_memoryLbytesJ(_v204, _v209)
        _v207 := _v210
        _v208 := _v211
        _v200 := _v205
        _v201 := _v207
        _v202 := _v208
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_memoryLstringJJ_CalldataWordReader_uint256_pairLuint256_memoryLstringJJ (ptr, currentHeadOffset) -> _v212, _v213, _v214 {
        let _v215
        _v215 := ptr
        let _v216
        _v216 := ptr
        let _v217
        let _v218
        _v218 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v215, currentHeadOffset)
        _v217 := _v218
        let _v219
        let _v220
        let _v221
        _v221 := usr$Add_add$word(currentHeadOffset, 32)
        let _v222
        let _v223
        _v222, _v223 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_memoryLstringJ_CalldataWordReader_uint256_memoryLstringJ(_v216, _v221)
        _v219 := _v222
        _v220 := _v223
        _v212 := _v217
        _v213 := _v219
        _v214 := _v220
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_memoryLstringJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_memoryLstringJJJ (ptr, currentHeadOffset) -> _v224, _v225, _v226, _v227 {
        let _v228
        _v228 := ptr
        let _v229
        _v229 := ptr
        let _v230
        let _v231
        _v231 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v228, currentHeadOffset)
        _v230 := _v231
        let _v232
        let _v233
        let _v234
        let _v235
        _v235 := usr$Add_add$word(currentHeadOffset, 32)
        let _v236
        let _v237
        let _v238
        _v236, _v237, _v238 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_memoryLstringJJ_CalldataWordReader_uint256_pairLuint256_memoryLstringJJ(_v229, _v235)
        _v232 := _v236
        _v233 := _v237
        _v234 := _v238
        _v224 := _v230
        _v225 := _v232
        _v226 := _v233
        _v227 := _v234
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ (ptr, currentHeadOffset) -> _v239, _v240, _v241, _v242, _v243 {
        let _v244
        _v244 := ptr
        let _v245
        _v245 := ptr
        let _v246
        let _v247
        _v247 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v244, currentHeadOffset)
        _v246 := _v247
        let _v248
        let _v249
        let _v250
        let _v251
        let _v252
        _v252 := usr$Add_add$word(currentHeadOffset, 32)
        let _v253
        let _v254
        let _v255
        let _v256
        _v253, _v254, _v255, _v256 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_memoryLstringJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_memoryLstringJJJ(_v245, _v252)
        _v248 := _v253
        _v249 := _v254
        _v250 := _v255
        _v251 := _v256
        _v239 := _v246
        _v240 := _v248
        _v241 := _v249
        _v242 := _v250
        _v243 := _v251
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ (ptr, currentHeadOffset) -> _v257, _v258, _v259, _v260, _v261, _v262 {
        let _v263
        _v263 := ptr
        let _v264
        _v264 := ptr
        let _v265
        let _v266
        _v266 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v263, currentHeadOffset)
        _v265 := _v266
        let _v267
        let _v268
        let _v269
        let _v270
        let _v271
        let _v272
        _v272 := usr$Add_add$word(currentHeadOffset, 32)
        let _v273
        let _v274
        let _v275
        let _v276
        let _v277
        _v273, _v274, _v275, _v276, _v277 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ(_v264, _v272)
        _v267 := _v273
        _v268 := _v274
        _v269 := _v275
        _v270 := _v276
        _v271 := _v277
        _v257 := _v265
        _v258 := _v267
        _v259 := _v268
        _v260 := _v269
        _v261 := _v270
        _v262 := _v271
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ (ptr, currentHeadOffset) -> _v278, _v279, _v280, _v281, _v282, _v283, _v284 {
        let _v285
        _v285 := ptr
        let _v286
        _v286 := ptr
        let _v287
        let _v288
        _v288 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v285, currentHeadOffset)
        _v287 := _v288
        let _v289
        let _v290
        let _v291
        let _v292
        let _v293
        let _v294
        let _v295
        _v295 := usr$Add_add$word(currentHeadOffset, 32)
        let _v296
        let _v297
        let _v298
        let _v299
        let _v300
        let _v301
        _v296, _v297, _v298, _v299, _v300, _v301 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ(_v286, _v295)
        _v289 := _v296
        _v290 := _v297
        _v291 := _v298
        _v292 := _v299
        _v293 := _v300
        _v294 := _v301
        _v278 := _v287
        _v279 := _v289
        _v280 := _v290
        _v281 := _v291
        _v282 := _v292
        _v283 := _v293
        _v284 := _v294
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let _v302
        _v302 := usr$WordReader_advance$ABIDecoderLty_readerJ$uint256_CalldataWordReader(ptr, currentHeadOffset)
        let _v303
        _v303 := usr$WordReader_read$ABIDecoderLty_readerJ$uint256_CalldataWordReader(_v302)
        let _v304
        _v304 := usr$Typedef_abs$uint256(_v303)
        _result := _v304
        leave
      }
      function usr$ABIEncode_encodeInto$address (x, basePtr, offset, tail) -> _result {
        let repx
        let _v305
        _v305 := usr$Typedef_rep$address(x)
        repx := _v305
        let _v306
        _v306 := usr$Add_add$word(basePtr, offset)
        usr$mstore(_v306, repx)
        _result := tail
        leave
      }
      function usr$ABIEncode_encodeInto$memoryLstringJ (x, basePtr, offset, tail) -> _result {
        let _v307
        _v307 := usr$Typedef_rep$memoryLtJ$string(x)
        let _v308
        _v308 := usr$encodeIntoFromBytesLike(_v307, basePtr, offset, tail)
        _result := _v308
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ (_v309, _v310, _v311, _v312, _v313, _v314, _v315, basePtr, offset, tail) -> _result {
        let newTail
        let _v316
        _v316 := usr$ABIEncode_encodeInto$address(_v309, basePtr, offset, tail)
        newTail := _v316
        let a_sz
        a_sz := 32
        let _v317
        _v317 := usr$Add_add$word(offset, 32)
        let _v318
        _v318 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(_v310, _v311, _v312, _v313, _v314, _v315, basePtr, _v317, newTail)
        _result := _v318
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ (_v319, _v320, _v321, _v322, _v323, _v324, basePtr, offset, tail) -> _result {
        let newTail
        let _v325
        _v325 := usr$ABIEncode_encodeInto$uint256(_v319, basePtr, offset, tail)
        newTail := _v325
        let a_sz
        a_sz := 32
        let _v326
        _v326 := usr$Add_add$word(offset, 32)
        let _v327
        _v327 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ(_v320, _v321, _v322, _v323, _v324, basePtr, _v326, newTail)
        _result := _v327
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ (_v328, _v329, _v330, _v331, _v332, basePtr, offset, tail) -> _result {
        let newTail
        let _v333
        _v333 := usr$ABIEncode_encodeInto$uint256(_v328, basePtr, offset, tail)
        newTail := _v333
        let a_sz
        a_sz := 32
        let _v334
        _v334 := usr$Add_add$word(offset, 32)
        let _v335
        _v335 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v329, _v330, _v331, _v332, basePtr, _v334, newTail)
        _result := _v335
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_uint256JJ (_v336, _v337, _v338, _v339, basePtr, offset, tail) -> _result {
        let newTail
        let _v340
        _v340 := usr$ABIEncode_encodeInto$uint256(_v336, basePtr, offset, tail)
        newTail := _v340
        let a_sz
        a_sz := 32
        let _v341
        _v341 := usr$Add_add$word(offset, 32)
        let _v342
        _v342 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_uint256J(_v337, _v338, _v339, basePtr, _v341, newTail)
        _result := _v342
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_uint256J (_v343, _v344, _v345, basePtr, offset, tail) -> _result {
        let newTail
        let _v346
        _v346 := usr$ABIEncode_encodeInto$uint256(_v343, basePtr, offset, tail)
        newTail := _v346
        let a_sz
        a_sz := 32
        let _v347
        _v347 := usr$Add_add$word(offset, 32)
        let _v348
        _v348 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_uint256(_v344, _v345, basePtr, _v347, newTail)
        _result := _v348
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_uint256 (_v349, _v350, basePtr, offset, tail) -> _result {
        let newTail
        let _v351
        _v351 := usr$ABIEncode_encodeInto$uint256(_v349, basePtr, offset, tail)
        newTail := _v351
        let a_sz
        a_sz := 32
        let _v352
        _v352 := usr$Add_add$word(offset, 32)
        let _v353
        _v353 := usr$ABIEncode_encodeInto$uint256(_v350, basePtr, _v352, newTail)
        _result := _v353
        leave
      }
      function usr$ABIEncode_encodeInto$sumLunit_unitJ (_v354, basePtr, offset, tail) -> _result {
        let repx
        let _v355
        _v355 := usr$frombool(_v354)
        repx := _v355
        let _v356
        _v356 := usr$Add_add$word(basePtr, offset)
        usr$mstore(_v356, repx)
        _result := tail
        leave
      }
      function usr$ABIEncode_encodeInto$uint256 (x, basePtr, offset, tail) -> _result {
        let repx
        let _v357
        _v357 := usr$Typedef_rep$uint256(x)
        repx := _v357
        let _v358
        _v358 := usr$Add_add$word(basePtr, offset)
        usr$mstore(_v358, repx)
        _result := tail
        leave
      }
      function usr$ABIEncode_encodeInto$unit (basePtr, offset, tail) -> _result {
        _result := tail
        leave
      }
      function usr$Add_add$uint256 (x, y) -> _result {
        let _v359
        _v359 := usr$Typedef_rep$uint256(x)
        let _v360
        _v360 := usr$Typedef_rep$uint256(y)
        let _v361
        _v361 := usr$Add_add$word(_v359, _v360)
        let _v362
        _v362 := usr$Typedef_abs$uint256(_v361)
        _result := _v362
        leave
      }
      function usr$Add_add$word (l, r) -> _result {
        let _v363
        _v363 := usr$addWord(l, r)
        _result := _v363
        leave
      }
      function usr$ArrayPush_push$storageLarrayLtJJ$string_memoryLstringJ (arr, val) {
        let slot
        let _v364
        _v364 := usr$Typedef_rep$storageLtJ$arrayLstringJ(arr)
        slot := _v364
        let n
        let _v365
        _v365 := usr$sload(slot)
        n := _v365
        let _v366
        _v366 := usr$hash1(slot)
        let _v367
        _v367 := usr$Add_add$word(_v366, n)
        usr$CanStore_store$storageLstringJ(_v367, val)
        let _v368
        _v368 := usr$Add_add$word(n, 1)
        usr$sstore(slot, _v368)
      }
      function usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus (l, _v369, _v370, _v371, _v372) {
        usr$CanStore_store$storageLAttendeeStatusJ(l, _v369, _v370, _v371, _v372)
        leave
      }
      function usr$Assign_assign$a$storageLCountersJ_Counters (l, _v373, _v374, _v375, _v376) {
        usr$CanStore_store$storageLCountersJ(l, _v373, _v374, _v375, _v376)
        leave
      }
      function usr$Assign_assign$a$storageLEventRecJ_EventRec (l, _v377, _v378, _v379, _v380, _v381, _v382, _v383, _v384) {
        usr$CanStore_store$storageLEventRecJ(l, _v377, _v378, _v379, _v380, _v381, _v382, _v383, _v384)
        leave
      }
      function usr$Assign_assign$a$storageLaddressJ_address (l, r) {
        usr$CanStore_store$storageLaddressJ(l, r)
        leave
      }
      function usr$Assign_assign$a$storageLstringJ_memoryLstringJ (l, r) {
        usr$CanStore_store$storageLstringJ(l, r)
        leave
      }
      function usr$Assign_assign$a$storageLsumLunit_unitJJ_sumLunit_unitJ (l, _v385) {
        usr$CanStore_store$storageLsumLf_gJJ$unit_unit(l, _v385)
        leave
      }
      function usr$Assign_assign$a$storageLuint256J_uint256 (l, r) {
        usr$CanStore_store$storageLuint256J(l, r)
        leave
      }
      function usr$CanStore_load$storageLAttendeeStatusJ (_r) -> _v386, _v387, _v388, _v389 {
        let _v390
        let _v391
        let _v392
        let _v393
        let _v394
        _v394 := usr$Typedef_rep$storageLtJ$AttendeeStatus(_r)
        let _v395
        let _v396
        let _v397
        let _v398
        _v395, _v396, _v397, _v398 := usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ(_v394)
        _v390 := _v395
        _v391 := _v396
        _v392 := _v397
        _v393 := _v398
        let _v399
        let _v400
        let _v401
        let _v402
        _v399, _v400, _v401, _v402 := usr$Generic_to$AttendeeStatus(_v390, _v391, _v392, _v393)
        _v386 := _v399
        _v387 := _v400
        _v388 := _v401
        _v389 := _v402
        leave
      }
      function usr$CanStore_load$storageLCountersJ (_r) -> _v403, _v404, _v405, _v406 {
        let _v407
        let _v408
        let _v409
        let _v410
        let _v411
        _v411 := usr$Typedef_rep$storageLtJ$Counters(_r)
        let _v412
        let _v413
        let _v414
        let _v415
        _v412, _v413, _v414, _v415 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v411)
        _v407 := _v412
        _v408 := _v413
        _v409 := _v414
        _v410 := _v415
        let _v416
        let _v417
        let _v418
        let _v419
        _v416, _v417, _v418, _v419 := usr$Generic_to$Counters(_v407, _v408, _v409, _v410)
        _v403 := _v416
        _v404 := _v417
        _v405 := _v418
        _v406 := _v419
        leave
      }
      function usr$CanStore_load$storageLEventRecJ (_r) -> _v420, _v421, _v422, _v423, _v424, _v425, _v426, _v427 {
        let _v428
        let _v429
        let _v430
        let _v431
        let _v432
        let _v433
        let _v434
        let _v435
        let _v436
        _v436 := usr$Typedef_rep$storageLtJ$EventRec(_r)
        let _v437
        let _v438
        let _v439
        let _v440
        let _v441
        let _v442
        let _v443
        let _v444
        _v437, _v438, _v439, _v440, _v441, _v442, _v443, _v444 := usr$CanStore_load$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(_v436)
        _v428 := _v437
        _v429 := _v438
        _v430 := _v439
        _v431 := _v440
        _v432 := _v441
        _v433 := _v442
        _v434 := _v443
        _v435 := _v444
        let _v445
        let _v446
        let _v447
        let _v448
        let _v449
        let _v450
        let _v451
        let _v452
        _v445, _v446, _v447, _v448, _v449, _v450, _v451, _v452 := usr$Generic_to$EventRec(_v428, _v429, _v430, _v431, _v432, _v433, _v434, _v435)
        _v420 := _v445
        _v421 := _v446
        _v422 := _v447
        _v423 := _v448
        _v424 := _v449
        _v425 := _v450
        _v426 := _v451
        _v427 := _v452
        leave
      }
      function usr$CanStore_load$storageLaddressJ (l) -> _result {
        let _v453
        _v453 := usr$Typedef_rep$storageLtJ$address(l)
        let _v454
        _v454 := usr$StorageType_load$address(_v453)
        _result := _v454
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ (r) -> _v455, _v456, _v457, _v458, _v459, _v460, _v461 {
        let base
        let _v462
        _v462 := usr$Typedef_rep$storageLtJ$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(r)
        base := _v462
        let a_sz
        a_sz := 1
        let _v463
        let _v464
        _v464 := usr$CanStore_load$storageLaddressJ(base)
        _v463 := _v464
        let _v465
        let _v466
        let _v467
        let _v468
        let _v469
        let _v470
        let _v471
        _v471 := usr$Add_add$word(base, 1)
        let _v472
        let _v473
        let _v474
        let _v475
        let _v476
        let _v477
        _v472, _v473, _v474, _v475, _v476, _v477 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(_v471)
        _v465 := _v472
        _v466 := _v473
        _v467 := _v474
        _v468 := _v475
        _v469 := _v476
        _v470 := _v477
        _v455 := _v463
        _v456 := _v465
        _v457 := _v466
        _v458 := _v467
        _v459 := _v468
        _v460 := _v469
        _v461 := _v470
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ (r) -> _v478, _v479, _v480, _v481, _v482, _v483 {
        let base
        let _v484
        _v484 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(r)
        base := _v484
        let a_sz
        a_sz := 1
        let _v485
        let _v486
        _v486 := usr$CanStore_load$storageLuint256J(base)
        _v485 := _v486
        let _v487
        let _v488
        let _v489
        let _v490
        let _v491
        let _v492
        _v492 := usr$Add_add$word(base, 1)
        let _v493
        let _v494
        let _v495
        let _v496
        let _v497
        _v493, _v494, _v495, _v496, _v497 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ(_v492)
        _v487 := _v493
        _v488 := _v494
        _v489 := _v495
        _v490 := _v496
        _v491 := _v497
        _v478 := _v485
        _v479 := _v487
        _v480 := _v488
        _v481 := _v489
        _v482 := _v490
        _v483 := _v491
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ (r) -> _v498, _v499, _v500, _v501, _v502 {
        let base
        let _v503
        _v503 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(r)
        base := _v503
        let a_sz
        a_sz := 1
        let _v504
        let _v505
        _v505 := usr$CanStore_load$storageLuint256J(base)
        _v504 := _v505
        let _v506
        let _v507
        let _v508
        let _v509
        let _v510
        _v510 := usr$Add_add$word(base, 1)
        let _v511
        let _v512
        let _v513
        let _v514
        _v511, _v512, _v513, _v514 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v510)
        _v506 := _v511
        _v507 := _v512
        _v508 := _v513
        _v509 := _v514
        _v498 := _v504
        _v499 := _v506
        _v500 := _v507
        _v501 := _v508
        _v502 := _v509
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ (r) -> _v515, _v516, _v517, _v518 {
        let base
        let _v519
        _v519 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_uint256JJJ(r)
        base := _v519
        let a_sz
        a_sz := 1
        let _v520
        let _v521
        _v521 := usr$CanStore_load$storageLuint256J(base)
        _v520 := _v521
        let _v522
        let _v523
        let _v524
        let _v525
        _v525 := usr$Add_add$word(base, 1)
        let _v526
        let _v527
        let _v528
        _v526, _v527, _v528 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_uint256J(_v525)
        _v522 := _v526
        _v523 := _v527
        _v524 := _v528
        _v515 := _v520
        _v516 := _v522
        _v517 := _v523
        _v518 := _v524
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_uint256J (r) -> _v529, _v530, _v531 {
        let base
        let _v532
        _v532 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_uint256JJ(r)
        base := _v532
        let a_sz
        a_sz := 1
        let _v533
        let _v534
        _v534 := usr$CanStore_load$storageLuint256J(base)
        _v533 := _v534
        let _v535
        let _v536
        let _v537
        _v537 := usr$Add_add$word(base, 1)
        let _v538
        let _v539
        _v538, _v539 := usr$CanStore_load$storageLpairLa_bJJ$uint256_uint256(_v537)
        _v535 := _v538
        _v536 := _v539
        _v529 := _v533
        _v530 := _v535
        _v531 := _v536
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_uint256 (r) -> _v540, _v541 {
        let base
        let _v542
        _v542 := usr$Typedef_rep$storageLtJ$pairLuint256_uint256J(r)
        base := _v542
        let a_sz
        a_sz := 1
        let _v543
        let _v544
        _v544 := usr$CanStore_load$storageLuint256J(base)
        _v543 := _v544
        let _v545
        let _v546
        _v546 := usr$Add_add$word(base, 1)
        let _v547
        _v547 := usr$CanStore_load$storageLuint256J(_v546)
        _v545 := _v547
        _v540 := _v543
        _v541 := _v545
        leave
      }
      function usr$CanStore_load$storageLstringJ (src) -> _result {
        let srcPtr
        let _v548
        _v548 := usr$Typedef_rep$storageLtJ$string(src)
        srcPtr := _v548
        let dstPtr
        let _v549
        _v549 := usr$get_free_memory()
        dstPtr := _v549
        let endPtr
        let _v550
        _v550 := usr$loadBytesFromStorage(srcPtr, dstPtr)
        endPtr := _v550
        usr$set_free_memory(endPtr)
        _result := dstPtr
        leave
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ (r) -> _v551, _v552, _v553, _v554, _v555, _v556, _v557, _v558 {
        let base
        let _v559
        _v559 := usr$Typedef_rep$storageLtJ$sumLunit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJJ(r)
        base := _v559
        let tag
        let _v560
        _v560 := usr$sload(base)
        tag := _v560
        switch tag
          case 0 {_v551 := false
                  leave}
        default {let _v561
                 _v561 := usr$Add_add$word(base, 1)
                 let _v562
                 let _v563
                 let _v564
                 let _v565
                 let _v566
                 let _v567
                 let _v568
                 _v562, _v563, _v564, _v565, _v566, _v567, _v568 := usr$CanStore_load$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(_v561)
                 _v551 := true
                 _v552 := _v562
                 _v553 := _v563
                 _v554 := _v564
                 _v555 := _v565
                 _v556 := _v566
                 _v557 := _v567
                 _v558 := _v568
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ (r) -> _v569, _v570, _v571, _v572 {
        let base
        let _v573
        _v573 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_sumLunit_unitJJJJ(r)
        base := _v573
        let tag
        let _v574
        _v574 := usr$sload(base)
        tag := _v574
        switch tag
          case 0 {_v569 := false
                  leave}
        default {let _v575
                 _v575 := usr$Add_add$word(base, 1)
                 let _v576
                 let _v577
                 let _v578
                 _v576, _v577, _v578 := usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ(_v575)
                 _v569 := true
                 _v570 := _v576
                 _v571 := _v577
                 _v572 := _v578
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ (r) -> _v579, _v580, _v581 {
        let base
        let _v582
        _v582 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_unitJJJ(r)
        base := _v582
        let tag
        let _v583
        _v583 := usr$sload(base)
        tag := _v583
        switch tag
          case 0 {_v579 := false
                  leave}
        default {let _v584
                 _v584 := usr$Add_add$word(base, 1)
                 let _v585
                 let _v586
                 _v585, _v586 := usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_unitJ(_v584)
                 _v579 := true
                 _v580 := _v585
                 _v581 := _v586
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_unitJ (r) -> _v587, _v588 {
        let base
        let _v589
        _v589 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_unitJJ(r)
        base := _v589
        let tag
        let _v590
        _v590 := usr$sload(base)
        tag := _v590
        switch tag
          case 0 {_v587 := false
                  leave}
        default {let _v591
                 _v591 := usr$Add_add$word(base, 1)
                 let _v592
                 _v592 := usr$CanStore_load$storageLsumLf_gJJ$unit_unit(_v591)
                 _v587 := true
                 _v588 := _v592
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_unit (r) -> _v593 {
        let base
        let _v594
        _v594 := usr$Typedef_rep$storageLtJ$sumLunit_unitJ(r)
        base := _v594
        let tag
        let _v595
        _v595 := usr$sload(base)
        tag := _v595
        switch tag
          case 0 {_v593 := false
                  leave}
        default {_v593 := true
                 leave}
      }
      function usr$CanStore_load$storageLuint256J (l) -> _result {
        let _v596
        _v596 := usr$Typedef_rep$storageLtJ$uint256(l)
        let _v597
        _v597 := usr$StorageType_load$uint256(_v596)
        _result := _v597
        leave
      }
      function usr$CanStore_store$storageLAttendeeStatusJ (_r, _v598, _v599, _v600, _v601) {
        let _v602
        _v602 := usr$Typedef_rep$storageLtJ$AttendeeStatus(_r)
        let _v603
        let _v604
        let _v605
        let _v606
        _v603, _v604, _v605, _v606 := usr$Generic_from$AttendeeStatus(_v598, _v599, _v600, _v601)
        usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ(_v602, _v603, _v604, _v605, _v606)
      }
      function usr$CanStore_store$storageLCountersJ (_r, _v607, _v608, _v609, _v610) {
        let _v611
        _v611 := usr$Typedef_rep$storageLtJ$Counters(_r)
        let _v612
        let _v613
        let _v614
        let _v615
        _v612, _v613, _v614, _v615 := usr$Generic_from$Counters(_v607, _v608, _v609, _v610)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v611, _v612, _v613, _v614, _v615)
      }
      function usr$CanStore_store$storageLEventRecJ (_r, _v616, _v617, _v618, _v619, _v620, _v621, _v622, _v623) {
        let _v624
        _v624 := usr$Typedef_rep$storageLtJ$EventRec(_r)
        let _v625
        let _v626
        let _v627
        let _v628
        let _v629
        let _v630
        let _v631
        let _v632
        _v625, _v626, _v627, _v628, _v629, _v630, _v631, _v632 := usr$Generic_from$EventRec(_v616, _v617, _v618, _v619, _v620, _v621, _v622, _v623)
        usr$CanStore_store$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(_v624, _v625, _v626, _v627, _v628, _v629, _v630, _v631, _v632)
      }
      function usr$CanStore_store$storageLaddressJ (l, r) {
        let _v633
        _v633 := usr$Typedef_rep$storageLtJ$address(l)
        usr$StorageType_store$address(_v633, r)
        leave
      }
      function usr$CanStore_store$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ (r, _v634, _v635, _v636, _v637, _v638, _v639, _v640) {
        let base
        let _v641
        _v641 := usr$Typedef_rep$storageLtJ$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(r)
        base := _v641
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLaddressJ(base, _v634)
        let _v642
        _v642 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(_v642, _v635, _v636, _v637, _v638, _v639, _v640)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ (r, _v643, _v644, _v645, _v646, _v647, _v648) {
        let base
        let _v649
        _v649 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(r)
        base := _v649
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v643)
        let _v650
        _v650 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ(_v650, _v644, _v645, _v646, _v647, _v648)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ (r, _v651, _v652, _v653, _v654, _v655) {
        let base
        let _v656
        _v656 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(r)
        base := _v656
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v651)
        let _v657
        _v657 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v657, _v652, _v653, _v654, _v655)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ (r, _v658, _v659, _v660, _v661) {
        let base
        let _v662
        _v662 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_uint256JJJ(r)
        base := _v662
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v658)
        let _v663
        _v663 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_uint256J(_v663, _v659, _v660, _v661)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_uint256J (r, _v664, _v665, _v666) {
        let base
        let _v667
        _v667 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_uint256JJ(r)
        base := _v667
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v664)
        let _v668
        _v668 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_uint256(_v668, _v665, _v666)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_uint256 (r, _v669, _v670) {
        let base
        let _v671
        _v671 := usr$Typedef_rep$storageLtJ$pairLuint256_uint256J(r)
        base := _v671
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v669)
        let _v672
        _v672 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLuint256J(_v672, _v670)
      }
      function usr$CanStore_store$storageLstringJ (dst, src) {
        let srcPtr
        let _v673
        _v673 := usr$Typedef_rep$memoryLtJ$string(src)
        srcPtr := _v673
        let slot
        let _v674
        _v674 := usr$Typedef_rep$storageLtJ$string(dst)
        slot := _v674
        usr$storeBytesFromMemory(slot, srcPtr)
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ (r, _v675, _v676, _v677, _v678, _v679, _v680, _v681, _v682) {
        let base
        let _v683
        _v683 := usr$Typedef_rep$storageLtJ$sumLunit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJJ(r)
        base := _v683
        switch _v675
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v684
                     _v684 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(_v684, _v676, _v677, _v678, _v679, _v680, _v681, _v682)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ (r, _v685, _v686, _v687, _v688) {
        let base
        let _v689
        _v689 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_sumLunit_unitJJJJ(r)
        base := _v689
        switch _v685
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v690
                     _v690 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ(_v690, _v686, _v687, _v688)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ (r, _v691, _v692, _v693) {
        let base
        let _v694
        _v694 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_unitJJJ(r)
        base := _v694
        switch _v691
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v695
                     _v695 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_unitJ(_v695, _v692, _v693)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_unitJ (r, _v696, _v697) {
        let base
        let _v698
        _v698 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_unitJJ(r)
        base := _v698
        switch _v696
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v699
                     _v699 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLsumLf_gJJ$unit_unit(_v699, _v697)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_unit (r, _v700) {
        let base
        let _v701
        _v701 := usr$Typedef_rep$storageLtJ$sumLunit_unitJ(r)
        base := _v701
        switch _v700
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)}
      }
      function usr$CanStore_store$storageLuint256J (l, r) {
        let _v702
        _v702 := usr$Typedef_rep$storageLtJ$uint256(l)
        usr$StorageType_store$uint256(_v702, r)
        leave
      }
      function usr$Div_div$uint256 (x, y) -> _result {
        let _v703
        _v703 := usr$Typedef_rep$uint256(x)
        let _v704
        _v704 := usr$Typedef_rep$uint256(y)
        let _v705
        _v705 := usr$Div_div$word(_v703, _v704)
        let _v706
        _v706 := usr$Typedef_abs$uint256(_v705)
        _result := _v706
        leave
      }
      function usr$Div_div$word (l, r) -> _result {
        let _v707
        _v707 := usr$div(l, r)
        _result := _v707
        leave
      }
      function usr$Eq_eq$address (x, y) -> _v708 {
        let _v709
        _v709 := usr$Typedef_rep$address(x)
        let _v710
        _v710 := usr$Typedef_rep$address(y)
        let _v711
        _v711 := usr$Eq_eq$word(_v709, _v710)
        _v708 := _v711
        leave
      }
      function usr$Eq_eq$uint256 (x, y) -> _v712 {
        let _v713
        _v713 := usr$Typedef_rep$uint256(x)
        let _v714
        _v714 := usr$Typedef_rep$uint256(y)
        let _v715
        _v715 := usr$Eq_eq$word(_v713, _v714)
        _v712 := _v715
        leave
      }
      function usr$Eq_eq$word (x, y) -> _v716 {
        let _v717
        _v717 := usr$eqWord(x, y)
        _v716 := _v717
        leave
      }
      function usr$ExecMethod_exec$FallbackLpayability_unit_unit_fnJ$Payable_t_fallback744567 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$Payable()
        usr$invokable_invoke$t_fallback744567()
        stop()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_unit_uint256_t_DUST_CLAIM_TIMEOUT732580 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_DUST_CLAIM_TIMEOUT732580()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MAX_BATCH_SIZE_unit_uint256_t_MAX_BATCH_SIZE726970 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_MAX_BATCH_SIZE726970()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_unit_uint256_t_MIN_CANCELLATION_BUFFER721378 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_MIN_CANCELLATION_BUFFER721378()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_addOperator_pairLuint256_addressJ_unit_t_addOperator715799 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_addressJ_unit_t_addOperator715799()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_attendees_pairLuint256_addressJ_uint256_t_attendees710234 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_addressJ_uint256_t_attendees710234()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelEvent_uint256_unit_t_cancelEvent696677 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_cancelEvent696677()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancel_uint256_unit_t_cancel704363 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_cancel704363()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelled_uint256_sumLunit_unitJ_t_cancelled690311 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_sumLunit_unitJ_t_cancelled690311()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkInBatchWithProofs_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkInWithProof_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkIn_pairLuint256_addressJ_unit_t_checkIn684539 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_addressJ_unit_t_checkIn684539()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkedInCount_uint256_uint256_t_checkedInCount648156 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_checkedInCount648156()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimDust_uint256_unit_t_claimDust634664 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_claimDust634664()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimRefund_uint256_unit_t_claimRefund627219 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_claimRefund627219()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claim_uint256_unit_t_claim642485 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_claim642485()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimedCount_uint256_uint256_t_claimedCount619465 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_claimedCount619465()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_createEvent_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_eventCount_unit_uint256_t_eventCount607668 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_eventCount607668()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getEvent_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getState_uint256_uint256_t_getState596691 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_getState596691()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_held_uint256_uint256_t_held590925 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_held590925()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_isOperator_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_maintainer_unit_address_t_maintainer579876 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_address_t_maintainer579876()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_metadataURI_uint256_memoryLstringJ_t_metadataURI574576 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_memoryLstringJ_t_metadataURI574576()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_organizer_uint256_address_t_organizer568622 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_address_t_organizer568622()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_registeredCount_uint256_uint256_t_registeredCount555638 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_registeredCount555638()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_removeOperator_pairLuint256_addressJ_unit_t_removeOperator550233 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_addressJ_unit_t_removeOperator550233()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_rewardPerAttendee_uint256_uint256_t_rewardPerAttendee539456 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_rewardPerAttendee539456()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_address_unit_t_setMaintainer528800 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$address_unit_t_setMaintainer528800()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMetadataURI_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_totalHeld_unit_uint256_t_totalHeld517523 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_totalHeld517523()
      }
      function usr$ExecMethod_exec$MethodLname_Payable_args_rets_fnJ$DispatchNameTy_Kodyl_register_uint256_unit_t_register563235 () {
        usr$do_exec$uint256_unit_t_register563235()
      }
      function usr$Generic_from$AttendeeStatus (_v718, _v719, _v720, _v721) -> _v722, _v723, _v724, _v725 {
        switch _v718
          case false {_v722 := false
                      leave}
          case true {switch _v719
                       case false {_v722 := true
                                   _v723 := false
                                   leave}
                       case true {switch _v720
                                    case false {_v722 := true
                                                _v723 := true
                                                _v724 := false
                                                leave}
                                    case true {switch _v721
                                                 case false {_v722 := true
                                                             _v723 := true
                                                             _v724 := true
                                                             _v725 := false
                                                             leave}
                                                 case true {_v722 := true
                                                            _v723 := true
                                                            _v724 := true
                                                            _v725 := true
                                                            leave}}}}
      }
      function usr$Generic_from$Counters (_v726, _v727, _v728, _v729) -> _v730, _v731, _v732, _v733 {
        _v730 := _v726
        _v731 := _v727
        _v732 := _v728
        _v733 := _v729
        leave
      }
      function usr$Generic_from$EventRec (_v734, _v735, _v736, _v737, _v738, _v739, _v740, _v741) -> _v742, _v743, _v744, _v745, _v746, _v747, _v748, _v749 {
        switch _v734
          case false {_v742 := false
                      leave}
          case true {_v742 := true
                     _v743 := _v735
                     _v744 := _v736
                     _v745 := _v737
                     _v746 := _v738
                     _v747 := _v739
                     _v748 := _v740
                     _v749 := _v741
                     leave}
      }
      function usr$Generic_to$AttendeeStatus (_v750, _v751, _v752, _v753) -> _v754, _v755, _v756, _v757 {
        switch _v750
          case false {_v754 := false
                      leave}
          case true {switch _v751
                       case false {_v754 := true
                                   _v755 := false
                                   leave}
                       case true {switch _v752
                                    case false {_v754 := true
                                                _v755 := true
                                                _v756 := false
                                                leave}
                                    case true {switch _v753
                                                 case false {_v754 := true
                                                             _v755 := true
                                                             _v756 := true
                                                             _v757 := false
                                                             leave}
                                                 case true {_v754 := true
                                                            _v755 := true
                                                            _v756 := true
                                                            _v757 := true
                                                            leave}}}}
      }
      function usr$Generic_to$Counters (_v758, _v759, _v760, _v761) -> _v762, _v763, _v764, _v765 {
        _v762 := _v758
        _v763 := _v759
        _v764 := _v760
        _v765 := _v761
        leave
      }
      function usr$Generic_to$EventRec (_v766, _v767, _v768, _v769, _v770, _v771, _v772, _v773) -> _v774, _v775, _v776, _v777, _v778, _v779, _v780, _v781 {
        switch _v766
          case false {_v774 := false
                      leave}
          case true {_v774 := true
                     _v775 := _v767
                     _v776 := _v768
                     _v777 := _v769
                     _v778 := _v770
                     _v779 := _v771
                     _v780 := _v772
                     _v781 := _v773
                     leave}
      }
      function usr$HasWordReader_getWordReader$calldataLbytesJ (x) -> _result {
        let _v782
        _v782 := usr$Typedef_rep$calldataLtJ$bytes(x)
        _result := _v782
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256 (_v783, _v784) -> _result {
        let slot
        let _v785
        _v785 := usr$Typedef_rep$storageLtJ$arrayLstringJ(_v783)
        slot := _v785
        let idx
        let _v786
        _v786 := usr$Typedef_rep$uint256(_v784)
        idx := _v786
        let _v787
        let _v788
        _v788 := usr$sload(slot)
        let _v789
        _v789 := usr$ge$word(idx, _v788)
        _v787 := _v789
        switch _v787
          case false {}
          case true {usr$out_of_bounds()}
        let _v790
        _v790 := usr$hash1(slot)
        let _v791
        _v791 := usr$Add_add$word(_v790, idx)
        _result := _v791
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus (_v792, _v793) -> _result {
        let _v794
        _v794 := usr$Typedef_rep$storageLtJ$mappingLaddress_AttendeeStatusJ(_v792)
        let _v795
        _v795 := usr$Typedef_rep$address(_v793)
        let _v796
        _v796 := usr$hash2(_v794, _v795)
        _result := _v796
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_sumLunit_unitJ (_v797, _v798) -> _result {
        let _v799
        _v799 := usr$Typedef_rep$storageLtJ$mappingLaddress_sumLunit_unitJJ(_v797)
        let _v800
        _v800 := usr$Typedef_rep$address(_v798)
        let _v801
        _v801 := usr$hash2(_v799, _v800)
        _result := _v801
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters (_v802, _v803) -> _result {
        let _v804
        _v804 := usr$Typedef_rep$storageLtJ$mappingLuint256_CountersJ(_v802)
        let _v805
        _v805 := usr$Typedef_rep$uint256(_v803)
        let _v806
        _v806 := usr$hash2(_v804, _v805)
        _result := _v806
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec (_v807, _v808) -> _result {
        let _v809
        _v809 := usr$Typedef_rep$storageLtJ$mappingLuint256_EventRecJ(_v807)
        let _v810
        _v810 := usr$Typedef_rep$uint256(_v808)
        let _v811
        _v811 := usr$hash2(_v809, _v810)
        _result := _v811
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_mappingLaddress_AttendeeStatusJ (_v812, _v813) -> _result {
        let _v814
        _v814 := usr$Typedef_rep$storageLtJ$mappingLuint256_mappingLaddress_AttendeeStatusJJ(_v812)
        let _v815
        _v815 := usr$Typedef_rep$uint256(_v813)
        let _v816
        _v816 := usr$hash2(_v814, _v815)
        _result := _v816
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_mappingLaddress_sumLunit_unitJJ (_v817, _v818) -> _result {
        let _v819
        _v819 := usr$Typedef_rep$storageLtJ$mappingLuint256_mappingLaddress_sumLunit_unitJJJ(_v817)
        let _v820
        _v820 := usr$Typedef_rep$uint256(_v818)
        let _v821
        _v821 := usr$hash2(_v819, _v820)
        _result := _v821
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ (_v822, _v823) -> _result {
        let _v824
        _v824 := usr$Typedef_rep$storageLtJ$mappingLuint256_sumLunit_unitJJ(_v822)
        let _v825
        _v825 := usr$Typedef_rep$uint256(_v823)
        let _v826
        _v826 := usr$hash2(_v824, _v825)
        _result := _v826
        leave
      }
      function usr$Length_length$calldataLarrayLtJJ$address (arr) -> _result {
        let _v827
        _v827 := usr$abiArrayLength$address(arr)
        _result := _v827
        leave
      }
      function usr$Length_length$calldataLarrayLtJJ$memoryLbytesJ (arr) -> _result {
        let _v828
        _v828 := usr$abiArrayLength$memoryLbytesJ(arr)
        _result := _v828
        leave
      }
      function usr$Length_length$calldataLarrayLtJJ$uint256 (arr) -> _result {
        let _v829
        _v829 := usr$abiArrayLength$uint256(arr)
        _result := _v829
        leave
      }
      function usr$MemoryEncode_encodeInto$bytes32 (v, target) {
        let _v830
        _v830 := usr$Typedef_rep$bytes32(v)
        usr$mstore(target, _v830)
        leave
      }
      function usr$MemoryEncode_encodeInto$memoryLbytesJ (v, target) {
        let v_
        let _v831
        _v831 := usr$Typedef_rep$memoryLtJ$bytes(v)
        v_ := _v831
        let _v832
        _v832 := usr$Add_add$word(v_, 32)
        let _v833
        _v833 := usr$mload(v_)
        usr$mcopy(target, _v832, _v833)
      }
      function usr$MemoryPointer_ptr$memoryLbytesJ (v) -> _result {
        let _v834
        _v834 := usr$Typedef_rep$memoryLtJ$bytes(v)
        let _v835
        _v835 := usr$Add_add$word(_v834, 32)
        _result := _v835
        leave
      }
      function usr$MemorySize_len$memoryLbytesJ (v) -> _result {
        let _v836
        _v836 := usr$Typedef_rep$memoryLtJ$bytes(v)
        let _v837
        _v837 := usr$mload(_v836)
        _result := _v837
        leave
      }
      function usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable () {
        let _v838
        let _v839
        let _v840
        _v838 := false
        _v839 := 3046674083
        let _v841
        _v841 := usr$callvalue()
        let _v842
        _v842 := usr$Eq_eq$word(_v841, 0)
        usr$require(_v842, false, 3046674083, 911)
      }
      function usr$MethodLevelCallvalueCheck_checkCallvalue$Payable () {
      }
      function usr$Mul_mul$uint256 (x, y) -> _result {
        let _v843
        _v843 := usr$Typedef_rep$uint256(x)
        let _v844
        _v844 := usr$Typedef_rep$uint256(y)
        let _v845
        _v845 := usr$Mul_mul$word(_v843, _v844)
        let _v846
        _v846 := usr$Typedef_abs$uint256(_v845)
        _result := _v846
        leave
      }
      function usr$Mul_mul$word (l, r) -> _result {
        let _v847
        _v847 := usr$mulWord(l, r)
        _result := _v847
        leave
      }
      function usr$Ord_gt$uint256 (x, y) -> _v848 {
        let _v849
        _v849 := usr$Typedef_rep$uint256(x)
        let _v850
        _v850 := usr$Typedef_rep$uint256(y)
        let _v851
        _v851 := usr$Ord_gt$word(_v849, _v850)
        _v848 := _v851
        leave
      }
      function usr$Ord_gt$word (x, y) -> _v852 {
        let _v853
        _v853 := usr$gtWord(x, y)
        _v852 := _v853
        leave
      }
      function usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_eventCount_sel_uint256_pairLaddress_unitJ () -> _result {
        let offset
        offset := 1
        let _v854
        _v854 := usr$CanStore_load$storageLuint256J(1)
        _result := _v854
        leave
      }
      function usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit () -> _result {
        let offset
        offset := 0
        let _v855
        _v855 := usr$CanStore_load$storageLaddressJ(0)
        _result := _v855
        leave
      }
      function usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ () -> _result {
        let offset
        offset := 2
        let _v856
        _v856 := usr$CanStore_load$storageLuint256J(2)
        _result := _v856
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLcalldataLarrayLtJJ_iJ$address_uint256_address (_v857, _v858) -> _result {
        let _v859
        _v859 := usr$Typedef_rep$uint256(_v858)
        let _v860
        _v860 := usr$abiArrayGet$address_address(_v857, _v859)
        _result := _v860
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLcalldataLarrayLtJJ_iJ$memoryLbytesJ_uint256_memoryLbytesJ (_v861, _v862) -> _result {
        let _v863
        _v863 := usr$Typedef_rep$uint256(_v862)
        let _v864
        _v864 := usr$abiArrayGet$memoryLbytesJ_memoryLbytesJ(_v861, _v863)
        _result := _v864
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLcalldataLarrayLtJJ_iJ$uint256_uint256_uint256 (_v865, _v866) -> _result {
        let _v867
        _v867 := usr$Typedef_rep$uint256(_v866)
        let _v868
        _v868 := usr$abiArrayGet$uint256_uint256(_v865, _v867)
        _result := _v868
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256_memoryLstringJ (_v869, _v870) -> _result {
        let _v871
        _v871 := usr$LValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256(_v869, _v870)
        let _v872
        _v872 := usr$CanStore_load$storageLstringJ(_v871)
        _result := _v872
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus (_v873, _v874) -> _v875, _v876, _v877, _v878 {
        let _v879
        _v879 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus(_v873, _v874)
        let _v880
        let _v881
        let _v882
        let _v883
        _v880, _v881, _v882, _v883 := usr$readStorage$AttendeeStatus(_v879)
        _v875 := _v880
        _v876 := _v881
        _v877 := _v882
        _v878 := _v883
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_sumLunit_unitJ (_v884, _v885) -> _v886 {
        let _v887
        _v887 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_sumLunit_unitJ(_v884, _v885)
        let _v888
        _v888 := usr$readStorage$sumLunit_unitJ(_v887)
        _v886 := _v888
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters (_v889, _v890) -> _v891, _v892, _v893, _v894 {
        let _v895
        _v895 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters(_v889, _v890)
        let _v896
        let _v897
        let _v898
        let _v899
        _v896, _v897, _v898, _v899 := usr$readStorage$Counters(_v895)
        _v891 := _v896
        _v892 := _v897
        _v893 := _v898
        _v894 := _v899
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec (_v900, _v901) -> _v902, _v903, _v904, _v905, _v906, _v907, _v908, _v909 {
        let _v910
        _v910 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec(_v900, _v901)
        let _v911
        let _v912
        let _v913
        let _v914
        let _v915
        let _v916
        let _v917
        let _v918
        _v911, _v912, _v913, _v914, _v915, _v916, _v917, _v918 := usr$readStorage$EventRec(_v910)
        _v902 := _v911
        _v903 := _v912
        _v904 := _v913
        _v905 := _v914
        _v906 := _v915
        _v907 := _v916
        _v908 := _v917
        _v909 := _v918
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ (_v919, _v920) -> _v921 {
        let _v922
        _v922 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ(_v919, _v920)
        let _v923
        _v923 := usr$readStorage$sumLunit_unitJ(_v922)
        _v921 := _v923
        leave
      }
      function usr$RunContract_exec$ContractLmethods_fbJ$pairLMethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ_FallbackLPayable_unit_unit_t_fallback744567J () {
        mstore(64, memoryguard(128))
        let _v924
        let _v925
        _v925 := usr$calldatasize()
        let _v926
        _v926 := usr$ge$word(_v925, 4)
        _v924 := _v926
        switch _v924
          case false {}
          case true {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ()}
        usr$ExecMethod_exec$FallbackLpayability_unit_unit_fnJ$Payable_t_fallback744567()
      }
      function usr$RunDispatch_go$MethodLname_payability_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800 () {
        let _v927
        let _v928
        _v928 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800J()
        _v927 := _v928
        switch _v927
          case false {leave}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_address_unit_t_setMaintainer528800()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJ () {
        let _v929
        let _v930
        _v930 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J()
        _v929 := _v930
        switch _v929
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_unit_uint256_t_DUST_CLAIM_TIMEOUT732580()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJ () {
        let _v931
        let _v932
        _v932 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J()
        _v931 := _v932
        switch _v931
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MAX_BATCH_SIZE_unit_uint256_t_MAX_BATCH_SIZE726970()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJ () {
        let _v933
        let _v934
        _v934 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J()
        _v933 := _v934
        switch _v933
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_unit_uint256_t_MIN_CANCELLATION_BUFFER721378()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJ () {
        let _v935
        let _v936
        _v936 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J()
        _v935 := _v936
        switch _v935
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_addOperator_pairLuint256_addressJ_unit_t_addOperator715799()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v937
        let _v938
        _v938 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J()
        _v937 := _v938
        switch _v937
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_attendees_pairLuint256_addressJ_uint256_t_attendees710234()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJ () {
        let _v939
        let _v940
        _v940 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J()
        _v939 := _v940
        switch _v939
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelEvent_uint256_unit_t_cancelEvent696677()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJ () {
        let _v941
        let _v942
        _v942 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J()
        _v941 := _v942
        switch _v941
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancel_uint256_unit_t_cancel704363()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJ () {
        let _v943
        let _v944
        _v944 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J()
        _v943 := _v944
        switch _v943
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelled_uint256_sumLunit_unitJ_t_cancelled690311()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJ () {
        let _v945
        let _v946
        _v946 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J()
        _v945 := _v946
        switch _v945
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkInBatchWithProofs_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJ () {
        let _v947
        let _v948
        _v948 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J()
        _v947 := _v948
        switch _v947
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkInWithProof_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJ () {
        let _v949
        let _v950
        _v950 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J()
        _v949 := _v950
        switch _v949
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkIn_pairLuint256_addressJ_unit_t_checkIn684539()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJ () {
        let _v951
        let _v952
        _v952 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J()
        _v951 := _v952
        switch _v951
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkedInCount_uint256_uint256_t_checkedInCount648156()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800J () {
        let _v953
        let _v954
        _v954 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J()
        _v953 := _v954
        switch _v953
          case false {usr$RunDispatch_go$MethodLname_payability_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimDust_uint256_unit_t_claimDust634664()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJ () {
        let _v955
        let _v956
        _v956 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J()
        _v955 := _v956
        switch _v955
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimRefund_uint256_unit_t_claimRefund627219()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJ () {
        let _v957
        let _v958
        _v958 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J()
        _v957 := _v958
        switch _v957
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claim_uint256_unit_t_claim642485()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJ () {
        let _v959
        let _v960
        _v960 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J()
        _v959 := _v960
        switch _v959
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimedCount_uint256_uint256_t_claimedCount619465()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v961
        let _v962
        _v962 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842J()
        _v961 := _v962
        switch _v961
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_createEvent_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v963
        let _v964
        _v964 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J()
        _v963 := _v964
        switch _v963
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_eventCount_unit_uint256_t_eventCount607668()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v965
        let _v966
        _v966 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J()
        _v965 := _v966
        switch _v965
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getEvent_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v967
        let _v968
        _v968 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J()
        _v967 := _v968
        switch _v967
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getState_uint256_uint256_t_getState596691()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJ () {
        let _v969
        let _v970
        _v970 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J()
        _v969 := _v970
        switch _v969
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_held_uint256_uint256_t_held590925()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJ () {
        let _v971
        let _v972
        _v972 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J()
        _v971 := _v972
        switch _v971
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_isOperator_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v973
        let _v974
        _v974 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J()
        _v973 := _v974
        switch _v973
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_maintainer_unit_address_t_maintainer579876()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v975
        let _v976
        _v976 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J()
        _v975 := _v976
        switch _v975
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_metadataURI_uint256_memoryLstringJ_t_metadataURI574576()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v977
        let _v978
        _v978 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J()
        _v977 := _v978
        switch _v977
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_organizer_uint256_address_t_organizer568622()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJ () {
        let _v979
        let _v980
        _v980 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J()
        _v979 := _v980
        switch _v979
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_Payable_args_rets_fnJ$DispatchNameTy_Kodyl_register_uint256_unit_t_register563235()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJ () {
        let _v981
        let _v982
        _v982 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J()
        _v981 := _v982
        switch _v981
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_registeredCount_uint256_uint256_t_registeredCount555638()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJ () {
        let _v983
        let _v984
        _v984 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J()
        _v983 := _v984
        switch _v983
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_removeOperator_pairLuint256_addressJ_unit_t_removeOperator550233()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJ () {
        let _v985
        let _v986
        _v986 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J()
        _v985 := _v986
        switch _v985
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_rewardPerAttendee_uint256_uint256_t_rewardPerAttendee539456()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJ () {
        let _v987
        let _v988
        _v988 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J()
        _v987 := _v988
        switch _v987
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800J()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMetadataURI_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v989
        let _v990
        _v990 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J()
        _v989 := _v990
        switch _v989
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_totalHeld_unit_uint256_t_totalHeld517523()}
      }
      function usr$StorageType_load$address (ptr) -> _result {
        let _v991
        _v991 := usr$StorageType_load$word(ptr)
        _result := _v991
        leave
      }
      function usr$StorageType_load$uint256 (ptr) -> _result {
        let _v992
        _v992 := usr$StorageType_load$word(ptr)
        _result := _v992
        leave
      }
      function usr$StorageType_load$word (ptr) -> _result {
        let _v993
        _v993 := usr$sload(ptr)
        _result := _v993
        leave
      }
      function usr$StorageType_store$address (ptr, value) {
        let _v994
        _v994 := usr$Typedef_rep$address(value)
        usr$StorageType_store$word(ptr, _v994)
        leave
      }
      function usr$StorageType_store$uint256 (ptr, value) {
        let _v995
        _v995 := usr$Typedef_rep$uint256(value)
        usr$StorageType_store$word(ptr, _v995)
        leave
      }
      function usr$StorageType_store$word (ptr, value) {
        usr$sstore(ptr, value)
        leave
      }
      function usr$Sub_sub$uint256 (x, y) -> _result {
        let _v996
        _v996 := usr$Typedef_rep$uint256(x)
        let _v997
        _v997 := usr$Typedef_rep$uint256(y)
        let _v998
        _v998 := usr$Sub_sub$word(_v996, _v997)
        let _v999
        _v999 := usr$Typedef_abs$uint256(_v998)
        _result := _v999
        leave
      }
      function usr$Sub_sub$word (l, r) -> _result {
        let _v1000
        _v1000 := usr$subWord(l, r)
        _result := _v1000
        leave
      }
      function usr$Typedef_abs$address (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_abs$calldataLtJ$arrayLaddressJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_abs$calldataLtJ$arrayLmemoryLbytesJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_abs$calldataLtJ$arrayLuint256J (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_abs$uint256 (w) -> _result {
        _result := w
        leave
      }
      function usr$Typedef_rep$CalldataWordReader (r) -> _result {
        _result := r
        leave
      }
      function usr$Typedef_rep$address (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$bytes32 (b) -> _result {
        _result := b
        leave
      }
      function usr$Typedef_rep$calldataLtJ$arrayLaddressJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$calldataLtJ$arrayLmemoryLbytesJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$calldataLtJ$arrayLuint256J (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$calldataLtJ$bytes (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$memoryLtJ$bytes (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$memoryLtJ$string (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$AttendeeStatus (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$Counters (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$EventRec (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$address (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$arrayLstringJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$mappingLaddress_AttendeeStatusJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$mappingLaddress_sumLunit_unitJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$mappingLuint256_CountersJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$mappingLuint256_EventRecJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$mappingLuint256_mappingLaddress_AttendeeStatusJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$mappingLuint256_mappingLaddress_sumLunit_unitJJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$mappingLuint256_sumLunit_unitJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_uint256JJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_uint256JJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$pairLuint256_uint256J (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$string (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$sumLunit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_sumLunit_unitJJJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_unitJJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_unitJJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$sumLunit_unitJ (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$storageLtJ$uint256 (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_rep$uint256 (x) -> _result {
        _result := x
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$address_CalldataWordReader (decoder, offset) -> _result {
        let _v1001
        _v1001 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v1001
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLaddressJJ_CalldataWordReader (decoder, offset) -> _result {
        let _v1002
        _v1002 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v1002
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLmemoryLbytesJJJ_CalldataWordReader (decoder, offset) -> _result {
        let _v1003
        _v1003 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v1003
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$calldataLarrayLuint256JJ_CalldataWordReader (decoder, offset) -> _result {
        let _v1004
        _v1004 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v1004
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLbytesJ_CalldataWordReader (decoder, offset) -> _result {
        let _v1005
        _v1005 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v1005
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader (decoder, offset) -> _result {
        let _v1006
        _v1006 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v1006
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$uint256_CalldataWordReader (decoder, offset) -> _result {
        let _v1007
        _v1007 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v1007
        leave
      }
      function usr$WordReader_advance$CalldataWordReader (reader, offset) -> _result {
        let _v1008
        _v1008 := usr$Add_add$word(reader, offset)
        _result := _v1008
        leave
      }
      function usr$WordReader_copyToMem$CalldataWordReader (reader, dst, cnt) {
        usr$calldatacopy(dst, reader, cnt)
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$address_CalldataWordReader (decoder) -> _result {
        let _v1009
        _v1009 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v1009
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$calldataLarrayLaddressJJ_CalldataWordReader (decoder) -> _result {
        let _v1010
        _v1010 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v1010
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$calldataLarrayLmemoryLbytesJJJ_CalldataWordReader (decoder) -> _result {
        let _v1011
        _v1011 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v1011
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$calldataLarrayLuint256JJ_CalldataWordReader (decoder) -> _result {
        let _v1012
        _v1012 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v1012
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$memoryLbytesJ_CalldataWordReader (decoder) -> _result {
        let _v1013
        _v1013 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v1013
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader (decoder) -> _result {
        let _v1014
        _v1014 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v1014
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$uint256_CalldataWordReader (decoder) -> _result {
        let _v1015
        _v1015 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v1015
        leave
      }
      function usr$WordReader_read$CalldataWordReader (reader) -> _result {
        let _v1016
        _v1016 := usr$calldataload(reader)
        _result := _v1016
        leave
      }
      function usr$abiArrayGet$address_address (a, i) -> _result {
        let _v1017
        _v1017 := usr$abiArrayLength$address(a)
        let _v1018
        _v1018 := usr$lt$uint256(i, _v1017)
        usr$require(_v1018, false, 2136126143, 911)
        let base
        let _v1019
        _v1019 := usr$Typedef_rep$calldataLtJ$arrayLaddressJ(a)
        base := _v1019
        let elemRegion
        let _v1020
        _v1020 := usr$Add_add$word(base, 32)
        elemRegion := _v1020
        let idx
        let _v1021
        _v1021 := usr$Typedef_rep$uint256(i)
        idx := _v1021
        let _v1022
        _v1022 := true
        switch true
          case false {let _v1023
                      _v1023 := elemRegion
                      let _v1024
                      _v1024 := _v1023
                      let _v1025
                      _v1025 := usr$Mul_mul$word(idx, 32)
                      let _v1026
                      _v1026 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader(_v1024, _v1025)
                      _result := _v1026
                      leave}
          case true {let _v1027
                     _v1027 := elemRegion
                     let _v1028
                     _v1028 := _v1027
                     let _v1029
                     _v1029 := usr$Mul_mul$word(idx, 32)
                     let _v1030
                     _v1030 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader(_v1028, _v1029)
                     _result := _v1030
                     leave}
      }
      function usr$abiArrayGet$memoryLbytesJ_memoryLbytesJ (a, i) -> _result {
        let _v1031
        _v1031 := usr$abiArrayLength$memoryLbytesJ(a)
        let _v1032
        _v1032 := usr$lt$uint256(i, _v1031)
        usr$require(_v1032, false, 2136126143, 911)
        let base
        let _v1033
        _v1033 := usr$Typedef_rep$calldataLtJ$arrayLmemoryLbytesJJ(a)
        base := _v1033
        let elemRegion
        let _v1034
        _v1034 := usr$Add_add$word(base, 32)
        elemRegion := _v1034
        let idx
        let _v1035
        _v1035 := usr$Typedef_rep$uint256(i)
        idx := _v1035
        let _v1036
        _v1036 := false
        switch false
          case false {let _v1037
                      _v1037 := elemRegion
                      let _v1038
                      _v1038 := _v1037
                      let _v1039
                      _v1039 := usr$Mul_mul$word(idx, 32)
                      let _v1040
                      _v1040 := usr$ABIDecode_decode$ABIDecoderLmemoryLbytesJ_readerJ$CalldataWordReader(_v1038, _v1039)
                      _result := _v1040
                      leave}
          case true {let _v1041
                     _v1041 := elemRegion
                     let _v1042
                     _v1042 := _v1041
                     let _v1043
                     _v1043 := usr$Mul_mul$word(idx, 32)
                     let _v1044
                     _v1044 := usr$ABIDecode_decode$ABIDecoderLmemoryLbytesJ_readerJ$CalldataWordReader(_v1042, _v1043)
                     _result := _v1044
                     leave}
      }
      function usr$abiArrayGet$uint256_uint256 (a, i) -> _result {
        let _v1045
        _v1045 := usr$abiArrayLength$uint256(a)
        let _v1046
        _v1046 := usr$lt$uint256(i, _v1045)
        usr$require(_v1046, false, 2136126143, 911)
        let base
        let _v1047
        _v1047 := usr$Typedef_rep$calldataLtJ$arrayLuint256J(a)
        base := _v1047
        let elemRegion
        let _v1048
        _v1048 := usr$Add_add$word(base, 32)
        elemRegion := _v1048
        let idx
        let _v1049
        _v1049 := usr$Typedef_rep$uint256(i)
        idx := _v1049
        let _v1050
        _v1050 := true
        switch true
          case false {let _v1051
                      _v1051 := elemRegion
                      let _v1052
                      _v1052 := _v1051
                      let _v1053
                      _v1053 := usr$Mul_mul$word(idx, 32)
                      let _v1054
                      _v1054 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v1052, _v1053)
                      _result := _v1054
                      leave}
          case true {let _v1055
                     _v1055 := elemRegion
                     let _v1056
                     _v1056 := _v1055
                     let _v1057
                     _v1057 := usr$Mul_mul$word(idx, 32)
                     let _v1058
                     _v1058 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v1056, _v1057)
                     _result := _v1058
                     leave}
      }
      function usr$abiArrayLength$address (a) -> _result {
        let _v1059
        let _v1060
        _v1060 := usr$Typedef_rep$calldataLtJ$arrayLaddressJ(a)
        _v1059 := _v1060
        let _v1061
        _v1061 := usr$WordReader_read$CalldataWordReader(_v1059)
        _result := _v1061
        leave
      }
      function usr$abiArrayLength$memoryLbytesJ (a) -> _result {
        let _v1062
        let _v1063
        _v1063 := usr$Typedef_rep$calldataLtJ$arrayLmemoryLbytesJJ(a)
        _v1062 := _v1063
        let _v1064
        _v1064 := usr$WordReader_read$CalldataWordReader(_v1062)
        _result := _v1064
        leave
      }
      function usr$abiArrayLength$uint256 (a) -> _result {
        let _v1065
        let _v1066
        _v1066 := usr$Typedef_rep$calldataLtJ$arrayLuint256J(a)
        _v1065 := _v1066
        let _v1067
        _v1067 := usr$WordReader_read$CalldataWordReader(_v1065)
        _result := _v1067
        leave
      }
      function usr$abi_decode$calldataLbytesJ_address_CalldataWordReader_address (decodable) -> _result {
        let _v1068
        let _v1069
        _v1069 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v1068 := _v1069
        let _v1070
        _v1070 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader(_v1068, 0)
        _result := _v1070
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ (decodable) -> _v1071, _v1072 {
        let _v1073
        let _v1074
        _v1074 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v1073 := _v1074
        let _v1075
        let _v1076
        _v1075, _v1076 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_address_CalldataWordReader_uint256_address(_v1073, 0)
        _v1071 := _v1075
        _v1072 := _v1076
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_memoryLstringJJ_CalldataWordReader_pairLuint256_memoryLstringJJ (decodable) -> _v1077, _v1078 {
        let _v1079
        let _v1080
        _v1080 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v1079 := _v1080
        let _v1081
        let _v1082
        _v1081, _v1082 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_memoryLstringJ_CalldataWordReader_uint256_memoryLstringJ(_v1079, 0)
        _v1077 := _v1081
        _v1078 := _v1082
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_CalldataWordReader_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ (decodable) -> _v1083, _v1084, _v1085, _v1086, _v1087 {
        let _v1088
        let _v1089
        _v1089 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v1088 := _v1089
        let _v1090
        let _v1091
        let _v1092
        let _v1093
        let _v1094
        _v1090, _v1091, _v1092, _v1093, _v1094 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJ_CalldataWordReader_uint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJ(_v1088, 0)
        _v1083 := _v1090
        _v1084 := _v1091
        _v1085 := _v1092
        _v1086 := _v1093
        _v1087 := _v1094
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_CalldataWordReader_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ (decodable) -> _v1095, _v1096, _v1097, _v1098, _v1099 {
        let _v1100
        let _v1101
        _v1101 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v1100 := _v1101
        let _v1102
        let _v1103
        let _v1104
        let _v1105
        let _v1106
        _v1102, _v1103, _v1104, _v1105, _v1106 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJ_CalldataWordReader_uint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJ(_v1100, 0)
        _v1095 := _v1102
        _v1096 := _v1103
        _v1097 := _v1104
        _v1098 := _v1105
        _v1099 := _v1106
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_CalldataWordReader_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ (decodable) -> _v1107, _v1108, _v1109, _v1110, _v1111, _v1112, _v1113 {
        let _v1114
        let _v1115
        _v1115 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v1114 := _v1115
        let _v1116
        let _v1117
        let _v1118
        let _v1119
        let _v1120
        let _v1121
        let _v1122
        _v1116, _v1117, _v1118, _v1119, _v1120, _v1121, _v1122 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ(_v1114, 0)
        _v1107 := _v1116
        _v1108 := _v1117
        _v1109 := _v1118
        _v1110 := _v1119
        _v1111 := _v1120
        _v1112 := _v1121
        _v1113 := _v1122
        leave
      }
      function usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256 (decodable) -> _result {
        let _v1123
        let _v1124
        _v1124 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v1123 := _v1124
        let _v1125
        _v1125 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v1123, 0)
        _result := _v1125
        leave
      }
      function usr$abi_encode$address (val) -> _result {
        let free
        let _v1126
        _v1126 := usr$get_free_memory()
        free := _v1126
        let tail
        let _v1127
        _v1127 := usr$Add_add$word(free, 32)
        let _v1128
        _v1128 := usr$ABIEncode_encodeInto$address(val, free, 0, _v1127)
        tail := _v1128
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$memoryLstringJ (val) -> _result {
        let free
        let _v1129
        _v1129 := usr$get_free_memory()
        free := _v1129
        let tail
        let _v1130
        _v1130 := usr$Add_add$word(free, 32)
        let _v1131
        _v1131 := usr$ABIEncode_encodeInto$memoryLstringJ(val, free, 0, _v1130)
        tail := _v1131
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ (_v1132, _v1133, _v1134, _v1135, _v1136, _v1137, _v1138) -> _result {
        let free
        let _v1139
        _v1139 := usr$get_free_memory()
        free := _v1139
        let tail
        let _v1140
        _v1140 := usr$Add_add$word(free, 224)
        let _v1141
        _v1141 := usr$ABIEncode_encodeInto$pairLa_bJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(_v1132, _v1133, _v1134, _v1135, _v1136, _v1137, _v1138, free, 0, _v1140)
        tail := _v1141
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$sumLunit_unitJ (_v1142) -> _result {
        let free
        let _v1143
        _v1143 := usr$get_free_memory()
        free := _v1143
        let tail
        let _v1144
        _v1144 := usr$Add_add$word(free, 32)
        let _v1145
        _v1145 := usr$ABIEncode_encodeInto$sumLunit_unitJ(_v1142, free, 0, _v1144)
        tail := _v1145
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$uint256 (val) -> _result {
        let free
        let _v1146
        _v1146 := usr$get_free_memory()
        free := _v1146
        let tail
        let _v1147
        _v1147 := usr$Add_add$word(free, 32)
        let _v1148
        _v1148 := usr$ABIEncode_encodeInto$uint256(val, free, 0, _v1147)
        tail := _v1148
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$unit () -> _result {
        let free
        let _v1149
        _v1149 := usr$get_free_memory()
        free := _v1149
        let tail
        let _v1150
        _v1150 := usr$Add_add$word(free, 0)
        let _v1151
        _v1151 := usr$ABIEncode_encodeInto$unit(free, 0, _v1150)
        tail := _v1151
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$add (a, b) -> _result {
        let res
        res := add(a, b)
        _result := res
        leave
      }
      function usr$addCk (x, y) -> _result {
        let _v1152
        let _v1153
        _v1153 := usr$Add_add$uint256(x, y)
        _v1152 := _v1153
        let _v1154
        let _v1155
        _v1155 := usr$lt$uint256(_v1152, x)
        _v1154 := _v1155
        switch _v1154
          case false {}
          case true {usr$panic(17)}
        _result := _v1152
        leave
      }
      function usr$addOperator (eid, operator) {
        usr$setOperatorInner(eid, operator, true)
        leave
      }
      function usr$addWord (l, r) -> _result {
        let _v1156
        _v1156 := usr$add(l, r)
        _result := _v1156
        leave
      }
      function usr$address_ () -> _result {
        let res
        res := address()
        _result := res
        leave
      }
      function usr$allocate_memory (size) -> _result {
        let ptr
        let _v1157
        _v1157 := usr$get_free_memory()
        ptr := _v1157
        let _v1158
        _v1158 := usr$Add_add$word(ptr, size)
        usr$set_free_memory(_v1158)
        _result := ptr
        leave
      }
      function usr$and (_v1159, _v1160) -> _v1161 {
        switch _v1159
          case false {_v1161 := false
                      leave}
          case true {_v1161 := _v1160
                     leave}
      }
      function usr$and_ (a, b) -> _result {
        let res
        res := and(a, b)
        _result := res
        leave
      }
      function usr$attendees (eid, a) -> _result {
        let _v1162
        _v1162 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
        let _v1163
        let _v1164
        let _v1165
        let _v1166
        _v1163, _v1164, _v1165, _v1166 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1162, a)
        let _v1167
        _v1167 := usr$statusOrd(_v1163, _v1164, _v1165, _v1166)
        _result := _v1167
        leave
      }
      function usr$balanceSelf () -> _result {
        let _v1168
        _v1168 := usr$selfbalance()
        _result := _v1168
        leave
      }
      function usr$bumpCheckedIn (eid, n) {
        let _v1169
        let _v1170
        _v1170 := usr$Eq_eq$uint256(n, 0)
        _v1169 := _v1170
        switch _v1169
          case false {}
          case true {leave}
        let _v1171
        let _v1172
        let _v1173
        let _v1174
        let _v1175
        let _v1176
        let _v1177
        let _v1178
        _v1175, _v1176, _v1177, _v1178 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v1171 := _v1175
        _v1172 := _v1176
        _v1173 := _v1177
        _v1174 := _v1178
        let _v1179
        _v1179 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
        let _v1180
        _v1180 := usr$Add_add$uint256(_v1172, n)
        usr$Assign_assign$a$storageLCountersJ_Counters(_v1179, _v1171, _v1180, _v1173, _v1174)
      }
      function usr$calcReward (reg, chk, dep) -> _result {
        let _v1181
        let _v1182
        _v1182 := usr$Eq_eq$uint256(chk, 0)
        _v1181 := _v1182
        switch _v1181
          case false {}
          case true {_result := 0
                     leave}
        let _v1183
        let _v1184
        _v1184 := usr$subCk(reg, chk)
        _v1183 := _v1184
        let _v1185
        _v1185 := usr$mulCk(_v1183, dep)
        let _v1186
        _v1186 := usr$Div_div$uint256(_v1185, chk)
        _result := _v1186
        leave
      }
      function usr$call (a, b, c, d, e, f, g) -> _result {
        let res
        res := call(a, b, c, d, e, f, g)
        _result := res
        leave
      }
      function usr$calldatacopy (a, b, c) { calldatacopy(a, b, c) }
      function usr$calldataload (a) -> _result {
        let res
        res := calldataload(a)
        _result := res
        leave
      }
      function usr$calldatasize () -> _result {
        let res
        res := calldatasize()
        _result := res
        leave
      }
      function usr$caller () -> _result {
        let _v1187
        _v1187 := usr$caller_()
        _result := _v1187
        leave
      }
      function usr$caller_ () -> _result {
        let res
        res := caller()
        _result := res
        leave
      }
      function usr$caller_value () -> _result {
        let _v1188
        _v1188 := usr$callvalue_()
        _result := _v1188
        leave
      }
      function usr$callvalue () -> _result {
        let res
        res := callvalue()
        _result := res
        leave
      }
      function usr$callvalue_ () -> _result {
        let res
        res := callvalue()
        _result := res
        leave
      }
      function usr$cancel (eid) {
        let _v1189
        let _v1190
        let _v1191
        let _v1192
        let _v1193
        let _v1194
        let _v1195
        let _v1196
        let _v1197
        let _v1198
        let _v1199
        let _v1200
        let _v1201
        let _v1202
        let _v1203
        let _v1204
        _v1197, _v1198, _v1199, _v1200, _v1201, _v1202, _v1203, _v1204 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1189 := _v1197
        _v1190 := _v1198
        _v1191 := _v1199
        _v1192 := _v1200
        _v1193 := _v1201
        _v1194 := _v1202
        _v1195 := _v1203
        _v1196 := _v1204
        switch _v1189
          case false {usr$revertNotFound()}
          case true {let _v1205
                     _v1205 := usr$timeNow()
                     let _v1206
                     _v1206 := usr$le$uint256(_v1205, _v1192)
                     usr$requireK(_v1206, 1320495838)
                     let _v1207
                     _v1207 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1208
                     _v1208 := usr$caller()
                     let _v1209
                     let _v1210
                     let _v1211
                     let _v1212
                     _v1209, _v1210, _v1211, _v1212 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1207, _v1208)
                     usr$requireStatus(_v1209, _v1210, _v1211, _v1212, 1)
                     let _v1213
                     _v1213 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1214
                     _v1214 := usr$caller()
                     let _v1215
                     _v1215 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1213, _v1214)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1215, true, true, false, 911)
                     let _v1216
                     let _v1217
                     let _v1218
                     let _v1219
                     let _v1220
                     let _v1221
                     let _v1222
                     let _v1223
                     _v1220, _v1221, _v1222, _v1223 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1216 := _v1220
                     _v1217 := _v1221
                     _v1218 := _v1222
                     _v1219 := _v1223
                     let _v1224
                     _v1224 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v1225
                     _v1225 := usr$Sub_sub$uint256(_v1216, 1)
                     let _v1226
                     _v1226 := usr$subCk(_v1219, _v1191)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1224, _v1225, _v1217, _v1218, _v1226)
                     let _v1227
                     _v1227 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1228
                     _v1228 := usr$subCk(_v1227, _v1191)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1228)
                     let _v1229
                     _v1229 := usr$caller()
                     usr$sendValue(_v1229, _v1191)
                     let _v1230
                     _v1230 := usr$balanceSelf()
                     let _v1231
                     _v1231 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1232
                     _v1232 := usr$ge$uint256(_v1230, _v1231)
                     usr$solAssert(_v1232)
                     let _v1233
                     _v1233 := usr$Typedef_rep$uint256(eid)
                     let _v1234
                     _v1234 := usr$caller()
                     let _v1235
                     _v1235 := usr$Typedef_rep$address(_v1234)
                     usr$emitLog3(49258998252148748962151988473322413374541890325925337282821714030898856777338, _v1233, _v1235)}
      }
      function usr$cancelEvent (eid) {
        let _v1236
        let _v1237
        let _v1238
        let _v1239
        let _v1240
        let _v1241
        let _v1242
        let _v1243
        let _v1244
        let _v1245
        let _v1246
        let _v1247
        let _v1248
        let _v1249
        let _v1250
        let _v1251
        _v1244, _v1245, _v1246, _v1247, _v1248, _v1249, _v1250, _v1251 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1236 := _v1244
        _v1237 := _v1245
        _v1238 := _v1246
        _v1239 := _v1247
        _v1240 := _v1248
        _v1241 := _v1249
        _v1242 := _v1250
        _v1243 := _v1251
        switch _v1236
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v1237)
                     let _v1252
                     _v1252 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v1253
                     let _v1254
                     let _v1255
                     let _v1256
                     _v1253, _v1254, _v1255, _v1256 := usr$deriveState(_v1252, _v1240, _v1241, _v1242)
                     let _v1257
                     _v1257 := usr$stateOrd(_v1253, _v1254, _v1255, _v1256)
                     let _v1258
                     _v1258 := usr$Eq_eq$uint256(_v1257, 0)
                     usr$requireK(_v1258, 2829790501)
                     let _v1259
                     _v1259 := usr$lidx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_storageLsumLunit_unitJJ(5, eid)
                     usr$Assign_assign$a$storageLsumLunit_unitJJ_sumLunit_unitJ(_v1259, true)
                     let _v1260
                     _v1260 := usr$Typedef_rep$uint256(eid)
                     usr$emitLog2(99616089577665513926284212068781508364134431091285324813305771500819559365945, _v1260)}
      }
      function usr$cancelled (eid) -> _v1261 {
        let _v1262
        _v1262 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
        _v1261 := _v1262
        leave
      }
      function usr$chainId () -> _result {
        let _v1263
        _v1263 := usr$chainid_()
        _result := _v1263
        leave
      }
      function usr$chainid_ () -> _result {
        let res
        res := chainid()
        _result := res
        leave
      }
      function usr$checkIn (eid, a) {
        let _v1264
        let _v1265
        let _v1266
        let _v1267
        let _v1268
        let _v1269
        let _v1270
        let _v1271
        let _v1272
        let _v1273
        let _v1274
        let _v1275
        let _v1276
        let _v1277
        let _v1278
        let _v1279
        _v1272, _v1273, _v1274, _v1275, _v1276, _v1277, _v1278, _v1279 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1264 := _v1272
        _v1265 := _v1273
        _v1266 := _v1274
        _v1267 := _v1275
        _v1268 := _v1276
        _v1269 := _v1277
        _v1270 := _v1278
        _v1271 := _v1279
        switch _v1264
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v1265)
                     let _v1280
                     _v1280 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     usr$requireCheckInOpen(_v1280, _v1268, _v1269, _v1270)
                     let _v1281
                     _v1281 := usr$checkInInner(eid, a)
                     usr$bumpCheckedIn(eid, _v1281)}
      }
      function usr$checkInBatchImpl () {
        let _v1282
        let _v1283
        _v1283 := usr$calldataload(4)
        _v1282 := _v1283
        let _v1284
        let _v1285
        let _v1286
        let _v1287
        let _v1288
        let _v1289
        let _v1290
        let _v1291
        let _v1292
        let _v1293
        let _v1294
        let _v1295
        let _v1296
        let _v1297
        let _v1298
        let _v1299
        _v1292, _v1293, _v1294, _v1295, _v1296, _v1297, _v1298, _v1299 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, _v1282)
        _v1284 := _v1292
        _v1285 := _v1293
        _v1286 := _v1294
        _v1287 := _v1295
        _v1288 := _v1296
        _v1289 := _v1297
        _v1290 := _v1298
        _v1291 := _v1299
        switch _v1284
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v1285)
                     let _v1300
                     _v1300 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, _v1282)
                     usr$requireCheckInOpen(_v1300, _v1288, _v1289, _v1290)
                     let lenPtr
                     let _v1301
                     _v1301 := usr$calldataload(36)
                     let _v1302
                     _v1302 := usr$Add_add$word(4, _v1301)
                     lenPtr := _v1302
                     let len
                     let _v1303
                     _v1303 := usr$calldataload(lenPtr)
                     len := _v1303
                     let maxB
                     maxB := 100
                     let _v1304
                     let _v1305
                     _v1305 := usr$Ord_gt$word(len, 100)
                     _v1304 := _v1305
                     switch _v1304
                       case false {}
                       case true {usr$revertWith2(3139221259, len, 100)}
                     let _v1306
                     _v1306 := 0
                     for {let i i := 0 let _v1307 let _v1308 _v1307 := usr$lt$word(i, len)} _v1307 {_v1308 := usr$Add_add$word(i, 1) i := _v1308 _v1307 := usr$lt$word(i, len)}
                     {let w
                      let _v1309
                      _v1309 := usr$Add_add$word(lenPtr, 32)
                      let _v1310
                      _v1310 := usr$Mul_mul$word(i, 32)
                      let _v1311
                      _v1311 := usr$Add_add$word(_v1309, _v1310)
                      let _v1312
                      _v1312 := usr$calldataload(_v1311)
                      w := _v1312
                      let _v1313
                      _v1313 := usr$shr(160, w)
                      let _v1314
                      _v1314 := usr$Eq_eq$word(_v1313, 0)
                      usr$requireK(_v1314, 2092978087)
                      let _v1315
                      _v1315 := usr$checkInInner(_v1282, w)
                      let _v1316
                      _v1316 := usr$Add_add$uint256(_v1306, _v1315)
                      _v1306 := _v1316}
                     usr$bumpCheckedIn(_v1282, _v1306)}
      }
      function usr$checkInBatchWithProofs (eid, toCheck, validUntils, ticketSigs, presenceSigs) {
        let _v1317
        let _v1318
        let _v1319
        let _v1320
        let _v1321
        let _v1322
        let _v1323
        let _v1324
        let _v1325
        let _v1326
        let _v1327
        let _v1328
        let _v1329
        let _v1330
        let _v1331
        let _v1332
        _v1325, _v1326, _v1327, _v1328, _v1329, _v1330, _v1331, _v1332 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1317 := _v1325
        _v1318 := _v1326
        _v1319 := _v1327
        _v1320 := _v1328
        _v1321 := _v1329
        _v1322 := _v1330
        _v1323 := _v1331
        _v1324 := _v1332
        switch _v1317
          case false {usr$revertNotFound()}
          case true {let _v1333
                     _v1333 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     usr$requireCheckInOpen(_v1333, _v1321, _v1322, _v1323)
                     let _v1334
                     let _v1335
                     _v1335 := usr$Length_length$calldataLarrayLtJJ$address(toCheck)
                     _v1334 := _v1335
                     let _v1336
                     _v1336 := usr$Length_length$calldataLarrayLtJJ$uint256(validUntils)
                     let _v1337
                     _v1337 := usr$Eq_eq$uint256(_v1336, _v1334)
                     usr$requireK(_v1337, 812734401)
                     let _v1338
                     _v1338 := usr$Length_length$calldataLarrayLtJJ$memoryLbytesJ(ticketSigs)
                     let _v1339
                     _v1339 := usr$Eq_eq$uint256(_v1338, _v1334)
                     usr$requireK(_v1339, 812734401)
                     let _v1340
                     _v1340 := usr$Length_length$calldataLarrayLtJJ$memoryLbytesJ(presenceSigs)
                     let _v1341
                     _v1341 := usr$Eq_eq$uint256(_v1340, _v1334)
                     usr$requireK(_v1341, 812734401)
                     let _v1342
                     let _v1343
                     _v1343 := usr$Ord_gt$uint256(_v1334, 100)
                     _v1342 := _v1343
                     switch _v1342
                       case false {}
                       case true {let _v1344
                                  _v1344 := usr$Typedef_rep$uint256(_v1334)
                                  usr$revertWith2(3139221259, _v1344, 100)}
                     let _v1345
                     let _v1346
                     _v1346 := usr$domainSep()
                     _v1345 := _v1346
                     let _v1347
                     _v1347 := 0
                     for {let _v1348 _v1348 := 0 let _v1349 let _v1350 _v1349 := usr$lt$uint256(_v1348, _v1334)} _v1349 {_v1350 := usr$Add_add$uint256(_v1348, 1) _v1348 := _v1350 _v1349 := usr$lt$uint256(_v1348, _v1334)}
                     {let _v1351
                      let _v1352
                      _v1352 := usr$ridx$calldataLarrayLaddressJJ_uint256_address(toCheck, _v1348)
                      _v1351 := _v1352
                      let _v1353
                      _v1353 := usr$ridx$calldataLarrayLuint256JJ_uint256_uint256(validUntils, _v1348)
                      let _v1354
                      _v1354 := usr$ridx$calldataLarrayLmemoryLbytesJJJ_uint256_memoryLbytesJ(ticketSigs, _v1348)
                      let _v1355
                      _v1355 := usr$ridx$calldataLarrayLmemoryLbytesJJJ_uint256_memoryLbytesJ(presenceSigs, _v1348)
                      usr$verifyProof(eid, _v1318, _v1345, _v1351, _v1353, _v1354, _v1355)
                      let _v1356
                      _v1356 := usr$checkInInner(eid, _v1351)
                      let _v1357
                      _v1357 := usr$Add_add$uint256(_v1347, _v1356)
                      _v1347 := _v1357}
                     usr$bumpCheckedIn(eid, _v1347)}
      }
      function usr$checkInInner (eid, a) -> _result {
        let _v1358
        let _v1359
        _v1359 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
        let _v1360
        let _v1361
        let _v1362
        let _v1363
        _v1360, _v1361, _v1362, _v1363 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1359, a)
        let _v1364
        _v1364 := usr$statusOrd(_v1360, _v1361, _v1362, _v1363)
        let _v1365
        _v1365 := usr$Eq_eq$uint256(_v1364, 1)
        _v1358 := _v1365
        switch _v1358
          case false {}
          case true {let _v1366
                     _v1366 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1367
                     _v1367 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1366, a)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1367, true, true, true, false)
                     let _v1368
                     _v1368 := usr$Typedef_rep$uint256(eid)
                     let _v1369
                     _v1369 := usr$Typedef_rep$address(a)
                     usr$emitLog3(50872910645629032543601523280981675582310894594853385402616470856132378936092, _v1368, _v1369)
                     _result := 1
                     leave}
        _result := 0
        leave
      }
      function usr$checkInWithProof (eid, attendee, validUntil, ticketSig, presenceSig) {
        let _v1370
        let _v1371
        let _v1372
        let _v1373
        let _v1374
        let _v1375
        let _v1376
        let _v1377
        let _v1378
        let _v1379
        let _v1380
        let _v1381
        let _v1382
        let _v1383
        let _v1384
        let _v1385
        _v1378, _v1379, _v1380, _v1381, _v1382, _v1383, _v1384, _v1385 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1370 := _v1378
        _v1371 := _v1379
        _v1372 := _v1380
        _v1373 := _v1381
        _v1374 := _v1382
        _v1375 := _v1383
        _v1376 := _v1384
        _v1377 := _v1385
        switch _v1370
          case false {usr$revertNotFound()}
          case true {let _v1386
                     _v1386 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     usr$requireCheckInOpen(_v1386, _v1374, _v1375, _v1376)
                     let _v1387
                     _v1387 := usr$domainSep()
                     usr$verifyProof(eid, _v1371, _v1387, attendee, validUntil, ticketSig, presenceSig)
                     let _v1388
                     _v1388 := usr$checkInInner(eid, attendee)
                     usr$bumpCheckedIn(eid, _v1388)}
      }
      function usr$checkedInCount (eid) -> _result {
        let _v1389
        let _v1390
        let _v1391
        let _v1392
        let _v1393
        let _v1394
        let _v1395
        let _v1396
        _v1393, _v1394, _v1395, _v1396 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v1389 := _v1393
        _v1390 := _v1394
        _v1391 := _v1395
        _v1392 := _v1396
        _result := _v1390
        leave
      }
      function usr$claim (eid) {
        let _v1397
        let _v1398
        let _v1399
        let _v1400
        let _v1401
        let _v1402
        let _v1403
        let _v1404
        let _v1405
        let _v1406
        let _v1407
        let _v1408
        let _v1409
        let _v1410
        let _v1411
        let _v1412
        _v1405, _v1406, _v1407, _v1408, _v1409, _v1410, _v1411, _v1412 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1397 := _v1405
        _v1398 := _v1406
        _v1399 := _v1407
        _v1400 := _v1408
        _v1401 := _v1409
        _v1402 := _v1410
        _v1403 := _v1411
        _v1404 := _v1412
        switch _v1397
          case false {usr$revertNotFound()}
          case true {let _v1413
                     _v1413 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v1414
                     let _v1415
                     let _v1416
                     let _v1417
                     _v1414, _v1415, _v1416, _v1417 := usr$deriveState(_v1413, _v1401, _v1402, _v1403)
                     let _v1418
                     _v1418 := usr$stateOrd(_v1414, _v1415, _v1416, _v1417)
                     let _v1419
                     _v1419 := usr$Eq_eq$uint256(_v1418, 3)
                     usr$requireK(_v1419, 3123878555)
                     let _v1420
                     _v1420 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1421
                     _v1421 := usr$caller()
                     let _v1422
                     let _v1423
                     let _v1424
                     let _v1425
                     _v1422, _v1423, _v1424, _v1425 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1420, _v1421)
                     usr$requireStatus(_v1422, _v1423, _v1424, _v1425, 3)
                     let _v1426
                     _v1426 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1427
                     _v1427 := usr$caller()
                     let _v1428
                     _v1428 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1426, _v1427)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1428, true, true, true, true)
                     let _v1429
                     let _v1430
                     let _v1431
                     let _v1432
                     let _v1433
                     let _v1434
                     let _v1435
                     let _v1436
                     _v1433, _v1434, _v1435, _v1436 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1429 := _v1433
                     _v1430 := _v1434
                     _v1431 := _v1435
                     _v1432 := _v1436
                     let _v1437
                     let _v1438
                     _v1438 := usr$calcReward(_v1429, _v1430, _v1399)
                     let _v1439
                     _v1439 := usr$addCk(_v1399, _v1438)
                     _v1437 := _v1439
                     let _v1440
                     _v1440 := usr$le$uint256(_v1437, _v1432)
                     usr$requireK(_v1440, 3276456545)
                     let _v1441
                     _v1441 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v1442
                     _v1442 := usr$Add_add$uint256(_v1431, 1)
                     let _v1443
                     _v1443 := usr$subCk(_v1432, _v1437)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1441, _v1429, _v1430, _v1442, _v1443)
                     let _v1444
                     _v1444 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1445
                     _v1445 := usr$subCk(_v1444, _v1437)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1445)
                     let _v1446
                     _v1446 := usr$caller()
                     usr$sendValue(_v1446, _v1437)
                     let _v1447
                     _v1447 := usr$balanceSelf()
                     let _v1448
                     _v1448 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1449
                     _v1449 := usr$ge$uint256(_v1447, _v1448)
                     usr$solAssert(_v1449)
                     let _v1450
                     _v1450 := usr$Typedef_rep$uint256(eid)
                     let _v1451
                     _v1451 := usr$caller()
                     let _v1452
                     _v1452 := usr$Typedef_rep$address(_v1451)
                     let _v1453
                     _v1453 := usr$Typedef_rep$uint256(_v1437)
                     usr$emitLog3W1(35635639126918266826417363157745207966733923402123826568285639076591142096934, _v1450, _v1452, _v1453)}
      }
      function usr$claimDust (eid) {
        let _v1454
        let _v1455
        let _v1456
        let _v1457
        let _v1458
        let _v1459
        let _v1460
        let _v1461
        let _v1462
        let _v1463
        let _v1464
        let _v1465
        let _v1466
        let _v1467
        let _v1468
        let _v1469
        _v1462, _v1463, _v1464, _v1465, _v1466, _v1467, _v1468, _v1469 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1454 := _v1462
        _v1455 := _v1463
        _v1456 := _v1464
        _v1457 := _v1465
        _v1458 := _v1466
        _v1459 := _v1467
        _v1460 := _v1468
        _v1461 := _v1469
        switch _v1454
          case false {usr$revertNotFound()}
          case true {let _v1470
                     _v1470 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v1471
                     let _v1472
                     let _v1473
                     let _v1474
                     _v1471, _v1472, _v1473, _v1474 := usr$deriveState(_v1470, _v1458, _v1459, _v1460)
                     let _v1475
                     _v1475 := usr$stateOrd(_v1471, _v1472, _v1473, _v1474)
                     let _v1476
                     _v1476 := usr$Eq_eq$uint256(_v1475, 3)
                     usr$requireK(_v1476, 3123878555)
                     let _v1477
                     let _v1478
                     let _v1479
                     let _v1480
                     let _v1481
                     let _v1482
                     let _v1483
                     let _v1484
                     _v1481, _v1482, _v1483, _v1484 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1477 := _v1481
                     _v1478 := _v1482
                     _v1479 := _v1483
                     _v1480 := _v1484
                     let _v1485
                     let _v1486
                     _v1486 := usr$Eq_eq$uint256(_v1479, _v1478)
                     _v1485 := _v1486
                     let _v1487
                     let _v1488
                     _v1488 := usr$timeNow()
                     let _v1489
                     _v1489 := usr$addCk(_v1459, _v1460)
                     let _v1490
                     _v1490 := usr$addCk(_v1489, 2592000)
                     let _v1491
                     _v1491 := usr$Ord_gt$uint256(_v1488, _v1490)
                     _v1487 := _v1491
                     let _v1492
                     let _v1493
                     _v1493 := usr$not(_v1485)
                     let _v1494
                     _v1494 := usr$not(_v1487)
                     let _v1495
                     _v1495 := usr$and(_v1493, _v1494)
                     _v1492 := _v1495
                     switch _v1492
                       case false {}
                       case true {usr$fail(3985512035)}
                     let _v1496
                     _v1496 := _v1480
                     let _v1497
                     _v1497 := usr$ne$uint256(_v1496, 0)
                     usr$requireK(_v1497, 3985512035)
                     let _v1498
                     _v1498 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1498, _v1477, _v1478, _v1479, 0)
                     let _v1499
                     _v1499 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1500
                     _v1500 := usr$subCk(_v1499, _v1496)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1500)
                     let _v1501
                     _v1501 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
                     usr$sendValue(_v1501, _v1496)
                     let _v1502
                     _v1502 := usr$balanceSelf()
                     let _v1503
                     _v1503 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1504
                     _v1504 := usr$ge$uint256(_v1502, _v1503)
                     usr$solAssert(_v1504)
                     let _v1505
                     _v1505 := usr$Typedef_rep$uint256(eid)
                     let _v1506
                     _v1506 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
                     let _v1507
                     _v1507 := usr$Typedef_rep$address(_v1506)
                     let _v1508
                     _v1508 := usr$Typedef_rep$uint256(_v1496)
                     usr$emitLog3W1(65148424199380802297895668972783112174360658145439419530254325341241767658246, _v1505, _v1507, _v1508)}
      }
      function usr$claimRefund (eid) {
        let _v1509
        let _v1510
        let _v1511
        let _v1512
        let _v1513
        let _v1514
        let _v1515
        let _v1516
        let _v1517
        let _v1518
        let _v1519
        let _v1520
        let _v1521
        let _v1522
        let _v1523
        let _v1524
        _v1517, _v1518, _v1519, _v1520, _v1521, _v1522, _v1523, _v1524 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1509 := _v1517
        _v1510 := _v1518
        _v1511 := _v1519
        _v1512 := _v1520
        _v1513 := _v1521
        _v1514 := _v1522
        _v1515 := _v1523
        _v1516 := _v1524
        switch _v1509
          case false {usr$revertNotFound()}
          case true {let _v1525
                     _v1525 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     usr$requireK(_v1525, 3139381005)
                     let _v1526
                     _v1526 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1527
                     _v1527 := usr$caller()
                     let _v1528
                     let _v1529
                     let _v1530
                     let _v1531
                     _v1528, _v1529, _v1530, _v1531 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1526, _v1527)
                     usr$requireStatus(_v1528, _v1529, _v1530, _v1531, 1)
                     let _v1532
                     _v1532 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1533
                     _v1533 := usr$caller()
                     let _v1534
                     _v1534 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1532, _v1533)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1534, true, true, false, 911)
                     let _v1535
                     let _v1536
                     let _v1537
                     let _v1538
                     let _v1539
                     let _v1540
                     let _v1541
                     let _v1542
                     _v1539, _v1540, _v1541, _v1542 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1535 := _v1539
                     _v1536 := _v1540
                     _v1537 := _v1541
                     _v1538 := _v1542
                     let _v1543
                     _v1543 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v1544
                     _v1544 := usr$Sub_sub$uint256(_v1535, 1)
                     let _v1545
                     _v1545 := usr$subCk(_v1538, _v1511)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1543, _v1544, _v1536, _v1537, _v1545)
                     let _v1546
                     _v1546 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1547
                     _v1547 := usr$subCk(_v1546, _v1511)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1547)
                     let _v1548
                     _v1548 := usr$caller()
                     usr$sendValue(_v1548, _v1511)
                     let _v1549
                     _v1549 := usr$balanceSelf()
                     let _v1550
                     _v1550 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1551
                     _v1551 := usr$ge$uint256(_v1549, _v1550)
                     usr$solAssert(_v1551)
                     let _v1552
                     _v1552 := usr$Typedef_rep$uint256(eid)
                     let _v1553
                     _v1553 := usr$caller()
                     let _v1554
                     _v1554 := usr$Typedef_rep$address(_v1553)
                     let _v1555
                     _v1555 := usr$Typedef_rep$uint256(_v1511)
                     usr$emitLog3W1(110343147773003590039951001576381795264397980198489142373951635958240417622108, _v1552, _v1554, _v1555)}
      }
      function usr$claimedCount (eid) -> _result {
        let _v1556
        let _v1557
        let _v1558
        let _v1559
        let _v1560
        let _v1561
        let _v1562
        let _v1563
        _v1560, _v1561, _v1562, _v1563 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v1556 := _v1560
        _v1557 := _v1561
        _v1558 := _v1562
        _v1559 := _v1563
        _result := _v1558
        leave
      }
      function usr$concat$bytes32_bytes32 (x, y) -> _result {
        let x_len
        x_len := 32
        let y_len
        y_len := 32
        let res
        let _v1564
        _v1564 := usr$allocate_memory(96)
        res := _v1564
        usr$mstore(res, 64)
        let _v1565
        _v1565 := usr$Add_add$word(res, 32)
        usr$MemoryEncode_encodeInto$bytes32(x, _v1565)
        let _v1566
        _v1566 := usr$Add_add$word(res, 32)
        let _v1567
        _v1567 := usr$Add_add$word(_v1566, 32)
        usr$MemoryEncode_encodeInto$bytes32(y, _v1567)
        _result := res
        leave
      }
      function usr$concat$bytes32_memoryLbytesJ (x, y) -> _result {
        let x_len
        x_len := 32
        let y_len
        let _v1568
        _v1568 := usr$MemorySize_len$memoryLbytesJ(y)
        y_len := _v1568
        let res
        let _v1569
        _v1569 := usr$Add_add$word(64, y_len)
        let _v1570
        _v1570 := usr$allocate_memory(_v1569)
        res := _v1570
        let _v1571
        _v1571 := usr$Add_add$word(32, y_len)
        usr$mstore(res, _v1571)
        let _v1572
        _v1572 := usr$Add_add$word(res, 32)
        usr$MemoryEncode_encodeInto$bytes32(x, _v1572)
        let _v1573
        _v1573 := usr$Add_add$word(res, 32)
        let _v1574
        _v1574 := usr$Add_add$word(_v1573, 32)
        usr$MemoryEncode_encodeInto$memoryLbytesJ(y, _v1574)
        _result := res
        leave
      }
      function usr$createEvent (depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod, maxAttendees, metadataURI_) -> _result {
        usr$validateEventParams(depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod)
        let _v1575
        let _v1576
        _v1576 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_eventCount_sel_uint256_pairLaddress_unitJ()
        let _v1577
        _v1577 := usr$Add_add$uint256(_v1576, 1)
        _v1575 := _v1577
        usr$Assign_assign$a$storageLuint256J_uint256(1, _v1575)
        let _v1578
        _v1578 := usr$lidx$storageLmappingLuint256_EventRecJJ_uint256_storageLEventRecJ(3, _v1575)
        let _v1579
        _v1579 := usr$caller()
        usr$Assign_assign$a$storageLEventRecJ_EventRec(_v1578, true, _v1579, depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod, maxAttendees)
        usr$ArrayPush_push$storageLarrayLtJJ$string_memoryLstringJ(4, metadataURI_)
        let _v1580
        _v1580 := usr$Typedef_rep$uint256(_v1575)
        let _v1581
        _v1581 := usr$caller()
        let _v1582
        _v1582 := usr$Typedef_rep$address(_v1581)
        let _v1583
        _v1583 := usr$Typedef_rep$uint256(depositAmount)
        let _v1584
        _v1584 := usr$Typedef_rep$uint256(eventStart)
        let _v1585
        _v1585 := usr$Typedef_rep$uint256(eventEnd)
        usr$emitLog3W3(26039434587326103136200597718789237852261263058874806093281554555545441090759, _v1580, _v1582, _v1583, _v1584, _v1585)
        _result := _v1575
        leave
      }
      function usr$decodeBytesLike$bytes_CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let tmp
        let _v1586
        let _v1587
        _v1587 := usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLbytesJ_CalldataWordReader(ptr, currentHeadOffset)
        _v1586 := _v1587
        let tailPtr
        let _v1588
        _v1588 := usr$WordReader_read$ABIDecoderLty_readerJ$memoryLbytesJ_CalldataWordReader(_v1586)
        tailPtr := _v1588
        let _v1589
        let _v1590
        _v1590 := usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLbytesJ_CalldataWordReader(ptr, tailPtr)
        _v1589 := _v1590
        let _v1591
        let _v1592
        _v1592 := usr$getReader$memoryLbytesJ_CalldataWordReader(_v1589)
        _v1591 := _v1592
        let length
        let _v1593
        _v1593 := usr$WordReader_read$ABIDecoderLty_readerJ$memoryLbytesJ_CalldataWordReader(_v1589)
        length := _v1593
        let total
        let _v1594
        _v1594 := usr$Add_add$word(length, 32)
        total := _v1594
        let rounded
        let _v1595
        _v1595 := usr$round_up_to_mul_of_32(total)
        rounded := _v1595
        let resultPtr
        let _v1596
        _v1596 := usr$allocate_memory(rounded)
        resultPtr := _v1596
        usr$WordReader_copyToMem$CalldataWordReader(_v1591, resultPtr, total)
        _result := resultPtr
        leave
      }
      function usr$decodeBytesLike$string_CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let tmp
        let _v1597
        let _v1598
        _v1598 := usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(ptr, currentHeadOffset)
        _v1597 := _v1598
        let tailPtr
        let _v1599
        _v1599 := usr$WordReader_read$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(_v1597)
        tailPtr := _v1599
        let _v1600
        let _v1601
        _v1601 := usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(ptr, tailPtr)
        _v1600 := _v1601
        let _v1602
        let _v1603
        _v1603 := usr$getReader$memoryLstringJ_CalldataWordReader(_v1600)
        _v1602 := _v1603
        let length
        let _v1604
        _v1604 := usr$WordReader_read$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(_v1600)
        length := _v1604
        let total
        let _v1605
        _v1605 := usr$Add_add$word(length, 32)
        total := _v1605
        let rounded
        let _v1606
        _v1606 := usr$round_up_to_mul_of_32(total)
        rounded := _v1606
        let resultPtr
        let _v1607
        _v1607 := usr$allocate_memory(rounded)
        resultPtr := _v1607
        usr$WordReader_copyToMem$CalldataWordReader(_v1602, resultPtr, total)
        _result := resultPtr
        leave
      }
      function usr$deriveState (_v1608, eventStart, eventEnd, disputePeriod) -> _v1609, _v1610, _v1611, _v1612 {
        switch _v1608
          case false {}
          case true {_v1609 := true
                     _v1610 := true
                     _v1611 := true
                     _v1612 := true
                     leave}
        let _v1613
        let _v1614
        _v1614 := usr$timeNow()
        _v1613 := _v1614
        let _v1615
        let _v1616
        _v1616 := usr$lt$uint256(_v1613, eventStart)
        _v1615 := _v1616
        switch _v1615
          case false {}
          case true {_v1609 := false
                     leave}
        let _v1617
        let _v1618
        _v1618 := usr$le$uint256(_v1613, eventEnd)
        _v1617 := _v1618
        switch _v1617
          case false {}
          case true {_v1609 := true
                     _v1610 := false
                     leave}
        let _v1619
        let _v1620
        _v1620 := usr$addCk(eventEnd, disputePeriod)
        let _v1621
        _v1621 := usr$le$uint256(_v1613, _v1620)
        _v1619 := _v1621
        switch _v1619
          case false {}
          case true {_v1609 := true
                     _v1610 := true
                     _v1611 := false
                     leave}
        _v1609 := true
        _v1610 := true
        _v1611 := true
        _v1612 := false
        leave
      }
      function usr$div (a, b) -> _result {
        let res
        res := div(a, b)
        _result := res
        leave
      }
      function usr$do_exec$address_unit_t_setMaintainer528800 () {
        let _v1622
        _v1622 := usr$calldatasize()
        let _v1623
        _v1623 := usr$ge$word(_v1622, 36)
        usr$require(_v1623, false, 140739926, 911)
        let _v1624
        _v1624 := 4
        let _v1625
        let _v1626
        _v1626 := usr$abi_decode$calldataLbytesJ_address_CalldataWordReader_address(4)
        _v1625 := _v1626
        usr$invokable_invoke$t_setMaintainer528800(_v1625)
        let _v1627
        let _v1628
        _v1628 := usr$abi_encode$unit()
        _v1627 := _v1628
        let start
        let _v1629
        _v1629 := usr$Typedef_rep$memoryLtJ$bytes(_v1627)
        start := _v1629
        let end
        let _v1630
        _v1630 := usr$get_free_memory()
        end := _v1630
        let retSz
        let _v1631
        _v1631 := usr$Sub_sub$word(end, start)
        retSz := _v1631
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412 () {
        let _v1632
        _v1632 := usr$calldatasize()
        let _v1633
        _v1633 := usr$ge$word(_v1632, 68)
        usr$require(_v1633, false, 140739926, 911)
        let _v1634
        _v1634 := 4
        let _v1635
        let _v1636
        let _v1637
        let _v1638
        _v1637, _v1638 := usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ(4)
        _v1635 := _v1637
        _v1636 := _v1638
        let _v1639
        let _v1640
        _v1640 := usr$invokable_invoke$t_isOperator585412(_v1635, _v1636)
        _v1639 := _v1640
        let _v1641
        let _v1642
        _v1642 := usr$abi_encode$sumLunit_unitJ(_v1639)
        _v1641 := _v1642
        let start
        let _v1643
        _v1643 := usr$Typedef_rep$memoryLtJ$bytes(_v1641)
        start := _v1643
        let end
        let _v1644
        _v1644 := usr$get_free_memory()
        end := _v1644
        let retSz
        let _v1645
        _v1645 := usr$Sub_sub$word(end, start)
        retSz := _v1645
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_addressJ_uint256_t_attendees710234 () {
        let _v1646
        _v1646 := usr$calldatasize()
        let _v1647
        _v1647 := usr$ge$word(_v1646, 68)
        usr$require(_v1647, false, 140739926, 911)
        let _v1648
        _v1648 := 4
        let _v1649
        let _v1650
        let _v1651
        let _v1652
        _v1651, _v1652 := usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ(4)
        _v1649 := _v1651
        _v1650 := _v1652
        let _v1653
        let _v1654
        _v1654 := usr$invokable_invoke$t_attendees710234(_v1649, _v1650)
        _v1653 := _v1654
        let _v1655
        let _v1656
        _v1656 := usr$abi_encode$uint256(_v1653)
        _v1655 := _v1656
        let start
        let _v1657
        _v1657 := usr$Typedef_rep$memoryLtJ$bytes(_v1655)
        start := _v1657
        let end
        let _v1658
        _v1658 := usr$get_free_memory()
        end := _v1658
        let retSz
        let _v1659
        _v1659 := usr$Sub_sub$word(end, start)
        retSz := _v1659
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_addressJ_unit_t_addOperator715799 () {
        let _v1660
        _v1660 := usr$calldatasize()
        let _v1661
        _v1661 := usr$ge$word(_v1660, 68)
        usr$require(_v1661, false, 140739926, 911)
        let _v1662
        _v1662 := 4
        let _v1663
        let _v1664
        let _v1665
        let _v1666
        _v1665, _v1666 := usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ(4)
        _v1663 := _v1665
        _v1664 := _v1666
        usr$invokable_invoke$t_addOperator715799(_v1663, _v1664)
        let _v1667
        let _v1668
        _v1668 := usr$abi_encode$unit()
        _v1667 := _v1668
        let start
        let _v1669
        _v1669 := usr$Typedef_rep$memoryLtJ$bytes(_v1667)
        start := _v1669
        let end
        let _v1670
        _v1670 := usr$get_free_memory()
        end := _v1670
        let retSz
        let _v1671
        _v1671 := usr$Sub_sub$word(end, start)
        retSz := _v1671
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_addressJ_unit_t_checkIn684539 () {
        let _v1672
        _v1672 := usr$calldatasize()
        let _v1673
        _v1673 := usr$ge$word(_v1672, 68)
        usr$require(_v1673, false, 140739926, 911)
        let _v1674
        _v1674 := 4
        let _v1675
        let _v1676
        let _v1677
        let _v1678
        _v1677, _v1678 := usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ(4)
        _v1675 := _v1677
        _v1676 := _v1678
        usr$invokable_invoke$t_checkIn684539(_v1675, _v1676)
        let _v1679
        let _v1680
        _v1680 := usr$abi_encode$unit()
        _v1679 := _v1680
        let start
        let _v1681
        _v1681 := usr$Typedef_rep$memoryLtJ$bytes(_v1679)
        start := _v1681
        let end
        let _v1682
        _v1682 := usr$get_free_memory()
        end := _v1682
        let retSz
        let _v1683
        _v1683 := usr$Sub_sub$word(end, start)
        retSz := _v1683
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_addressJ_unit_t_removeOperator550233 () {
        let _v1684
        _v1684 := usr$calldatasize()
        let _v1685
        _v1685 := usr$ge$word(_v1684, 68)
        usr$require(_v1685, false, 140739926, 911)
        let _v1686
        _v1686 := 4
        let _v1687
        let _v1688
        let _v1689
        let _v1690
        _v1689, _v1690 := usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ(4)
        _v1687 := _v1689
        _v1688 := _v1690
        usr$invokable_invoke$t_removeOperator550233(_v1687, _v1688)
        let _v1691
        let _v1692
        _v1692 := usr$abi_encode$unit()
        _v1691 := _v1692
        let start
        let _v1693
        _v1693 := usr$Typedef_rep$memoryLtJ$bytes(_v1691)
        start := _v1693
        let end
        let _v1694
        _v1694 := usr$get_free_memory()
        end := _v1694
        let retSz
        let _v1695
        _v1695 := usr$Sub_sub$word(end, start)
        retSz := _v1695
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056 () {
        let _v1696
        _v1696 := usr$calldatasize()
        let _v1697
        _v1697 := usr$ge$word(_v1696, 68)
        usr$require(_v1697, false, 140739926, 911)
        let _v1698
        _v1698 := 4
        let _v1699
        let _v1700
        let _v1701
        let _v1702
        _v1701, _v1702 := usr$abi_decode$calldataLbytesJ_pairLuint256_memoryLstringJJ_CalldataWordReader_pairLuint256_memoryLstringJJ(4)
        _v1699 := _v1701
        _v1700 := _v1702
        usr$invokable_invoke$t_setMetadataURI523056(_v1699, _v1700)
        let _v1703
        let _v1704
        _v1704 := usr$abi_encode$unit()
        _v1703 := _v1704
        let start
        let _v1705
        _v1705 := usr$Typedef_rep$memoryLtJ$bytes(_v1703)
        start := _v1705
        let end
        let _v1706
        _v1706 := usr$get_free_memory()
        end := _v1706
        let retSz
        let _v1707
        _v1707 := usr$Sub_sub$word(end, start)
        retSz := _v1707
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126 () {
        let _v1708
        _v1708 := usr$calldatasize()
        let _v1709
        _v1709 := usr$ge$word(_v1708, 164)
        usr$require(_v1709, false, 140739926, 911)
        let _v1710
        _v1710 := 4
        let _v1711
        let _v1712
        let _v1713
        let _v1714
        let _v1715
        let _v1716
        let _v1717
        let _v1718
        let _v1719
        let _v1720
        _v1716, _v1717, _v1718, _v1719, _v1720 := usr$abi_decode$calldataLbytesJ_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_CalldataWordReader_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ(4)
        _v1711 := _v1716
        _v1712 := _v1717
        _v1713 := _v1718
        _v1714 := _v1719
        _v1715 := _v1720
        usr$invokable_invoke$t_checkInWithProof672126(_v1711, _v1712, _v1713, _v1714, _v1715)
        let _v1721
        let _v1722
        _v1722 := usr$abi_encode$unit()
        _v1721 := _v1722
        let start
        let _v1723
        _v1723 := usr$Typedef_rep$memoryLtJ$bytes(_v1721)
        start := _v1723
        let end
        let _v1724
        _v1724 := usr$get_free_memory()
        end := _v1724
        let retSz
        let _v1725
        _v1725 := usr$Sub_sub$word(end, start)
        retSz := _v1725
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502 () {
        let _v1726
        _v1726 := usr$calldatasize()
        let _v1727
        _v1727 := usr$ge$word(_v1726, 164)
        usr$require(_v1727, false, 140739926, 911)
        let _v1728
        _v1728 := 4
        let _v1729
        let _v1730
        let _v1731
        let _v1732
        let _v1733
        let _v1734
        let _v1735
        let _v1736
        let _v1737
        let _v1738
        _v1734, _v1735, _v1736, _v1737, _v1738 := usr$abi_decode$calldataLbytesJ_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_CalldataWordReader_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ(4)
        _v1729 := _v1734
        _v1730 := _v1735
        _v1731 := _v1736
        _v1732 := _v1737
        _v1733 := _v1738
        usr$invokable_invoke$t_checkInBatchWithProofs678502(_v1729, _v1730, _v1731, _v1732, _v1733)
        let _v1739
        let _v1740
        _v1740 := usr$abi_encode$unit()
        _v1739 := _v1740
        let start
        let _v1741
        _v1741 := usr$Typedef_rep$memoryLtJ$bytes(_v1739)
        start := _v1741
        let end
        let _v1742
        _v1742 := usr$get_free_memory()
        end := _v1742
        let retSz
        let _v1743
        _v1743 := usr$Sub_sub$word(end, start)
        retSz := _v1743
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842 () {
        let _v1744
        _v1744 := usr$calldatasize()
        let _v1745
        _v1745 := usr$ge$word(_v1744, 228)
        usr$require(_v1745, false, 140739926, 911)
        let _v1746
        _v1746 := 4
        let _v1747
        let _v1748
        let _v1749
        let _v1750
        let _v1751
        let _v1752
        let _v1753
        let _v1754
        let _v1755
        let _v1756
        let _v1757
        let _v1758
        let _v1759
        let _v1760
        _v1754, _v1755, _v1756, _v1757, _v1758, _v1759, _v1760 := usr$abi_decode$calldataLbytesJ_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_CalldataWordReader_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ(4)
        _v1747 := _v1754
        _v1748 := _v1755
        _v1749 := _v1756
        _v1750 := _v1757
        _v1751 := _v1758
        _v1752 := _v1759
        _v1753 := _v1760
        let _v1761
        let _v1762
        _v1762 := usr$invokable_invoke$t_createEvent613842(_v1747, _v1748, _v1749, _v1750, _v1751, _v1752, _v1753)
        _v1761 := _v1762
        let _v1763
        let _v1764
        _v1764 := usr$abi_encode$uint256(_v1761)
        _v1763 := _v1764
        let start
        let _v1765
        _v1765 := usr$Typedef_rep$memoryLtJ$bytes(_v1763)
        start := _v1765
        let end
        let _v1766
        _v1766 := usr$get_free_memory()
        end := _v1766
        let retSz
        let _v1767
        _v1767 := usr$Sub_sub$word(end, start)
        retSz := _v1767
        return(start, retSz)
      }
      function usr$do_exec$uint256_address_t_organizer568622 () {
        let _v1768
        _v1768 := usr$calldatasize()
        let _v1769
        _v1769 := usr$ge$word(_v1768, 36)
        usr$require(_v1769, false, 140739926, 911)
        let _v1770
        _v1770 := 4
        let _v1771
        let _v1772
        _v1772 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1771 := _v1772
        let _v1773
        let _v1774
        _v1774 := usr$invokable_invoke$t_organizer568622(_v1771)
        _v1773 := _v1774
        let _v1775
        let _v1776
        _v1776 := usr$abi_encode$address(_v1773)
        _v1775 := _v1776
        let start
        let _v1777
        _v1777 := usr$Typedef_rep$memoryLtJ$bytes(_v1775)
        start := _v1777
        let end
        let _v1778
        _v1778 := usr$get_free_memory()
        end := _v1778
        let retSz
        let _v1779
        _v1779 := usr$Sub_sub$word(end, start)
        retSz := _v1779
        return(start, retSz)
      }
      function usr$do_exec$uint256_memoryLstringJ_t_metadataURI574576 () {
        let _v1780
        _v1780 := usr$calldatasize()
        let _v1781
        _v1781 := usr$ge$word(_v1780, 36)
        usr$require(_v1781, false, 140739926, 911)
        let _v1782
        _v1782 := 4
        let _v1783
        let _v1784
        _v1784 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1783 := _v1784
        let _v1785
        let _v1786
        _v1786 := usr$invokable_invoke$t_metadataURI574576(_v1783)
        _v1785 := _v1786
        let _v1787
        let _v1788
        _v1788 := usr$abi_encode$memoryLstringJ(_v1785)
        _v1787 := _v1788
        let start
        let _v1789
        _v1789 := usr$Typedef_rep$memoryLtJ$bytes(_v1787)
        start := _v1789
        let end
        let _v1790
        _v1790 := usr$get_free_memory()
        end := _v1790
        let retSz
        let _v1791
        _v1791 := usr$Sub_sub$word(end, start)
        retSz := _v1791
        return(start, retSz)
      }
      function usr$do_exec$uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264 () {
        let _v1792
        _v1792 := usr$calldatasize()
        let _v1793
        _v1793 := usr$ge$word(_v1792, 36)
        usr$require(_v1793, false, 140739926, 911)
        let _v1794
        _v1794 := 4
        let _v1795
        let _v1796
        _v1796 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1795 := _v1796
        let _v1797
        let _v1798
        let _v1799
        let _v1800
        let _v1801
        let _v1802
        let _v1803
        let _v1804
        let _v1805
        let _v1806
        let _v1807
        let _v1808
        let _v1809
        let _v1810
        _v1804, _v1805, _v1806, _v1807, _v1808, _v1809, _v1810 := usr$invokable_invoke$t_getEvent602264(_v1795)
        _v1797 := _v1804
        _v1798 := _v1805
        _v1799 := _v1806
        _v1800 := _v1807
        _v1801 := _v1808
        _v1802 := _v1809
        _v1803 := _v1810
        let _v1811
        let _v1812
        _v1812 := usr$abi_encode$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(_v1797, _v1798, _v1799, _v1800, _v1801, _v1802, _v1803)
        _v1811 := _v1812
        let start
        let _v1813
        _v1813 := usr$Typedef_rep$memoryLtJ$bytes(_v1811)
        start := _v1813
        let end
        let _v1814
        _v1814 := usr$get_free_memory()
        end := _v1814
        let retSz
        let _v1815
        _v1815 := usr$Sub_sub$word(end, start)
        retSz := _v1815
        return(start, retSz)
      }
      function usr$do_exec$uint256_sumLunit_unitJ_t_cancelled690311 () {
        let _v1816
        _v1816 := usr$calldatasize()
        let _v1817
        _v1817 := usr$ge$word(_v1816, 36)
        usr$require(_v1817, false, 140739926, 911)
        let _v1818
        _v1818 := 4
        let _v1819
        let _v1820
        _v1820 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1819 := _v1820
        let _v1821
        let _v1822
        _v1822 := usr$invokable_invoke$t_cancelled690311(_v1819)
        _v1821 := _v1822
        let _v1823
        let _v1824
        _v1824 := usr$abi_encode$sumLunit_unitJ(_v1821)
        _v1823 := _v1824
        let start
        let _v1825
        _v1825 := usr$Typedef_rep$memoryLtJ$bytes(_v1823)
        start := _v1825
        let end
        let _v1826
        _v1826 := usr$get_free_memory()
        end := _v1826
        let retSz
        let _v1827
        _v1827 := usr$Sub_sub$word(end, start)
        retSz := _v1827
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_checkedInCount648156 () {
        let _v1828
        _v1828 := usr$calldatasize()
        let _v1829
        _v1829 := usr$ge$word(_v1828, 36)
        usr$require(_v1829, false, 140739926, 911)
        let _v1830
        _v1830 := 4
        let _v1831
        let _v1832
        _v1832 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1831 := _v1832
        let _v1833
        let _v1834
        _v1834 := usr$invokable_invoke$t_checkedInCount648156(_v1831)
        _v1833 := _v1834
        let _v1835
        let _v1836
        _v1836 := usr$abi_encode$uint256(_v1833)
        _v1835 := _v1836
        let start
        let _v1837
        _v1837 := usr$Typedef_rep$memoryLtJ$bytes(_v1835)
        start := _v1837
        let end
        let _v1838
        _v1838 := usr$get_free_memory()
        end := _v1838
        let retSz
        let _v1839
        _v1839 := usr$Sub_sub$word(end, start)
        retSz := _v1839
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_claimedCount619465 () {
        let _v1840
        _v1840 := usr$calldatasize()
        let _v1841
        _v1841 := usr$ge$word(_v1840, 36)
        usr$require(_v1841, false, 140739926, 911)
        let _v1842
        _v1842 := 4
        let _v1843
        let _v1844
        _v1844 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1843 := _v1844
        let _v1845
        let _v1846
        _v1846 := usr$invokable_invoke$t_claimedCount619465(_v1843)
        _v1845 := _v1846
        let _v1847
        let _v1848
        _v1848 := usr$abi_encode$uint256(_v1845)
        _v1847 := _v1848
        let start
        let _v1849
        _v1849 := usr$Typedef_rep$memoryLtJ$bytes(_v1847)
        start := _v1849
        let end
        let _v1850
        _v1850 := usr$get_free_memory()
        end := _v1850
        let retSz
        let _v1851
        _v1851 := usr$Sub_sub$word(end, start)
        retSz := _v1851
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_getState596691 () {
        let _v1852
        _v1852 := usr$calldatasize()
        let _v1853
        _v1853 := usr$ge$word(_v1852, 36)
        usr$require(_v1853, false, 140739926, 911)
        let _v1854
        _v1854 := 4
        let _v1855
        let _v1856
        _v1856 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1855 := _v1856
        let _v1857
        let _v1858
        _v1858 := usr$invokable_invoke$t_getState596691(_v1855)
        _v1857 := _v1858
        let _v1859
        let _v1860
        _v1860 := usr$abi_encode$uint256(_v1857)
        _v1859 := _v1860
        let start
        let _v1861
        _v1861 := usr$Typedef_rep$memoryLtJ$bytes(_v1859)
        start := _v1861
        let end
        let _v1862
        _v1862 := usr$get_free_memory()
        end := _v1862
        let retSz
        let _v1863
        _v1863 := usr$Sub_sub$word(end, start)
        retSz := _v1863
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_held590925 () {
        let _v1864
        _v1864 := usr$calldatasize()
        let _v1865
        _v1865 := usr$ge$word(_v1864, 36)
        usr$require(_v1865, false, 140739926, 911)
        let _v1866
        _v1866 := 4
        let _v1867
        let _v1868
        _v1868 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1867 := _v1868
        let _v1869
        let _v1870
        _v1870 := usr$invokable_invoke$t_held590925(_v1867)
        _v1869 := _v1870
        let _v1871
        let _v1872
        _v1872 := usr$abi_encode$uint256(_v1869)
        _v1871 := _v1872
        let start
        let _v1873
        _v1873 := usr$Typedef_rep$memoryLtJ$bytes(_v1871)
        start := _v1873
        let end
        let _v1874
        _v1874 := usr$get_free_memory()
        end := _v1874
        let retSz
        let _v1875
        _v1875 := usr$Sub_sub$word(end, start)
        retSz := _v1875
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_registeredCount555638 () {
        let _v1876
        _v1876 := usr$calldatasize()
        let _v1877
        _v1877 := usr$ge$word(_v1876, 36)
        usr$require(_v1877, false, 140739926, 911)
        let _v1878
        _v1878 := 4
        let _v1879
        let _v1880
        _v1880 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1879 := _v1880
        let _v1881
        let _v1882
        _v1882 := usr$invokable_invoke$t_registeredCount555638(_v1879)
        _v1881 := _v1882
        let _v1883
        let _v1884
        _v1884 := usr$abi_encode$uint256(_v1881)
        _v1883 := _v1884
        let start
        let _v1885
        _v1885 := usr$Typedef_rep$memoryLtJ$bytes(_v1883)
        start := _v1885
        let end
        let _v1886
        _v1886 := usr$get_free_memory()
        end := _v1886
        let retSz
        let _v1887
        _v1887 := usr$Sub_sub$word(end, start)
        retSz := _v1887
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_rewardPerAttendee539456 () {
        let _v1888
        _v1888 := usr$calldatasize()
        let _v1889
        _v1889 := usr$ge$word(_v1888, 36)
        usr$require(_v1889, false, 140739926, 911)
        let _v1890
        _v1890 := 4
        let _v1891
        let _v1892
        _v1892 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1891 := _v1892
        let _v1893
        let _v1894
        _v1894 := usr$invokable_invoke$t_rewardPerAttendee539456(_v1891)
        _v1893 := _v1894
        let _v1895
        let _v1896
        _v1896 := usr$abi_encode$uint256(_v1893)
        _v1895 := _v1896
        let start
        let _v1897
        _v1897 := usr$Typedef_rep$memoryLtJ$bytes(_v1895)
        start := _v1897
        let end
        let _v1898
        _v1898 := usr$get_free_memory()
        end := _v1898
        let retSz
        let _v1899
        _v1899 := usr$Sub_sub$word(end, start)
        retSz := _v1899
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_cancel704363 () {
        let _v1900
        _v1900 := usr$calldatasize()
        let _v1901
        _v1901 := usr$ge$word(_v1900, 36)
        usr$require(_v1901, false, 140739926, 911)
        let _v1902
        _v1902 := 4
        let _v1903
        let _v1904
        _v1904 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1903 := _v1904
        usr$invokable_invoke$t_cancel704363(_v1903)
        let _v1905
        let _v1906
        _v1906 := usr$abi_encode$unit()
        _v1905 := _v1906
        let start
        let _v1907
        _v1907 := usr$Typedef_rep$memoryLtJ$bytes(_v1905)
        start := _v1907
        let end
        let _v1908
        _v1908 := usr$get_free_memory()
        end := _v1908
        let retSz
        let _v1909
        _v1909 := usr$Sub_sub$word(end, start)
        retSz := _v1909
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_cancelEvent696677 () {
        let _v1910
        _v1910 := usr$calldatasize()
        let _v1911
        _v1911 := usr$ge$word(_v1910, 36)
        usr$require(_v1911, false, 140739926, 911)
        let _v1912
        _v1912 := 4
        let _v1913
        let _v1914
        _v1914 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1913 := _v1914
        usr$invokable_invoke$t_cancelEvent696677(_v1913)
        let _v1915
        let _v1916
        _v1916 := usr$abi_encode$unit()
        _v1915 := _v1916
        let start
        let _v1917
        _v1917 := usr$Typedef_rep$memoryLtJ$bytes(_v1915)
        start := _v1917
        let end
        let _v1918
        _v1918 := usr$get_free_memory()
        end := _v1918
        let retSz
        let _v1919
        _v1919 := usr$Sub_sub$word(end, start)
        retSz := _v1919
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_claim642485 () {
        let _v1920
        _v1920 := usr$calldatasize()
        let _v1921
        _v1921 := usr$ge$word(_v1920, 36)
        usr$require(_v1921, false, 140739926, 911)
        let _v1922
        _v1922 := 4
        let _v1923
        let _v1924
        _v1924 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1923 := _v1924
        usr$invokable_invoke$t_claim642485(_v1923)
        let _v1925
        let _v1926
        _v1926 := usr$abi_encode$unit()
        _v1925 := _v1926
        let start
        let _v1927
        _v1927 := usr$Typedef_rep$memoryLtJ$bytes(_v1925)
        start := _v1927
        let end
        let _v1928
        _v1928 := usr$get_free_memory()
        end := _v1928
        let retSz
        let _v1929
        _v1929 := usr$Sub_sub$word(end, start)
        retSz := _v1929
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_claimDust634664 () {
        let _v1930
        _v1930 := usr$calldatasize()
        let _v1931
        _v1931 := usr$ge$word(_v1930, 36)
        usr$require(_v1931, false, 140739926, 911)
        let _v1932
        _v1932 := 4
        let _v1933
        let _v1934
        _v1934 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1933 := _v1934
        usr$invokable_invoke$t_claimDust634664(_v1933)
        let _v1935
        let _v1936
        _v1936 := usr$abi_encode$unit()
        _v1935 := _v1936
        let start
        let _v1937
        _v1937 := usr$Typedef_rep$memoryLtJ$bytes(_v1935)
        start := _v1937
        let end
        let _v1938
        _v1938 := usr$get_free_memory()
        end := _v1938
        let retSz
        let _v1939
        _v1939 := usr$Sub_sub$word(end, start)
        retSz := _v1939
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_claimRefund627219 () {
        let _v1940
        _v1940 := usr$calldatasize()
        let _v1941
        _v1941 := usr$ge$word(_v1940, 36)
        usr$require(_v1941, false, 140739926, 911)
        let _v1942
        _v1942 := 4
        let _v1943
        let _v1944
        _v1944 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1943 := _v1944
        usr$invokable_invoke$t_claimRefund627219(_v1943)
        let _v1945
        let _v1946
        _v1946 := usr$abi_encode$unit()
        _v1945 := _v1946
        let start
        let _v1947
        _v1947 := usr$Typedef_rep$memoryLtJ$bytes(_v1945)
        start := _v1947
        let end
        let _v1948
        _v1948 := usr$get_free_memory()
        end := _v1948
        let retSz
        let _v1949
        _v1949 := usr$Sub_sub$word(end, start)
        retSz := _v1949
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_register563235 () {
        let _v1950
        _v1950 := usr$calldatasize()
        let _v1951
        _v1951 := usr$ge$word(_v1950, 36)
        usr$require(_v1951, false, 140739926, 911)
        let _v1952
        _v1952 := 4
        let _v1953
        let _v1954
        _v1954 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1953 := _v1954
        usr$invokable_invoke$t_register563235(_v1953)
        let _v1955
        let _v1956
        _v1956 := usr$abi_encode$unit()
        _v1955 := _v1956
        let start
        let _v1957
        _v1957 := usr$Typedef_rep$memoryLtJ$bytes(_v1955)
        start := _v1957
        let end
        let _v1958
        _v1958 := usr$get_free_memory()
        end := _v1958
        let retSz
        let _v1959
        _v1959 := usr$Sub_sub$word(end, start)
        retSz := _v1959
        return(start, retSz)
      }
      function usr$do_exec$unit_address_t_maintainer579876 () {
        let _v1960
        _v1960 := usr$calldatasize()
        let _v1961
        _v1961 := usr$ge$word(_v1960, 4)
        usr$require(_v1961, false, 140739926, 911)
        let _v1962
        _v1962 := 4
        let _v1963
        let _v1964
        _v1964 := usr$invokable_invoke$t_maintainer579876()
        _v1963 := _v1964
        let _v1965
        let _v1966
        _v1966 := usr$abi_encode$address(_v1963)
        _v1965 := _v1966
        let start
        let _v1967
        _v1967 := usr$Typedef_rep$memoryLtJ$bytes(_v1965)
        start := _v1967
        let end
        let _v1968
        _v1968 := usr$get_free_memory()
        end := _v1968
        let retSz
        let _v1969
        _v1969 := usr$Sub_sub$word(end, start)
        retSz := _v1969
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_DUST_CLAIM_TIMEOUT732580 () {
        let _v1970
        _v1970 := usr$calldatasize()
        let _v1971
        _v1971 := usr$ge$word(_v1970, 4)
        usr$require(_v1971, false, 140739926, 911)
        let _v1972
        _v1972 := 4
        let _v1973
        let _v1974
        _v1974 := usr$invokable_invoke$t_DUST_CLAIM_TIMEOUT732580()
        _v1973 := _v1974
        let _v1975
        let _v1976
        _v1976 := usr$abi_encode$uint256(_v1973)
        _v1975 := _v1976
        let start
        let _v1977
        _v1977 := usr$Typedef_rep$memoryLtJ$bytes(_v1975)
        start := _v1977
        let end
        let _v1978
        _v1978 := usr$get_free_memory()
        end := _v1978
        let retSz
        let _v1979
        _v1979 := usr$Sub_sub$word(end, start)
        retSz := _v1979
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_MAX_BATCH_SIZE726970 () {
        let _v1980
        _v1980 := usr$calldatasize()
        let _v1981
        _v1981 := usr$ge$word(_v1980, 4)
        usr$require(_v1981, false, 140739926, 911)
        let _v1982
        _v1982 := 4
        let _v1983
        let _v1984
        _v1984 := usr$invokable_invoke$t_MAX_BATCH_SIZE726970()
        _v1983 := _v1984
        let _v1985
        let _v1986
        _v1986 := usr$abi_encode$uint256(_v1983)
        _v1985 := _v1986
        let start
        let _v1987
        _v1987 := usr$Typedef_rep$memoryLtJ$bytes(_v1985)
        start := _v1987
        let end
        let _v1988
        _v1988 := usr$get_free_memory()
        end := _v1988
        let retSz
        let _v1989
        _v1989 := usr$Sub_sub$word(end, start)
        retSz := _v1989
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_MIN_CANCELLATION_BUFFER721378 () {
        let _v1990
        _v1990 := usr$calldatasize()
        let _v1991
        _v1991 := usr$ge$word(_v1990, 4)
        usr$require(_v1991, false, 140739926, 911)
        let _v1992
        _v1992 := 4
        let _v1993
        let _v1994
        _v1994 := usr$invokable_invoke$t_MIN_CANCELLATION_BUFFER721378()
        _v1993 := _v1994
        let _v1995
        let _v1996
        _v1996 := usr$abi_encode$uint256(_v1993)
        _v1995 := _v1996
        let start
        let _v1997
        _v1997 := usr$Typedef_rep$memoryLtJ$bytes(_v1995)
        start := _v1997
        let end
        let _v1998
        _v1998 := usr$get_free_memory()
        end := _v1998
        let retSz
        let _v1999
        _v1999 := usr$Sub_sub$word(end, start)
        retSz := _v1999
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_eventCount607668 () {
        let _v2000
        _v2000 := usr$calldatasize()
        let _v2001
        _v2001 := usr$ge$word(_v2000, 4)
        usr$require(_v2001, false, 140739926, 911)
        let _v2002
        _v2002 := 4
        let _v2003
        let _v2004
        _v2004 := usr$invokable_invoke$t_eventCount607668()
        _v2003 := _v2004
        let _v2005
        let _v2006
        _v2006 := usr$abi_encode$uint256(_v2003)
        _v2005 := _v2006
        let start
        let _v2007
        _v2007 := usr$Typedef_rep$memoryLtJ$bytes(_v2005)
        start := _v2007
        let end
        let _v2008
        _v2008 := usr$get_free_memory()
        end := _v2008
        let retSz
        let _v2009
        _v2009 := usr$Sub_sub$word(end, start)
        retSz := _v2009
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_totalHeld517523 () {
        let _v2010
        _v2010 := usr$calldatasize()
        let _v2011
        _v2011 := usr$ge$word(_v2010, 4)
        usr$require(_v2011, false, 140739926, 911)
        let _v2012
        _v2012 := 4
        let _v2013
        let _v2014
        _v2014 := usr$invokable_invoke$t_totalHeld517523()
        _v2013 := _v2014
        let _v2015
        let _v2016
        _v2016 := usr$abi_encode$uint256(_v2013)
        _v2015 := _v2016
        let start
        let _v2017
        _v2017 := usr$Typedef_rep$memoryLtJ$bytes(_v2015)
        start := _v2017
        let end
        let _v2018
        _v2018 := usr$get_free_memory()
        end := _v2018
        let retSz
        let _v2019
        _v2019 := usr$Sub_sub$word(end, start)
        retSz := _v2019
        return(start, retSz)
      }
      function usr$domainSep () -> _result {
        let _v2020
        _v2020 := usr$chainId()
        let _v2021
        _v2021 := usr$self()
        let _v2022
        _v2022 := usr$eip712DomainSeparator(97232355314278631395661758069138436799831398720713067454604269663819990530290, 90743482286830539503240959006302832933333810038750515972785732718729991261126, _v2020, _v2021)
        _result := _v2022
        leave
      }
      function usr$ecrecover (hash, v, r, s) -> _result {
        let _v2023
        _v2023 := usr$Typedef_rep$bytes32(s)
        let _v2024
        _v2024 := usr$le$word(_v2023, 57896044618658097711785492504343953926418782139537452191302581570759080747168)
        usr$require(_v2024, false, 623250208, 911)
        let hash_
        let _v2025
        _v2025 := usr$Typedef_rep$bytes32(hash)
        hash_ := _v2025
        let v_
        let _v2026
        _v2026 := usr$Typedef_rep$uint256(v)
        v_ := _v2026
        let r_
        let _v2027
        _v2027 := usr$Typedef_rep$bytes32(r)
        r_ := _v2027
        let s_
        let _v2028
        _v2028 := usr$Typedef_rep$bytes32(s)
        s_ := _v2028
        let ptr
        let _v2029
        _v2029 := usr$get_free_memory()
        ptr := _v2029
        usr$mstore(ptr, hash_)
        let _v2030
        _v2030 := usr$Add_add$word(ptr, 32)
        usr$mstore(_v2030, v_)
        let _v2031
        _v2031 := usr$Add_add$word(ptr, 64)
        usr$mstore(_v2031, r_)
        let _v2032
        _v2032 := usr$Add_add$word(ptr, 96)
        usr$mstore(_v2032, s_)
        let ret
        let _v2033
        _v2033 := usr$gas()
        let _v2034
        _v2034 := usr$staticcall(_v2033, 1, ptr, 128, 0, 32)
        ret := _v2034
        let _v2035
        _v2035 := usr$ne$word(ret, 0)
        usr$require(_v2035, false, 1468490743, 911)
        let res
        let _v2036
        _v2036 := usr$mload(0)
        res := _v2036
        let _v2037
        _v2037 := usr$ne$word(res, 0)
        usr$require(_v2037, false, 1337962083, 911)
        _result := res
        leave
      }
      function usr$eip712Digest (domainSeparator, structHash) -> _result {
        let ptr
        let _v2038
        _v2038 := usr$get_free_memory()
        ptr := _v2038
        usr$mstore(ptr, 11309588061646438093662687302255421419811724423900836950936401294474059186176)
        let _v2039
        _v2039 := usr$Add_add$word(ptr, 2)
        let _v2040
        _v2040 := usr$Typedef_rep$bytes32(domainSeparator)
        usr$mstore(_v2039, _v2040)
        let _v2041
        _v2041 := usr$Add_add$word(ptr, 34)
        let _v2042
        _v2042 := usr$Typedef_rep$bytes32(structHash)
        usr$mstore(_v2041, _v2042)
        let _v2043
        _v2043 := usr$keccak256(ptr, 66)
        _result := _v2043
        leave
      }
      function usr$eip712DomainSeparator (nameHash, versionHash, chainId, verifyingContract) -> _result {
        let typeHash
        typeHash := 63076024560530113402979550242307453568063438748328787417531900361828837441551
        let ptr
        let _v2044
        _v2044 := usr$get_free_memory()
        ptr := _v2044
        usr$mstore(ptr, 63076024560530113402979550242307453568063438748328787417531900361828837441551)
        let _v2045
        _v2045 := usr$Add_add$word(ptr, 32)
        let _v2046
        _v2046 := usr$Typedef_rep$bytes32(nameHash)
        usr$mstore(_v2045, _v2046)
        let _v2047
        _v2047 := usr$Add_add$word(ptr, 64)
        let _v2048
        _v2048 := usr$Typedef_rep$bytes32(versionHash)
        usr$mstore(_v2047, _v2048)
        let _v2049
        _v2049 := usr$Add_add$word(ptr, 96)
        let _v2050
        _v2050 := usr$Typedef_rep$uint256(chainId)
        usr$mstore(_v2049, _v2050)
        let _v2051
        _v2051 := usr$Add_add$word(ptr, 128)
        let _v2052
        _v2052 := usr$Typedef_rep$address(verifyingContract)
        usr$mstore(_v2051, _v2052)
        let _v2053
        _v2053 := usr$keccak256(ptr, 160)
        _result := _v2053
        leave
      }
      function usr$emitLog2 (t0, t1) {
        usr$log2_(0, 0, t0, t1)
        leave
      }
      function usr$emitLog2Str (t0, t1, s) {
        let _v2054
        let _v2055
        _v2055 := usr$abi_encode$memoryLstringJ(s)
        _v2054 := _v2055
        let start
        let _v2056
        _v2056 := usr$Typedef_rep$memoryLtJ$bytes(_v2054)
        start := _v2056
        let _v2057
        _v2057 := usr$get_free_memory()
        let _v2058
        _v2058 := usr$Sub_sub$word(_v2057, start)
        usr$log2_(start, _v2058, t0, t1)
      }
      function usr$emitLog3 (t0, t1, t2) {
        usr$log3_(0, 0, t0, t1, t2)
        leave
      }
      function usr$emitLog3W1 (t0, t1, t2, d0) {
        let p
        let _v2059
        _v2059 := usr$get_free_memory()
        p := _v2059
        usr$mstore(p, d0)
        usr$log3_(p, 32, t0, t1, t2)
      }
      function usr$emitLog3W3 (t0, t1, t2, d0, d1, d2) {
        let p
        let _v2060
        _v2060 := usr$get_free_memory()
        p := _v2060
        usr$mstore(p, d0)
        let _v2061
        _v2061 := usr$Add_add$word(p, 32)
        usr$mstore(_v2061, d1)
        let _v2062
        _v2062 := usr$Add_add$word(p, 64)
        usr$mstore(_v2062, d2)
        usr$log3_(p, 96, t0, t1, t2)
      }
      function usr$encodeIntoFromBytesLike (srcPtr, basePtr, offset, tail) -> _result {
        let length
        let _v2063
        _v2063 := usr$mload(srcPtr)
        length := _v2063
        let total
        let _v2064
        _v2064 := usr$Add_add$word(length, 32)
        total := _v2064
        let _v2065
        _v2065 := usr$Add_add$word(basePtr, offset)
        let _v2066
        _v2066 := usr$Sub_sub$word(tail, basePtr)
        usr$mstore(_v2065, _v2066)
        usr$mcopy(tail, srcPtr, total)
        let rounded
        let _v2067
        _v2067 := usr$round_up_to_mul_of_32(total)
        rounded := _v2067
        let _v2068
        _v2068 := usr$Add_add$word(tail, total)
        let _v2069
        _v2069 := usr$Sub_sub$word(rounded, total)
        usr$zeroize_memory(_v2068, _v2069)
        let _v2070
        _v2070 := usr$Add_add$word(tail, rounded)
        _result := _v2070
        leave
      }
      function usr$eq (a, b) -> _result {
        let res
        res := eq(a, b)
        _result := res
        leave
      }
      function usr$eqWord (x, y) -> _v2071 {
        let _v2072
        _v2072 := usr$eq(x, y)
        let _v2073
        _v2073 := usr$tobool(_v2072)
        _v2071 := _v2073
        leave
      }
      function usr$eventCount () -> _result {
        let _v2074
        _v2074 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_eventCount_sel_uint256_pairLaddress_unitJ()
        _result := _v2074
        leave
      }
      function usr$fail (e) { usr$require(false, false, e, 911) }
      function usr$fallback () {
        let sz
        let _v2075
        _v2075 := usr$calldatasize()
        sz := _v2075
        let _v2076
        _v2076 := usr$ne$word(sz, 0)
        usr$requireK(_v2076, 2428038168)
        let _v2077
        let _v2078
        _v2078 := usr$ge$word(sz, 4)
        _v2077 := _v2078
        switch _v2077
          case false {}
          case true {let _v2079
                     let _v2080
                     _v2080 := usr$calldataload(0)
                     let _v2081
                     _v2081 := usr$shr(224, _v2080)
                     let _v2082
                     _v2082 := usr$Eq_eq$word(_v2081, 3180056963)
                     _v2079 := _v2082
                     switch _v2079
                       case false {}
                       case true {let _v2083
                                  let _v2084
                                  _v2084 := usr$callvalue_()
                                  let _v2085
                                  _v2085 := usr$ne$word(_v2084, 0)
                                  _v2083 := _v2085
                                  switch _v2083
                                    case false {}
                                    case true {usr$revertEmpty()}
                                  usr$checkInBatchImpl()
                                  leave}}
        usr$revertEmpty()
      }
      function usr$frombool (_v2086) -> _result {
        switch _v2086
          case false {_result := 0
                      leave}
          case true {_result := 1
                     leave}
      }
      function usr$gas () -> _result {
        let res
        res := gas()
        _result := res
        leave
      }
      function usr$ge$uint256 (x, y) -> _v2087 {
        let _v2088
        _v2088 := usr$le$uint256(y, x)
        _v2087 := _v2088
        leave
      }
      function usr$ge$word (x, y) -> _v2089 {
        let _v2090
        _v2090 := usr$le$word(y, x)
        _v2089 := _v2090
        leave
      }
      function usr$getEvent (eid) -> _v2091, _v2092, _v2093, _v2094, _v2095, _v2096, _v2097 {
        let _v2098
        let _v2099
        let _v2100
        let _v2101
        let _v2102
        let _v2103
        let _v2104
        let _v2105
        let _v2106
        let _v2107
        let _v2108
        let _v2109
        let _v2110
        let _v2111
        let _v2112
        let _v2113
        _v2106, _v2107, _v2108, _v2109, _v2110, _v2111, _v2112, _v2113 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2098 := _v2106
        _v2099 := _v2107
        _v2100 := _v2108
        _v2101 := _v2109
        _v2102 := _v2110
        _v2103 := _v2111
        _v2104 := _v2112
        _v2105 := _v2113
        switch _v2098
          case false {usr$revertNotFound()
                      _v2091 := 0
                      _v2092 := 0
                      _v2093 := 0
                      _v2094 := 0
                      _v2095 := 0
                      _v2096 := 0
                      _v2097 := 0
                      leave}
          case true {_v2091 := _v2099
                     _v2092 := _v2100
                     _v2093 := _v2101
                     _v2094 := _v2102
                     _v2095 := _v2103
                     _v2096 := _v2104
                     _v2097 := _v2105
                     leave}
      }
      function usr$getReader$calldataLarrayLaddressJJ_CalldataWordReader (d) -> _result {
        _result := d
        leave
      }
      function usr$getReader$calldataLarrayLmemoryLbytesJJJ_CalldataWordReader (d) -> _result {
        _result := d
        leave
      }
      function usr$getReader$calldataLarrayLuint256JJ_CalldataWordReader (d) -> _result {
        _result := d
        leave
      }
      function usr$getReader$memoryLbytesJ_CalldataWordReader (d) -> _result {
        _result := d
        leave
      }
      function usr$getReader$memoryLstringJ_CalldataWordReader (d) -> _result {
        _result := d
        leave
      }
      function usr$getState (eid) -> _result {
        let _v2114
        let _v2115
        let _v2116
        let _v2117
        let _v2118
        let _v2119
        let _v2120
        let _v2121
        let _v2122
        let _v2123
        let _v2124
        let _v2125
        let _v2126
        let _v2127
        let _v2128
        let _v2129
        _v2122, _v2123, _v2124, _v2125, _v2126, _v2127, _v2128, _v2129 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2114 := _v2122
        _v2115 := _v2123
        _v2116 := _v2124
        _v2117 := _v2125
        _v2118 := _v2126
        _v2119 := _v2127
        _v2120 := _v2128
        _v2121 := _v2129
        switch _v2114
          case false {usr$revertNotFound()
                      _result := 0
                      leave}
          case true {let _v2130
                     _v2130 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v2131
                     let _v2132
                     let _v2133
                     let _v2134
                     _v2131, _v2132, _v2133, _v2134 := usr$deriveState(_v2130, _v2118, _v2119, _v2120)
                     let _v2135
                     _v2135 := usr$stateOrd(_v2131, _v2132, _v2133, _v2134)
                     _result := _v2135
                     leave}
      }
      function usr$get_free_memory () -> _result {
        let _v2136
        _v2136 := usr$mload(64)
        _result := _v2136
        leave
      }
      function usr$gtWord (x, y) -> _v2137 {
        let _v2138
        _v2138 := usr$gt_(x, y)
        let _v2139
        _v2139 := usr$tobool(_v2138)
        _v2137 := _v2139
        leave
      }
      function usr$gt_ (a, b) -> _result {
        let res
        res := gt(a, b)
        _result := res
        leave
      }
      function usr$hash1 (x) -> _result {
        usr$mstore(0, x)
        let _v2140
        _v2140 := usr$keccak256(0, 32)
        _result := _v2140
        leave
      }
      function usr$hash2 (x, y) -> _result {
        usr$mstore(0, x)
        usr$mstore(32, y)
        let _v2141
        _v2141 := usr$keccak256(0, 64)
        _result := _v2141
        leave
      }
      function usr$hashPresence (eid, attendee, validUntil) -> _result {
        let _v2142
        _v2142 := 15504267222355628426695671757032507512098194176155136956106790746681756541420
        let _v2143
        _v2143 := usr$Typedef_rep$uint256(eid)
        let _v2144
        _v2144 := usr$Typedef_rep$address(attendee)
        let _v2145
        _v2145 := usr$Typedef_rep$uint256(validUntil)
        let _v2146
        _v2146 := usr$concat$bytes32_bytes32(_v2144, _v2145)
        let _v2147
        _v2147 := usr$concat$bytes32_memoryLbytesJ(_v2143, _v2146)
        let _v2148
        _v2148 := usr$concat$bytes32_memoryLbytesJ(15504267222355628426695671757032507512098194176155136956106790746681756541420, _v2147)
        let _v2149
        _v2149 := usr$keccak256_$memoryLbytesJ(_v2148)
        _result := _v2149
        leave
      }
      function usr$hashTicket (eid) -> _result {
        let _v2150
        _v2150 := 66362120926818450920893636617336181500808330397969470074361054524447861531213
        let _v2151
        _v2151 := usr$Typedef_rep$uint256(eid)
        let _v2152
        _v2152 := usr$concat$bytes32_bytes32(66362120926818450920893636617336181500808330397969470074361054524447861531213, _v2151)
        let _v2153
        _v2153 := usr$keccak256_$memoryLbytesJ(_v2152)
        _result := _v2153
        leave
      }
      function usr$held (eid) -> _result {
        let _v2154
        let _v2155
        let _v2156
        let _v2157
        let _v2158
        let _v2159
        let _v2160
        let _v2161
        _v2158, _v2159, _v2160, _v2161 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v2154 := _v2158
        _v2155 := _v2159
        _v2156 := _v2160
        _v2157 := _v2161
        _result := _v2157
        leave
      }
      function usr$invokable_invoke$t_DUST_CLAIM_TIMEOUT732580 () -> _result {
        _result := 2592000
        leave
      }
      function usr$invokable_invoke$t_MAX_BATCH_SIZE726970 () -> _result {
        _result := 100
        leave
      }
      function usr$invokable_invoke$t_MIN_CANCELLATION_BUFFER721378 () -> _result {
        _result := 7200
        leave
      }
      function usr$invokable_invoke$t_addOperator715799 (_v2162, _v2163) {
        let _v2164
        let _v2165
        _v2164 := _v2162
        _v2165 := _v2163
        usr$addOperator(_v2164, _v2165)
        leave
      }
      function usr$invokable_invoke$t_attendees710234 (_v2166, _v2167) -> _result {
        let _v2168
        let _v2169
        _v2168 := _v2166
        _v2169 := _v2167
        let _v2170
        _v2170 := usr$attendees(_v2168, _v2169)
        _result := _v2170
        leave
      }
      function usr$invokable_invoke$t_cancel704363 (arg704365) {
        let _v2171
        _v2171 := arg704365
        usr$cancel(_v2171)
        leave
      }
      function usr$invokable_invoke$t_cancelEvent696677 (arg696679) {
        let _v2172
        _v2172 := arg696679
        usr$cancelEvent(_v2172)
        leave
      }
      function usr$invokable_invoke$t_cancelled690311 (arg690313) -> _v2173 {
        let _v2174
        _v2174 := arg690313
        let _v2175
        _v2175 := usr$cancelled(_v2174)
        _v2173 := _v2175
        leave
      }
      function usr$invokable_invoke$t_checkIn684539 (_v2176, _v2177) {
        let _v2178
        let _v2179
        _v2178 := _v2176
        _v2179 := _v2177
        usr$checkIn(_v2178, _v2179)
        leave
      }
      function usr$invokable_invoke$t_checkInBatchWithProofs678502 (_v2180, _v2181, _v2182, _v2183, _v2184) {
        let _v2185
        let _v2186
        let _v2187
        let _v2188
        let _v2189
        _v2185 := _v2180
        _v2186 := _v2181
        _v2187 := _v2182
        _v2188 := _v2183
        _v2189 := _v2184
        usr$checkInBatchWithProofs(_v2185, _v2186, _v2187, _v2188, _v2189)
        leave
      }
      function usr$invokable_invoke$t_checkInWithProof672126 (_v2190, _v2191, _v2192, _v2193, _v2194) {
        let _v2195
        let _v2196
        let _v2197
        let _v2198
        let _v2199
        _v2195 := _v2190
        _v2196 := _v2191
        _v2197 := _v2192
        _v2198 := _v2193
        _v2199 := _v2194
        usr$checkInWithProof(_v2195, _v2196, _v2197, _v2198, _v2199)
        leave
      }
      function usr$invokable_invoke$t_checkedInCount648156 (arg648158) -> _result {
        let _v2200
        _v2200 := arg648158
        let _v2201
        _v2201 := usr$checkedInCount(_v2200)
        _result := _v2201
        leave
      }
      function usr$invokable_invoke$t_claim642485 (arg642487) {
        let _v2202
        _v2202 := arg642487
        usr$claim(_v2202)
        leave
      }
      function usr$invokable_invoke$t_claimDust634664 (arg634666) {
        let _v2203
        _v2203 := arg634666
        usr$claimDust(_v2203)
        leave
      }
      function usr$invokable_invoke$t_claimRefund627219 (arg627221) {
        let _v2204
        _v2204 := arg627221
        usr$claimRefund(_v2204)
        leave
      }
      function usr$invokable_invoke$t_claimedCount619465 (arg619467) -> _result {
        let _v2205
        _v2205 := arg619467
        let _v2206
        _v2206 := usr$claimedCount(_v2205)
        _result := _v2206
        leave
      }
      function usr$invokable_invoke$t_createEvent613842 (_v2207, _v2208, _v2209, _v2210, _v2211, _v2212, _v2213) -> _result {
        let _v2214
        let _v2215
        let _v2216
        let _v2217
        let _v2218
        let _v2219
        let _v2220
        _v2214 := _v2207
        _v2215 := _v2208
        _v2216 := _v2209
        _v2217 := _v2210
        _v2218 := _v2211
        _v2219 := _v2212
        _v2220 := _v2213
        let _v2221
        _v2221 := usr$createEvent(_v2214, _v2215, _v2216, _v2217, _v2218, _v2219, _v2220)
        _result := _v2221
        leave
      }
      function usr$invokable_invoke$t_eventCount607668 () -> _result {
        let _v2222
        _v2222 := usr$eventCount()
        _result := _v2222
        leave
      }
      function usr$invokable_invoke$t_fallback744567 () {
        usr$fallback()
        leave
      }
      function usr$invokable_invoke$t_getEvent602264 (arg602266) -> _v2223, _v2224, _v2225, _v2226, _v2227, _v2228, _v2229 {
        let _v2230
        _v2230 := arg602266
        let _v2231
        let _v2232
        let _v2233
        let _v2234
        let _v2235
        let _v2236
        let _v2237
        _v2231, _v2232, _v2233, _v2234, _v2235, _v2236, _v2237 := usr$getEvent(_v2230)
        _v2223 := _v2231
        _v2224 := _v2232
        _v2225 := _v2233
        _v2226 := _v2234
        _v2227 := _v2235
        _v2228 := _v2236
        _v2229 := _v2237
        leave
      }
      function usr$invokable_invoke$t_getState596691 (arg596693) -> _result {
        let _v2238
        _v2238 := arg596693
        let _v2239
        _v2239 := usr$getState(_v2238)
        _result := _v2239
        leave
      }
      function usr$invokable_invoke$t_held590925 (arg590927) -> _result {
        let _v2240
        _v2240 := arg590927
        let _v2241
        _v2241 := usr$held(_v2240)
        _result := _v2241
        leave
      }
      function usr$invokable_invoke$t_isOperator585412 (_v2242, _v2243) -> _v2244 {
        let _v2245
        let _v2246
        _v2245 := _v2242
        _v2246 := _v2243
        let _v2247
        _v2247 := usr$isOperator(_v2245, _v2246)
        _v2244 := _v2247
        leave
      }
      function usr$invokable_invoke$t_maintainer579876 () -> _result {
        let _v2248
        _v2248 := usr$maintainer()
        _result := _v2248
        leave
      }
      function usr$invokable_invoke$t_metadataURI574576 (arg574578) -> _result {
        let _v2249
        _v2249 := arg574578
        let _v2250
        _v2250 := usr$metadataURI(_v2249)
        _result := _v2250
        leave
      }
      function usr$invokable_invoke$t_organizer568622 (arg568624) -> _result {
        let _v2251
        _v2251 := arg568624
        let _v2252
        _v2252 := usr$organizer(_v2251)
        _result := _v2252
        leave
      }
      function usr$invokable_invoke$t_register563235 (arg563237) {
        let _v2253
        _v2253 := arg563237
        usr$register(_v2253)
        leave
      }
      function usr$invokable_invoke$t_registeredCount555638 (arg555640) -> _result {
        let _v2254
        _v2254 := arg555640
        let _v2255
        _v2255 := usr$registeredCount(_v2254)
        _result := _v2255
        leave
      }
      function usr$invokable_invoke$t_removeOperator550233 (_v2256, _v2257) {
        let _v2258
        let _v2259
        _v2258 := _v2256
        _v2259 := _v2257
        usr$removeOperator(_v2258, _v2259)
        leave
      }
      function usr$invokable_invoke$t_rewardPerAttendee539456 (arg539458) -> _result {
        let _v2260
        _v2260 := arg539458
        let _v2261
        _v2261 := usr$rewardPerAttendee(_v2260)
        _result := _v2261
        leave
      }
      function usr$invokable_invoke$t_setMaintainer528800 (arg528802) {
        let _v2262
        _v2262 := arg528802
        usr$setMaintainer(_v2262)
        leave
      }
      function usr$invokable_invoke$t_setMetadataURI523056 (_v2263, _v2264) {
        let _v2265
        let _v2266
        _v2265 := _v2263
        _v2266 := _v2264
        usr$setMetadataURI(_v2265, _v2266)
        leave
      }
      function usr$invokable_invoke$t_totalHeld517523 () -> _result {
        let _v2267
        _v2267 := usr$totalHeld()
        _result := _v2267
        leave
      }
      function usr$isOperator (eid, a) -> _v2268 {
        let _v2269
        _v2269 := usr$lidx$storageLmappingLuint256_mappingLaddress_sumLunit_unitJJJJ_uint256_storageLmappingLaddress_sumLunit_unitJJJ(8, eid)
        let _v2270
        _v2270 := usr$ridx$storageLmappingLaddress_sumLunit_unitJJJ_address_sumLunit_unitJ(_v2269, a)
        _v2268 := _v2270
        leave
      }
      function usr$iszero (a) -> _result {
        let res
        res := iszero(a)
        _result := res
        leave
      }
      function usr$keccak256 (a, b) -> _result {
        let res
        res := keccak256(a, b)
        _result := res
        leave
      }
      function usr$keccak256_$memoryLbytesJ (input) -> _result {
        let len
        let _v2271
        _v2271 := usr$MemorySize_len$memoryLbytesJ(input)
        len := _v2271
        let ptr
        let _v2272
        _v2272 := usr$MemoryPointer_ptr$memoryLbytesJ(input)
        ptr := _v2272
        let _v2273
        _v2273 := usr$keccak256(ptr, len)
        _result := _v2273
        leave
      }
      function usr$le$uint256 (x, y) -> _v2274 {
        let _v2275
        _v2275 := usr$Ord_gt$uint256(x, y)
        let _v2276
        _v2276 := usr$not(_v2275)
        _v2274 := _v2276
        leave
      }
      function usr$le$word (x, y) -> _v2277 {
        let _v2278
        _v2278 := usr$Ord_gt$word(x, y)
        let _v2279
        _v2279 := usr$not(_v2278)
        _v2277 := _v2279
        leave
      }
      function usr$lidx$storageLarrayLstringJJ_uint256_storageLstringJ (c, i) -> _result {
        let _v2280
        _v2280 := usr$LValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256(c, i)
        _result := _v2280
        leave
      }
      function usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ (c, i) -> _result {
        let _v2281
        _v2281 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus(c, i)
        _result := _v2281
        leave
      }
      function usr$lidx$storageLmappingLaddress_sumLunit_unitJJJ_address_storageLsumLunit_unitJJ (c, i) -> _result {
        let _v2282
        _v2282 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_sumLunit_unitJ(c, i)
        _result := _v2282
        leave
      }
      function usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ (c, i) -> _result {
        let _v2283
        _v2283 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters(c, i)
        _result := _v2283
        leave
      }
      function usr$lidx$storageLmappingLuint256_EventRecJJ_uint256_storageLEventRecJ (c, i) -> _result {
        let _v2284
        _v2284 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec(c, i)
        _result := _v2284
        leave
      }
      function usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ (c, i) -> _result {
        let _v2285
        _v2285 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_mappingLaddress_AttendeeStatusJ(c, i)
        _result := _v2285
        leave
      }
      function usr$lidx$storageLmappingLuint256_mappingLaddress_sumLunit_unitJJJJ_uint256_storageLmappingLaddress_sumLunit_unitJJJ (c, i) -> _result {
        let _v2286
        _v2286 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_mappingLaddress_sumLunit_unitJJ(c, i)
        _result := _v2286
        leave
      }
      function usr$lidx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_storageLsumLunit_unitJJ (c, i) -> _result {
        let _v2287
        _v2287 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ(c, i)
        _result := _v2287
        leave
      }
      function usr$loadBytesFromStorage (slot, memPtr) -> _result {
        let pos
        pos := memPtr
        let slotValue
        let _v2288
        _v2288 := usr$sload(slot)
        slotValue := _v2288
        let length
        let _v2289
        _v2289 := usr$Div_div$word(slotValue, 2)
        length := _v2289
        let _v2290
        let _v2291
        _v2291 := usr$and_(slotValue, 1)
        let _v2292
        _v2292 := usr$tobool(_v2291)
        _v2290 := _v2292
        let _v2293
        let _v2294
        _v2294 := usr$not(_v2290)
        _v2293 := _v2294
        switch _v2293
          case false {}
          case true {let _v2295
                     _v2295 := usr$and_(length, 127)
                     length := _v2295}
        usr$mstore(pos, length)
        let _v2296
        _v2296 := usr$Add_add$word(pos, 32)
        pos := _v2296
        switch _v2290
          case false {let _v2297
                      _v2297 := usr$and_(slotValue, 115792089237316195423570985008687907853269984665640564039457584007913129639680)
                      usr$mstore(pos, _v2297)
                      let empty
                      let _v2298
                      _v2298 := usr$iszero(length)
                      empty := _v2298
                      let notzero
                      let _v2299
                      _v2299 := usr$iszero(empty)
                      notzero := _v2299
                      let _v2300
                      _v2300 := usr$Mul_mul$word(notzero, 32)
                      let _v2301
                      _v2301 := usr$Add_add$word(pos, _v2300)
                      _result := _v2301
                      leave}
          case true {let dataPos
                     let _v2302
                     _v2302 := usr$hash1(slot)
                     dataPos := _v2302
                     let i
                     i := 0
                     for {let _v2303 let _v2304 _v2303 := usr$lt$word(i, length)} _v2303 {_v2304 := usr$Add_add$word(i, 32) i := _v2304 _v2303 := usr$lt$word(i, length)}
                     {let _v2305
                      _v2305 := usr$Add_add$word(pos, i)
                      let _v2306
                      _v2306 := usr$sload(dataPos)
                      usr$mstore(_v2305, _v2306)
                      let _v2307
                      _v2307 := usr$Add_add$word(dataPos, 1)
                      dataPos := _v2307}
                     let _v2308
                     _v2308 := usr$Add_add$word(pos, i)
                     _result := _v2308
                     leave}
      }
      function usr$log2_ (a, b, c, d) { log2(a, b, c, d) }
      function usr$log3_ (a, b, c, d, e) { log3(a, b, c, d, e) }
      function usr$lt$uint256 (x, y) -> _v2309 {
        let _v2310
        _v2310 := usr$Ord_gt$uint256(y, x)
        _v2309 := _v2310
        leave
      }
      function usr$lt$word (x, y) -> _v2311 {
        let _v2312
        _v2312 := usr$Ord_gt$word(y, x)
        _v2311 := _v2312
        leave
      }
      function usr$main () -> _v2313 {
        usr$RunContract_exec$ContractLmethods_fbJ$pairLMethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J_pairLMethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J_pairLMethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J_pairLMethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J_pairLMethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J_pairLMethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ_FallbackLPayable_unit_unit_t_fallback744567J()
      }
      function usr$maintainer () -> _result {
        let _v2314
        _v2314 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        _result := _v2314
        leave
      }
      function usr$mcopy (a, b, c) { mcopy(a, b, c) }
      function usr$metadataURI (eid) -> _result {
        let _v2315
        let _v2316
        let _v2317
        let _v2318
        let _v2319
        let _v2320
        let _v2321
        let _v2322
        let _v2323
        let _v2324
        let _v2325
        let _v2326
        let _v2327
        let _v2328
        let _v2329
        let _v2330
        _v2323, _v2324, _v2325, _v2326, _v2327, _v2328, _v2329, _v2330 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2315 := _v2323
        _v2316 := _v2324
        _v2317 := _v2325
        _v2318 := _v2326
        _v2319 := _v2327
        _v2320 := _v2328
        _v2321 := _v2329
        _v2322 := _v2330
        switch _v2315
          case false {usr$revertNotFound()
                      let _v2331
                      _v2331 := usr$ridx$storageLarrayLstringJJ_uint256_memoryLstringJ(4, 0)
                      _result := _v2331
                      leave}
          case true {let _v2332
                     _v2332 := usr$Sub_sub$uint256(eid, 1)
                     let _v2333
                     _v2333 := usr$ridx$storageLarrayLstringJJ_uint256_memoryLstringJ(4, _v2332)
                     _result := _v2333
                     leave}
      }
      function usr$mload (a) -> _result {
        let res
        res := mload(a)
        _result := res
        leave
      }
      function usr$mstore (a, b) { mstore(a, b) }
      function usr$mul (a, b) -> _result {
        let res
        res := mul(a, b)
        _result := res
        leave
      }
      function usr$mulCk (x, y) -> _result {
        let _v2334
        let _v2335
        _v2335 := usr$Eq_eq$uint256(x, 0)
        _v2334 := _v2335
        switch _v2334
          case false {}
          case true {_result := 0
                     leave}
        let _v2336
        let _v2337
        _v2337 := usr$Mul_mul$uint256(x, y)
        _v2336 := _v2337
        let _v2338
        let _v2339
        _v2339 := usr$Div_div$uint256(_v2336, x)
        let _v2340
        _v2340 := usr$ne$uint256(_v2339, y)
        _v2338 := _v2340
        switch _v2338
          case false {}
          case true {usr$panic(17)}
        _result := _v2336
        leave
      }
      function usr$mulWord (l, r) -> _result {
        let _v2341
        _v2341 := usr$mul(l, r)
        _result := _v2341
        leave
      }
      function usr$ne$uint256 (x, y) -> _v2342 {
        let _v2343
        _v2343 := usr$Eq_eq$uint256(x, y)
        let _v2344
        _v2344 := usr$not(_v2343)
        _v2342 := _v2344
        leave
      }
      function usr$ne$word (x, y) -> _v2345 {
        let _v2346
        _v2346 := usr$Eq_eq$word(x, y)
        let _v2347
        _v2347 := usr$not(_v2346)
        _v2345 := _v2347
        leave
      }
      function usr$not (_v2348) -> _v2349 {
        switch _v2348
          case false {_v2349 := true
                      leave}
          case true {_v2349 := false
                     leave}
      }
      function usr$onlyOrganizerOf (org) {
        let _v2350
        _v2350 := usr$caller()
        let _v2351
        _v2351 := usr$Eq_eq$address(_v2350, org)
        usr$requireK(_v2351, 2403396036)
        leave
      }
      function usr$or (_v2352, _v2353) -> _v2354 {
        switch _v2352
          case false {_v2354 := _v2353
                      leave}
          case true {_v2354 := true
                     leave}
      }
      function usr$organizer (eid) -> _result {
        let _v2355
        let _v2356
        let _v2357
        let _v2358
        let _v2359
        let _v2360
        let _v2361
        let _v2362
        let _v2363
        let _v2364
        let _v2365
        let _v2366
        let _v2367
        let _v2368
        let _v2369
        let _v2370
        _v2363, _v2364, _v2365, _v2366, _v2367, _v2368, _v2369, _v2370 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2355 := _v2363
        _v2356 := _v2364
        _v2357 := _v2365
        _v2358 := _v2366
        _v2359 := _v2367
        _v2360 := _v2368
        _v2361 := _v2369
        _v2362 := _v2370
        switch _v2355
          case false {usr$revertNotFound()
                      _result := 0
                      leave}
          case true {_result := _v2356
                     leave}
      }
      function usr$out_of_bounds () {
        let _v2371
        let _v2372
        let _v2373
        _v2371 := false
        _v2372 := 3021082388
        usr$revertWithError(false, 3021082388, 911)
      }
      function usr$panic (code) {
        let p
        let _v2374
        _v2374 := usr$get_free_memory()
        p := _v2374
        usr$mstore(p, 1313373041)
        let _v2375
        _v2375 := usr$Add_add$word(p, 32)
        usr$mstore(_v2375, code)
        let _v2376
        _v2376 := usr$Add_add$word(p, 28)
        usr$revert_(_v2376, 36)
      }
      function usr$readStorage$AttendeeStatus (x) -> _v2377, _v2378, _v2379, _v2380 {
        let _v2381
        let _v2382
        let _v2383
        let _v2384
        _v2381, _v2382, _v2383, _v2384 := usr$CanStore_load$storageLAttendeeStatusJ(x)
        _v2377 := _v2381
        _v2378 := _v2382
        _v2379 := _v2383
        _v2380 := _v2384
        leave
      }
      function usr$readStorage$Counters (x) -> _v2385, _v2386, _v2387, _v2388 {
        let _v2389
        let _v2390
        let _v2391
        let _v2392
        _v2389, _v2390, _v2391, _v2392 := usr$CanStore_load$storageLCountersJ(x)
        _v2385 := _v2389
        _v2386 := _v2390
        _v2387 := _v2391
        _v2388 := _v2392
        leave
      }
      function usr$readStorage$EventRec (x) -> _v2393, _v2394, _v2395, _v2396, _v2397, _v2398, _v2399, _v2400 {
        let _v2401
        let _v2402
        let _v2403
        let _v2404
        let _v2405
        let _v2406
        let _v2407
        let _v2408
        _v2401, _v2402, _v2403, _v2404, _v2405, _v2406, _v2407, _v2408 := usr$CanStore_load$storageLEventRecJ(x)
        _v2393 := _v2401
        _v2394 := _v2402
        _v2395 := _v2403
        _v2396 := _v2404
        _v2397 := _v2405
        _v2398 := _v2406
        _v2399 := _v2407
        _v2400 := _v2408
        leave
      }
      function usr$readStorage$sumLunit_unitJ (x) -> _v2409 {
        let _v2410
        _v2410 := usr$CanStore_load$storageLsumLf_gJJ$unit_unit(x)
        _v2409 := _v2410
        leave
      }
      function usr$recoverStrict (digest, v, r, s) -> _result {
        usr$mstore(0, 0)
        let _v2411
        _v2411 := usr$ecrecover(digest, v, r, s)
        _result := _v2411
        leave
      }
      function usr$register (eid) {
        let _v2412
        let _v2413
        let _v2414
        let _v2415
        let _v2416
        let _v2417
        let _v2418
        let _v2419
        let _v2420
        let _v2421
        let _v2422
        let _v2423
        let _v2424
        let _v2425
        let _v2426
        let _v2427
        _v2420, _v2421, _v2422, _v2423, _v2424, _v2425, _v2426, _v2427 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2412 := _v2420
        _v2413 := _v2421
        _v2414 := _v2422
        _v2415 := _v2423
        _v2416 := _v2424
        _v2417 := _v2425
        _v2418 := _v2426
        _v2419 := _v2427
        switch _v2412
          case false {usr$revertNotFound()}
          case true {let _v2428
                     _v2428 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v2429
                     let _v2430
                     let _v2431
                     let _v2432
                     _v2429, _v2430, _v2431, _v2432 := usr$deriveState(_v2428, _v2416, _v2417, _v2418)
                     let _v2433
                     _v2433 := usr$stateOrd(_v2429, _v2430, _v2431, _v2432)
                     let _v2434
                     _v2434 := usr$Eq_eq$uint256(_v2433, 0)
                     usr$requireK(_v2434, 801245683)
                     let _v2435
                     _v2435 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v2436
                     _v2436 := usr$caller()
                     let _v2437
                     let _v2438
                     let _v2439
                     let _v2440
                     _v2437, _v2438, _v2439, _v2440 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v2435, _v2436)
                     usr$registerGuard(_v2437, _v2438, _v2439, _v2440)
                     let _v2441
                     let _v2442
                     _v2442 := usr$caller_value()
                     let _v2443
                     _v2443 := usr$ne$uint256(_v2442, _v2414)
                     _v2441 := _v2443
                     switch _v2441
                       case false {}
                       case true {let _v2444
                                  _v2444 := usr$Typedef_rep$uint256(_v2414)
                                  let _v2445
                                  _v2445 := usr$caller_value()
                                  let _v2446
                                  _v2446 := usr$Typedef_rep$uint256(_v2445)
                                  usr$revertWith2(3128224419, _v2444, _v2446)}
                     let _v2447
                     let _v2448
                     let _v2449
                     let _v2450
                     let _v2451
                     let _v2452
                     let _v2453
                     let _v2454
                     _v2451, _v2452, _v2453, _v2454 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v2447 := _v2451
                     _v2448 := _v2452
                     _v2449 := _v2453
                     _v2450 := _v2454
                     let _v2455
                     let _v2456
                     _v2456 := usr$Ord_gt$uint256(_v2419, 0)
                     let _v2457
                     _v2457 := usr$ge$uint256(_v2447, _v2419)
                     let _v2458
                     _v2458 := usr$and(_v2456, _v2457)
                     _v2455 := _v2458
                     switch _v2455
                       case false {}
                       case true {usr$fail(4220419778)}
                     let _v2459
                     _v2459 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v2460
                     _v2460 := usr$caller()
                     let _v2461
                     _v2461 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v2459, _v2460)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v2461, true, false, 911, 911)
                     let _v2462
                     _v2462 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v2463
                     _v2463 := usr$Add_add$uint256(_v2447, 1)
                     let _v2464
                     _v2464 := usr$addCk(_v2450, _v2414)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v2462, _v2463, _v2448, _v2449, _v2464)
                     let _v2465
                     _v2465 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v2466
                     _v2466 := usr$addCk(_v2465, _v2414)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v2466)
                     let _v2467
                     _v2467 := usr$balanceSelf()
                     let _v2468
                     _v2468 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v2469
                     _v2469 := usr$ge$uint256(_v2467, _v2468)
                     usr$solAssert(_v2469)
                     let _v2470
                     _v2470 := usr$Typedef_rep$uint256(eid)
                     let _v2471
                     _v2471 := usr$caller()
                     let _v2472
                     _v2472 := usr$Typedef_rep$address(_v2471)
                     usr$emitLog3(49232042970260620028455006004981854637665831504696444699019501292186195787732, _v2470, _v2472)}
      }
      function usr$registerGuard (_v2473, _v2474, _v2475, _v2476) {
        switch _v2473
          case false {leave}
          case true {switch _v2474
                       case false {usr$fail(981587708)}
                       case true {switch _v2475
                                    case false {leave}
                                    case true {switch _v2476
                                                 case false {usr$revertWith2(3281772918, 3, 0)}
                                                 case true {usr$revertWith2(3281772918, 4, 0)}}}}
      }
      function usr$registeredCount (eid) -> _result {
        let _v2477
        let _v2478
        let _v2479
        let _v2480
        let _v2481
        let _v2482
        let _v2483
        let _v2484
        _v2481, _v2482, _v2483, _v2484 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v2477 := _v2481
        _v2478 := _v2482
        _v2479 := _v2483
        _v2480 := _v2484
        _result := _v2477
        leave
      }
      function usr$removeOperator (eid, operator) {
        usr$setOperatorInner(eid, operator, false)
        leave
      }
      function usr$require (_v2485, _v2486, _v2487, _v2488) {
        let _v2489
        let _v2490
        _v2490 := usr$not(_v2485)
        _v2489 := _v2490
        switch _v2489
          case false {}
          case true {usr$revertWithError(_v2486, _v2487, _v2488)}
      }
      function usr$requireCheckInOpen (_v2491, start, end_, dispute) {
        let _v2492
        let _v2493
        let _v2494
        let _v2495
        let _v2496
        _v2493, _v2494, _v2495, _v2496 := usr$deriveState(_v2491, start, end_, dispute)
        let _v2497
        _v2497 := usr$stateOrd(_v2493, _v2494, _v2495, _v2496)
        _v2492 := _v2497
        let _v2498
        let _v2499
        _v2499 := usr$ne$uint256(_v2492, 1)
        let _v2500
        _v2500 := usr$ne$uint256(_v2492, 2)
        let _v2501
        _v2501 := usr$and(_v2499, _v2500)
        _v2498 := _v2501
        switch _v2498
          case false {}
          case true {usr$fail(3988669644)}
      }
      function usr$requireK (_v2502, e) {
        usr$require(_v2502, false, e, 911)
      }
      function usr$requireStatus (_v2503, _v2504, _v2505, _v2506, expected) {
        let cur
        let _v2507
        _v2507 := usr$statusOrd(_v2503, _v2504, _v2505, _v2506)
        let _v2508
        _v2508 := usr$Typedef_rep$uint256(_v2507)
        cur := _v2508
        let _v2509
        let _v2510
        _v2510 := usr$ne$word(cur, expected)
        _v2509 := _v2510
        switch _v2509
          case false {}
          case true {usr$revertWith2(3281772918, cur, expected)}
      }
      function usr$revertEmpty () {
        usr$revert_(0, 0)
        leave
      }
      function usr$revertNotFound () {
        usr$fail(1524454723)
        leave
      }
      function usr$revertStr (e, msg) {
        let p
        let _v2511
        _v2511 := usr$get_free_memory()
        p := _v2511
        usr$mstore(p, e)
        let _v2512
        _v2512 := usr$Add_add$word(p, 32)
        usr$mstore(_v2512, 32)
        let sptr
        let _v2513
        _v2513 := usr$Typedef_rep$memoryLtJ$string(msg)
        sptr := _v2513
        let len
        let _v2514
        _v2514 := usr$mload(sptr)
        len := _v2514
        let _v2515
        _v2515 := usr$Add_add$word(p, 64)
        usr$mstore(_v2515, len)
        let padded
        let _v2516
        _v2516 := usr$Add_add$word(len, 31)
        let _v2517
        _v2517 := usr$shr(5, _v2516)
        let _v2518
        _v2518 := usr$Mul_mul$word(_v2517, 32)
        padded := _v2518
        for {let i i := 0 let _v2519 let _v2520 _v2519 := usr$lt$word(i, padded)} _v2519 {_v2520 := usr$Add_add$word(i, 32) i := _v2520 _v2519 := usr$lt$word(i, padded)}
        {let _v2521
         _v2521 := usr$Add_add$word(p, 96)
         let _v2522
         _v2522 := usr$Add_add$word(_v2521, i)
         let _v2523
         _v2523 := usr$Add_add$word(sptr, 32)
         let _v2524
         _v2524 := usr$Add_add$word(_v2523, i)
         let _v2525
         _v2525 := usr$mload(_v2524)
         usr$mstore(_v2522, _v2525)}
        let _v2526
        _v2526 := usr$Add_add$word(p, 28)
        let _v2527
        _v2527 := usr$Add_add$word(68, padded)
        usr$revert_(_v2526, _v2527)
      }
      function usr$revertWith2 (e, a, b) {
        let p
        let _v2528
        _v2528 := usr$get_free_memory()
        p := _v2528
        usr$mstore(p, e)
        let _v2529
        _v2529 := usr$Add_add$word(p, 32)
        usr$mstore(_v2529, a)
        let _v2530
        _v2530 := usr$Add_add$word(p, 64)
        usr$mstore(_v2530, b)
        let _v2531
        _v2531 := usr$Add_add$word(p, 28)
        usr$revert_(_v2531, 68)
      }
      function usr$revertWithError (_v2532, _v2533, _v2534) {
        switch _v2532
          case false {usr$mstore(0, _v2533)
                      usr$revert_(28, 4)}
          case true {switch _v2533
                       case false {usr$revert_(0, 0)}
                       case true {let msg_
                                  let _v2535
                                  _v2535 := usr$Typedef_rep$memoryLtJ$string(_v2534)
                                  msg_ := _v2535
                                  let _v2536
                                  _v2536 := usr$Add_add$word(msg_, 32)
                                  let _v2537
                                  _v2537 := usr$mload(msg_)
                                  usr$revert_(_v2536, _v2537)}}
      }
      function usr$revert_ (a, b) { revert(a, b) }
      function usr$rewardPerAttendee (eid) -> _result {
        let _v2538
        let _v2539
        let _v2540
        let _v2541
        let _v2542
        let _v2543
        let _v2544
        let _v2545
        let _v2546
        let _v2547
        let _v2548
        let _v2549
        let _v2550
        let _v2551
        let _v2552
        let _v2553
        _v2546, _v2547, _v2548, _v2549, _v2550, _v2551, _v2552, _v2553 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2538 := _v2546
        _v2539 := _v2547
        _v2540 := _v2548
        _v2541 := _v2549
        _v2542 := _v2550
        _v2543 := _v2551
        _v2544 := _v2552
        _v2545 := _v2553
        switch _v2538
          case false {usr$revertNotFound()
                      _result := 0
                      leave}
          case true {let _v2554
                     let _v2555
                     let _v2556
                     let _v2557
                     let _v2558
                     let _v2559
                     let _v2560
                     let _v2561
                     _v2558, _v2559, _v2560, _v2561 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v2554 := _v2558
                     _v2555 := _v2559
                     _v2556 := _v2560
                     _v2557 := _v2561
                     let _v2562
                     _v2562 := usr$calcReward(_v2554, _v2555, _v2540)
                     _result := _v2562
                     leave}
      }
      function usr$ridx$calldataLarrayLaddressJJ_uint256_address (c, i) -> _result {
        let _v2563
        _v2563 := usr$RValueIdxAccess_lookup$pairLcalldataLarrayLtJJ_iJ$address_uint256_address(c, i)
        _result := _v2563
        leave
      }
      function usr$ridx$calldataLarrayLmemoryLbytesJJJ_uint256_memoryLbytesJ (c, i) -> _result {
        let _v2564
        _v2564 := usr$RValueIdxAccess_lookup$pairLcalldataLarrayLtJJ_iJ$memoryLbytesJ_uint256_memoryLbytesJ(c, i)
        _result := _v2564
        leave
      }
      function usr$ridx$calldataLarrayLuint256JJ_uint256_uint256 (c, i) -> _result {
        let _v2565
        _v2565 := usr$RValueIdxAccess_lookup$pairLcalldataLarrayLtJJ_iJ$uint256_uint256_uint256(c, i)
        _result := _v2565
        leave
      }
      function usr$ridx$storageLarrayLstringJJ_uint256_memoryLstringJ (c, i) -> _result {
        let _v2566
        _v2566 := usr$RValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256_memoryLstringJ(c, i)
        _result := _v2566
        leave
      }
      function usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus (c, i) -> _v2567, _v2568, _v2569, _v2570 {
        let _v2571
        let _v2572
        let _v2573
        let _v2574
        _v2571, _v2572, _v2573, _v2574 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus(c, i)
        _v2567 := _v2571
        _v2568 := _v2572
        _v2569 := _v2573
        _v2570 := _v2574
        leave
      }
      function usr$ridx$storageLmappingLaddress_sumLunit_unitJJJ_address_sumLunit_unitJ (c, i) -> _v2575 {
        let _v2576
        _v2576 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_sumLunit_unitJ(c, i)
        _v2575 := _v2576
        leave
      }
      function usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters (c, i) -> _v2577, _v2578, _v2579, _v2580 {
        let _v2581
        let _v2582
        let _v2583
        let _v2584
        _v2581, _v2582, _v2583, _v2584 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters(c, i)
        _v2577 := _v2581
        _v2578 := _v2582
        _v2579 := _v2583
        _v2580 := _v2584
        leave
      }
      function usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec (c, i) -> _v2585, _v2586, _v2587, _v2588, _v2589, _v2590, _v2591, _v2592 {
        let _v2593
        let _v2594
        let _v2595
        let _v2596
        let _v2597
        let _v2598
        let _v2599
        let _v2600
        _v2593, _v2594, _v2595, _v2596, _v2597, _v2598, _v2599, _v2600 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec(c, i)
        _v2585 := _v2593
        _v2586 := _v2594
        _v2587 := _v2595
        _v2588 := _v2596
        _v2589 := _v2597
        _v2590 := _v2598
        _v2591 := _v2599
        _v2592 := _v2600
        leave
      }
      function usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ (c, i) -> _v2601 {
        let _v2602
        _v2602 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ(c, i)
        _v2601 := _v2602
        leave
      }
      function usr$round_up_to_mul_of_32 (value) -> _result {
        let _v2603
        _v2603 := usr$Add_add$word(value, 31)
        let _v2604
        _v2604 := usr$and_(_v2603, 115792089237316195423570985008687907853269984665640564039457584007913129639904)
        _result := _v2604
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT732580J () -> _v2605 {
        let candidate
        candidate := 412119810
        let selector
        let _v2606
        _v2606 := usr$calldataload(0)
        let _v2607
        _v2607 := usr$shr(224, _v2606)
        selector := _v2607
        let _v2608
        _v2608 := usr$Eq_eq$word(selector, 412119810)
        _v2605 := _v2608
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE726970J () -> _v2609 {
        let candidate
        candidate := 3487298132
        let selector
        let _v2610
        _v2610 := usr$calldataload(0)
        let _v2611
        _v2611 := usr$shr(224, _v2610)
        selector := _v2611
        let _v2612
        _v2612 := usr$Eq_eq$word(selector, 3487298132)
        _v2609 := _v2612
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER721378J () -> _v2613 {
        let candidate
        candidate := 2832447516
        let selector
        let _v2614
        _v2614 := usr$calldataload(0)
        let _v2615
        _v2615 := usr$shr(224, _v2614)
        selector := _v2615
        let _v2616
        _v2616 := usr$Eq_eq$word(selector, 2832447516)
        _v2613 := _v2616
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_addOperator_NonPayable_pairLuint256_addressJ_unit_t_addOperator715799J () -> _v2617 {
        let candidate
        candidate := 2101782291
        let selector
        let _v2618
        _v2618 := usr$calldataload(0)
        let _v2619
        _v2619 := usr$shr(224, _v2618)
        selector := _v2619
        let _v2620
        _v2620 := usr$Eq_eq$word(selector, 2101782291)
        _v2617 := _v2620
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees710234J () -> _v2621 {
        let candidate
        candidate := 119447252
        let selector
        let _v2622
        _v2622 := usr$calldataload(0)
        let _v2623
        _v2623 := usr$shr(224, _v2622)
        selector := _v2623
        let _v2624
        _v2624 := usr$Eq_eq$word(selector, 119447252)
        _v2621 := _v2624
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent696677J () -> _v2625 {
        let candidate
        candidate := 1063893693
        let selector
        let _v2626
        _v2626 := usr$calldataload(0)
        let _v2627
        _v2627 := usr$shr(224, _v2626)
        selector := _v2627
        let _v2628
        _v2628 := usr$Eq_eq$word(selector, 1063893693)
        _v2625 := _v2628
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel704363J () -> _v2629 {
        let candidate
        candidate := 1088786149
        let selector
        let _v2630
        _v2630 := usr$calldataload(0)
        let _v2631
        _v2631 := usr$shr(224, _v2630)
        selector := _v2631
        let _v2632
        _v2632 := usr$Eq_eq$word(selector, 1088786149)
        _v2629 := _v2632
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled690311J () -> _v2633 {
        let candidate
        candidate := 3763387991
        let selector
        let _v2634
        _v2634 := usr$calldataload(0)
        let _v2635
        _v2635 := usr$shr(224, _v2634)
        selector := _v2635
        let _v2636
        _v2636 := usr$Eq_eq$word(selector, 3763387991)
        _v2633 := _v2636
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkInBatchWithProofs_NonPayable_pairLuint256_pairLcalldataLarrayLaddressJJ_pairLcalldataLarrayLuint256JJ_pairLcalldataLarrayLmemoryLbytesJJJ_calldataLarrayLmemoryLbytesJJJJJJJ_unit_t_checkInBatchWithProofs678502J () -> _v2637 {
        let candidate
        candidate := 4086867757
        let selector
        let _v2638
        _v2638 := usr$calldataload(0)
        let _v2639
        _v2639 := usr$shr(224, _v2638)
        selector := _v2639
        let _v2640
        _v2640 := usr$Eq_eq$word(selector, 4086867757)
        _v2637 := _v2640
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkInWithProof_NonPayable_pairLuint256_pairLaddress_pairLuint256_pairLmemoryLbytesJ_memoryLbytesJJJJJ_unit_t_checkInWithProof672126J () -> _v2641 {
        let candidate
        candidate := 3717750565
        let selector
        let _v2642
        _v2642 := usr$calldataload(0)
        let _v2643
        _v2643 := usr$shr(224, _v2642)
        selector := _v2643
        let _v2644
        _v2644 := usr$Eq_eq$word(selector, 3717750565)
        _v2641 := _v2644
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn684539J () -> _v2645 {
        let candidate
        candidate := 2911723263
        let selector
        let _v2646
        _v2646 := usr$calldataload(0)
        let _v2647
        _v2647 := usr$shr(224, _v2646)
        selector := _v2647
        let _v2648
        _v2648 := usr$Eq_eq$word(selector, 2911723263)
        _v2645 := _v2648
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount648156J () -> _v2649 {
        let candidate
        candidate := 4280154022
        let selector
        let _v2650
        _v2650 := usr$calldataload(0)
        let _v2651
        _v2651 := usr$shr(224, _v2650)
        selector := _v2651
        let _v2652
        _v2652 := usr$Eq_eq$word(selector, 4280154022)
        _v2649 := _v2652
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust634664J () -> _v2653 {
        let candidate
        candidate := 798921810
        let selector
        let _v2654
        _v2654 := usr$calldataload(0)
        let _v2655
        _v2655 := usr$shr(224, _v2654)
        selector := _v2655
        let _v2656
        _v2656 := usr$Eq_eq$word(selector, 798921810)
        _v2653 := _v2656
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund627219J () -> _v2657 {
        let candidate
        candidate := 1534832484
        let selector
        let _v2658
        _v2658 := usr$calldataload(0)
        let _v2659
        _v2659 := usr$shr(224, _v2658)
        selector := _v2659
        let _v2660
        _v2660 := usr$Eq_eq$word(selector, 1534832484)
        _v2657 := _v2660
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim642485J () -> _v2661 {
        let candidate
        candidate := 932579317
        let selector
        let _v2662
        _v2662 := usr$calldataload(0)
        let _v2663
        _v2663 := usr$shr(224, _v2662)
        selector := _v2663
        let _v2664
        _v2664 := usr$Eq_eq$word(selector, 932579317)
        _v2661 := _v2664
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount619465J () -> _v2665 {
        let candidate
        candidate := 3399060013
        let selector
        let _v2666
        _v2666 := usr$calldataload(0)
        let _v2667
        _v2667 := usr$shr(224, _v2666)
        selector := _v2667
        let _v2668
        _v2668 := usr$Eq_eq$word(selector, 3399060013)
        _v2665 := _v2668
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent613842J () -> _v2669 {
        let candidate
        candidate := 3798804022
        let selector
        let _v2670
        _v2670 := usr$calldataload(0)
        let _v2671
        _v2671 := usr$shr(224, _v2670)
        selector := _v2671
        let _v2672
        _v2672 := usr$Eq_eq$word(selector, 3798804022)
        _v2669 := _v2672
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount607668J () -> _v2673 {
        let candidate
        candidate := 1908289098
        let selector
        let _v2674
        _v2674 := usr$calldataload(0)
        let _v2675
        _v2675 := usr$shr(224, _v2674)
        selector := _v2675
        let _v2676
        _v2676 := usr$Eq_eq$word(selector, 1908289098)
        _v2673 := _v2676
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent602264J () -> _v2677 {
        let candidate
        candidate := 1830323424
        let selector
        let _v2678
        _v2678 := usr$calldataload(0)
        let _v2679
        _v2679 := usr$shr(224, _v2678)
        selector := _v2679
        let _v2680
        _v2680 := usr$Eq_eq$word(selector, 1830323424)
        _v2677 := _v2680
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState596691J () -> _v2681 {
        let candidate
        candidate := 1154068264
        let selector
        let _v2682
        _v2682 := usr$calldataload(0)
        let _v2683
        _v2683 := usr$shr(224, _v2682)
        selector := _v2683
        let _v2684
        _v2684 := usr$Eq_eq$word(selector, 1154068264)
        _v2681 := _v2684
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held590925J () -> _v2685 {
        let candidate
        candidate := 3739061976
        let selector
        let _v2686
        _v2686 := usr$calldataload(0)
        let _v2687
        _v2687 := usr$shr(224, _v2686)
        selector := _v2687
        let _v2688
        _v2688 := usr$Eq_eq$word(selector, 3739061976)
        _v2685 := _v2688
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_isOperator_NonPayable_pairLuint256_addressJ_sumLunit_unitJ_t_isOperator585412J () -> _v2689 {
        let candidate
        candidate := 2759870394
        let selector
        let _v2690
        _v2690 := usr$calldataload(0)
        let _v2691
        _v2691 := usr$shr(224, _v2690)
        selector := _v2691
        let _v2692
        _v2692 := usr$Eq_eq$word(selector, 2759870394)
        _v2689 := _v2692
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer579876J () -> _v2693 {
        let candidate
        candidate := 2555433771
        let selector
        let _v2694
        _v2694 := usr$calldataload(0)
        let _v2695
        _v2695 := usr$shr(224, _v2694)
        selector := _v2695
        let _v2696
        _v2696 := usr$Eq_eq$word(selector, 2555433771)
        _v2693 := _v2696
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI574576J () -> _v2697 {
        let candidate
        candidate := 202913859
        let selector
        let _v2698
        _v2698 := usr$calldataload(0)
        let _v2699
        _v2699 := usr$shr(224, _v2698)
        selector := _v2699
        let _v2700
        _v2700 := usr$Eq_eq$word(selector, 202913859)
        _v2697 := _v2700
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer568622J () -> _v2701 {
        let candidate
        candidate := 3962601843
        let selector
        let _v2702
        _v2702 := usr$calldataload(0)
        let _v2703
        _v2703 := usr$shr(224, _v2702)
        selector := _v2703
        let _v2704
        _v2704 := usr$Eq_eq$word(selector, 3962601843)
        _v2701 := _v2704
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register563235J () -> _v2705 {
        let candidate
        candidate := 4060567118
        let selector
        let _v2706
        _v2706 := usr$calldataload(0)
        let _v2707
        _v2707 := usr$shr(224, _v2706)
        selector := _v2707
        let _v2708
        _v2708 := usr$Eq_eq$word(selector, 4060567118)
        _v2705 := _v2708
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount555638J () -> _v2709 {
        let candidate
        candidate := 2141081421
        let selector
        let _v2710
        _v2710 := usr$calldataload(0)
        let _v2711
        _v2711 := usr$shr(224, _v2710)
        selector := _v2711
        let _v2712
        _v2712 := usr$Eq_eq$word(selector, 2141081421)
        _v2709 := _v2712
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_removeOperator_NonPayable_pairLuint256_addressJ_unit_t_removeOperator550233J () -> _v2713 {
        let candidate
        candidate := 219730042
        let selector
        let _v2714
        _v2714 := usr$calldataload(0)
        let _v2715
        _v2715 := usr$shr(224, _v2714)
        selector := _v2715
        let _v2716
        _v2716 := usr$Eq_eq$word(selector, 219730042)
        _v2713 := _v2716
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee539456J () -> _v2717 {
        let candidate
        candidate := 2995498174
        let selector
        let _v2718
        _v2718 := usr$calldataload(0)
        let _v2719
        _v2719 := usr$shr(224, _v2718)
        selector := _v2719
        let _v2720
        _v2720 := usr$Eq_eq$word(selector, 2995498174)
        _v2717 := _v2720
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer528800J () -> _v2721 {
        let candidate
        candidate := 334126377
        let selector
        let _v2722
        _v2722 := usr$calldataload(0)
        let _v2723
        _v2723 := usr$shr(224, _v2722)
        selector := _v2723
        let _v2724
        _v2724 := usr$Eq_eq$word(selector, 334126377)
        _v2721 := _v2724
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI523056J () -> _v2725 {
        let candidate
        candidate := 142462612
        let selector
        let _v2726
        _v2726 := usr$calldataload(0)
        let _v2727
        _v2727 := usr$shr(224, _v2726)
        selector := _v2727
        let _v2728
        _v2728 := usr$Eq_eq$word(selector, 142462612)
        _v2725 := _v2728
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld517523J () -> _v2729 {
        let candidate
        candidate := 4097623923
        let selector
        let _v2730
        _v2730 := usr$calldataload(0)
        let _v2731
        _v2731 := usr$shr(224, _v2730)
        selector := _v2731
        let _v2732
        _v2732 := usr$Eq_eq$word(selector, 4097623923)
        _v2729 := _v2732
        leave
      }
      function usr$self () -> _result {
        let _v2733
        _v2733 := usr$address_()
        _result := _v2733
        leave
      }
      function usr$selfbalance () -> _result {
        let res
        res := selfbalance()
        _result := res
        leave
      }
      function usr$sendValue (dst, wad) {
        let ret
        let _v2734
        _v2734 := usr$gas()
        let _v2735
        _v2735 := usr$Typedef_rep$address(dst)
        let _v2736
        _v2736 := usr$Typedef_rep$uint256(wad)
        let _v2737
        _v2737 := usr$call(_v2734, _v2735, _v2736, 0, 0, 0, 0)
        ret := _v2737
        let _v2738
        _v2738 := usr$ne$word(ret, 0)
        usr$requireK(_v2738, 2428038168)
      }
      function usr$setMaintainer (newMaintainer) {
        let _v2739
        _v2739 := usr$caller()
        let _v2740
        _v2740 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        let _v2741
        _v2741 := usr$Eq_eq$address(_v2739, _v2740)
        usr$requireK(_v2741, 3935194805)
        let _v2742
        let _v2743
        _v2743 := usr$Typedef_rep$address(newMaintainer)
        let _v2744
        _v2744 := usr$Eq_eq$word(_v2743, 0)
        _v2742 := _v2744
        switch _v2742
          case false {}
          case true {let _v2745
                     _v2745 := usr$__strlit_0()
                     usr$revertStr(3276808962, _v2745)}
        let _v2746
        let _v2747
        _v2747 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        let _v2748
        _v2748 := usr$Eq_eq$address(newMaintainer, _v2747)
        _v2746 := _v2748
        switch _v2746
          case false {}
          case true {let _v2749
                     _v2749 := usr$__strlit_1()
                     usr$revertStr(3276808962, _v2749)}
        let _v2750
        let _v2751
        _v2751 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        _v2750 := _v2751
        usr$Assign_assign$a$storageLaddressJ_address(0, newMaintainer)
        let _v2752
        _v2752 := usr$Typedef_rep$address(_v2750)
        let _v2753
        _v2753 := usr$Typedef_rep$address(newMaintainer)
        usr$emitLog3(10544129918642067278015250259818348999806374263767378799394942176964542114757, _v2752, _v2753)
      }
      function usr$setMetadataURI (eid, newUri) {
        let _v2754
        let _v2755
        let _v2756
        let _v2757
        let _v2758
        let _v2759
        let _v2760
        let _v2761
        let _v2762
        let _v2763
        let _v2764
        let _v2765
        let _v2766
        let _v2767
        let _v2768
        let _v2769
        _v2762, _v2763, _v2764, _v2765, _v2766, _v2767, _v2768, _v2769 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2754 := _v2762
        _v2755 := _v2763
        _v2756 := _v2764
        _v2757 := _v2765
        _v2758 := _v2766
        _v2759 := _v2767
        _v2760 := _v2768
        _v2761 := _v2769
        switch _v2754
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v2755)
                     let _v2770
                     _v2770 := usr$Sub_sub$uint256(eid, 1)
                     let _v2771
                     _v2771 := usr$lidx$storageLarrayLstringJJ_uint256_storageLstringJ(4, _v2770)
                     usr$Assign_assign$a$storageLstringJ_memoryLstringJ(_v2771, newUri)
                     let _v2772
                     _v2772 := usr$Typedef_rep$uint256(eid)
                     usr$emitLog2Str(31466384846993879489896657419060636725351630481215761739972181624334831612681, _v2772, newUri)}
      }
      function usr$setOperatorInner (eid, operator, _v2773) {
        let _v2774
        let _v2775
        let _v2776
        let _v2777
        let _v2778
        let _v2779
        let _v2780
        let _v2781
        let _v2782
        let _v2783
        let _v2784
        let _v2785
        let _v2786
        let _v2787
        let _v2788
        let _v2789
        _v2782, _v2783, _v2784, _v2785, _v2786, _v2787, _v2788, _v2789 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2774 := _v2782
        _v2775 := _v2783
        _v2776 := _v2784
        _v2777 := _v2785
        _v2778 := _v2786
        _v2779 := _v2787
        _v2780 := _v2788
        _v2781 := _v2789
        switch _v2774
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v2775)
                     let _v2790
                     _v2790 := usr$lidx$storageLmappingLuint256_mappingLaddress_sumLunit_unitJJJJ_uint256_storageLmappingLaddress_sumLunit_unitJJJ(8, eid)
                     let _v2791
                     _v2791 := usr$lidx$storageLmappingLaddress_sumLunit_unitJJJ_address_storageLsumLunit_unitJJ(_v2790, operator)
                     usr$Assign_assign$a$storageLsumLunit_unitJJ_sumLunit_unitJ(_v2791, _v2773)
                     let _v2792
                     _v2792 := usr$Typedef_rep$uint256(eid)
                     let _v2793
                     _v2793 := usr$Typedef_rep$address(operator)
                     let _v2794
                     _v2794 := usr$frombool(_v2773)
                     usr$emitLog3W1(67110527235993842102682136720425951391298974565471105395799994972121997898692, _v2792, _v2793, _v2794)}
      }
      function usr$set_free_memory (loc) {
        usr$mstore(64, loc)
        leave
      }
      function usr$shr (a, b) -> _result {
        let res
        res := shr(a, b)
        _result := res
        leave
      }
      function usr$sload (a) -> _result {
        let res
        res := sload(a)
        _result := res
        leave
      }
      function usr$solAssert (_v2795) {
        let _v2796
        let _v2797
        _v2797 := usr$not(_v2795)
        _v2796 := _v2797
        switch _v2796
          case false {}
          case true {usr$panic(1)}
      }
      function usr$splitSig (sig) -> _v2798, _v2799, _v2800 {
        let p
        let _v2801
        _v2801 := usr$Typedef_rep$memoryLtJ$bytes(sig)
        p := _v2801
        let _v2802
        _v2802 := usr$mload(p)
        let _v2803
        _v2803 := usr$Eq_eq$word(_v2802, 65)
        usr$requireK(_v2803, 1273377307)
        let _v2804
        let _v2805
        _v2805 := usr$Add_add$word(p, 32)
        let _v2806
        _v2806 := usr$mload(_v2805)
        _v2804 := _v2806
        let _v2807
        let _v2808
        _v2808 := usr$Add_add$word(p, 64)
        let _v2809
        _v2809 := usr$mload(_v2808)
        _v2807 := _v2809
        let v
        let _v2810
        _v2810 := usr$Add_add$word(p, 96)
        let _v2811
        _v2811 := usr$mload(_v2810)
        let _v2812
        _v2812 := usr$shr(248, _v2811)
        v := _v2812
        _v2798 := _v2804
        _v2799 := _v2807
        _v2800 := v
        leave
      }
      function usr$sstore (a, b) { sstore(a, b) }
      function usr$stateOrd (_v2813, _v2814, _v2815, _v2816) -> _result {
        switch _v2813
          case false {_result := 0
                      leave}
          case true {switch _v2814
                       case false {_result := 1
                                   leave}
                       case true {switch _v2815
                                    case false {_result := 2
                                                leave}
                                    case true {switch _v2816
                                                 case false {_result := 3
                                                             leave}
                                                 case true {_result := 4
                                                            leave}}}}
      }
      function usr$staticcall (a, b, c, d, e, f) -> _result {
        let res
        res := staticcall(a, b, c, d, e, f)
        _result := res
        leave
      }
      function usr$statusOrd (_v2817, _v2818, _v2819, _v2820) -> _result {
        switch _v2817
          case false {_result := 0
                      leave}
          case true {switch _v2818
                       case false {_result := 1
                                   leave}
                       case true {switch _v2819
                                    case false {_result := 2
                                                leave}
                                    case true {switch _v2820
                                                 case false {_result := 3
                                                             leave}
                                                 case true {_result := 4
                                                            leave}}}}
      }
      function usr$storeBytesFromMemory (slot, src) {
        let newLen := mload(src)
        let srcOffset := 32
        switch gt(newLen, 31)
          case 1 {mstore(0, slot)
                  let dstPtr := keccak256(0, 32)
                  let loopEnd := and(newLen, not(31))
                  let i := 0
                  for {} lt(i, loopEnd) {i := add(i, 32)}
                  {sstore(dstPtr, mload(add(src, srcOffset)))
                   dstPtr := add(dstPtr, 1)
                   srcOffset := add(srcOffset, 32)}
                  if lt(loopEnd, newLen) {let lastValue := mload(add(src, srcOffset))
                                          let lastLen := and(newLen, 31)
                                          let mask := not(shr(mul(8, lastLen), not(0)))
                                          let nudata := and(lastValue, mask)
                                          sstore(dstPtr, nudata)}
                  sstore(slot, add(mul(newLen, 2), 1))}
        default {let value := 0
                 if newLen {value := mload(add(src, srcOffset))}
                 let mask := not(shr(mul(8, newLen), not(0)))
                 let nudata := and(value, mask)
                 let used := or(nudata, mul(2, newLen))
                 sstore(slot, used)}
      }
      function usr$sub (a, b) -> _result {
        let res
        res := sub(a, b)
        _result := res
        leave
      }
      function usr$subCk (x, y) -> _result {
        let _v2821
        let _v2822
        _v2822 := usr$Ord_gt$uint256(y, x)
        _v2821 := _v2822
        switch _v2821
          case false {}
          case true {usr$panic(17)}
        let _v2823
        _v2823 := usr$Sub_sub$uint256(x, y)
        _result := _v2823
        leave
      }
      function usr$subWord (l, r) -> _result {
        let _v2824
        _v2824 := usr$sub(l, r)
        _result := _v2824
        leave
      }
      function usr$timeNow () -> _result {
        let _v2825
        _v2825 := usr$timestamp()
        _result := _v2825
        leave
      }
      function usr$timestamp () -> _result {
        let res
        res := timestamp()
        _result := res
        leave
      }
      function usr$tobool (x) -> _v2826 {
        switch x
          case 0 {_v2826 := false
                  leave}
        default {_v2826 := true
                 leave}
      }
      function usr$totalHeld () -> _result {
        let _v2827
        _v2827 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
        _result := _v2827
        leave
      }
      function usr$validateEventParams (depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod) {
        let _v2828
        let _v2829
        _v2829 := usr$Eq_eq$uint256(depositAmount, 0)
        _v2828 := _v2829
        switch _v2828
          case false {}
          case true {let _v2830
                     _v2830 := usr$__strlit_2()
                     usr$revertStr(3276808962, _v2830)}
        let _v2831
        let _v2832
        _v2832 := usr$timeNow()
        let _v2833
        _v2833 := usr$le$uint256(eventStart, _v2832)
        _v2831 := _v2833
        switch _v2831
          case false {}
          case true {let _v2834
                     _v2834 := usr$__strlit_3()
                     usr$revertStr(3276808962, _v2834)}
        let _v2835
        let _v2836
        _v2836 := usr$le$uint256(eventEnd, eventStart)
        _v2835 := _v2836
        switch _v2835
          case false {}
          case true {let _v2837
                     _v2837 := usr$__strlit_4()
                     usr$revertStr(3276808962, _v2837)}
        let _v2838
        let _v2839
        _v2839 := usr$addCk(cancellationDeadline, 7200)
        let _v2840
        _v2840 := usr$Ord_gt$uint256(_v2839, eventStart)
        _v2838 := _v2840
        switch _v2838
          case false {}
          case true {let _v2841
                     _v2841 := usr$__strlit_5()
                     usr$revertStr(3276808962, _v2841)}
        let _v2842
        let _v2843
        _v2843 := usr$timeNow()
        let _v2844
        _v2844 := usr$le$uint256(cancellationDeadline, _v2843)
        _v2842 := _v2844
        switch _v2842
          case false {}
          case true {let _v2845
                     _v2845 := usr$__strlit_6()
                     usr$revertStr(3276808962, _v2845)}
        let _v2846
        let _v2847
        _v2847 := usr$lt$uint256(disputePeriod, 3600)
        _v2846 := _v2847
        switch _v2846
          case false {}
          case true {let _v2848
                     _v2848 := usr$__strlit_7()
                     usr$revertStr(3276808962, _v2848)}
        let _v2849
        let _v2850
        _v2850 := usr$Ord_gt$uint256(disputePeriod, 2592000)
        _v2849 := _v2850
        switch _v2849
          case false {}
          case true {let _v2851
                     _v2851 := usr$__strlit_8()
                     usr$revertStr(3276808962, _v2851)}
      }
      function usr$verifyProof (eid, org, dom, attendee, validUntil, ticketSig, presenceSig) {
        let _v2852
        _v2852 := usr$timeNow()
        let _v2853
        _v2853 := usr$le$uint256(_v2852, validUntil)
        usr$requireK(_v2853, 3061479187)
        let _v2854
        let _v2855
        let _v2856
        let _v2857
        let _v2858
        let _v2859
        _v2857, _v2858, _v2859 := usr$splitSig(ticketSig)
        _v2854 := _v2857
        _v2855 := _v2858
        _v2856 := _v2859
        let _v2860
        _v2860 := usr$hashTicket(eid)
        let _v2861
        _v2861 := usr$eip712Digest(dom, _v2860)
        let _v2862
        _v2862 := usr$recoverStrict(_v2861, _v2856, _v2854, _v2855)
        let _v2863
        _v2863 := usr$Eq_eq$address(_v2862, attendee)
        usr$requireK(_v2863, 2923763416)
        let _v2864
        let _v2865
        let _v2866
        let _v2867
        let _v2868
        let _v2869
        _v2867, _v2868, _v2869 := usr$splitSig(presenceSig)
        _v2864 := _v2867
        _v2865 := _v2868
        _v2866 := _v2869
        let _v2870
        let _v2871
        _v2871 := usr$hashPresence(eid, attendee, validUntil)
        let _v2872
        _v2872 := usr$eip712Digest(dom, _v2871)
        let _v2873
        _v2873 := usr$recoverStrict(_v2872, _v2866, _v2864, _v2865)
        _v2870 := _v2873
        let _v2874
        _v2874 := usr$Eq_eq$address(_v2870, org)
        let _v2875
        _v2875 := usr$lidx$storageLmappingLuint256_mappingLaddress_sumLunit_unitJJJJ_uint256_storageLmappingLaddress_sumLunit_unitJJJ(8, eid)
        let _v2876
        _v2876 := usr$ridx$storageLmappingLaddress_sumLunit_unitJJJ_address_sumLunit_unitJ(_v2875, _v2870)
        let _v2877
        _v2877 := usr$or(_v2874, _v2876)
        usr$requireK(_v2877, 3767053026)
      }
      function usr$zeroize_memory (ptr, len) {
        let end_ptr
        let _v2878
        _v2878 := usr$Add_add$word(ptr, len)
        end_ptr := _v2878
        for {let i i := 0 let _v2879 let _v2880 let _v2881 _v2879 := usr$Div_div$word(len, 32) _v2880 := usr$lt$word(i, _v2879)} _v2880 {_v2881 := usr$Add_add$word(i, 1) i := _v2881 _v2879 := usr$Div_div$word(len, 32) _v2880 := usr$lt$word(i, _v2879)}
        {usr$mstore(ptr, 0)
         let _v2882
         _v2882 := usr$Add_add$word(ptr, 32)
         ptr := _v2882}
        let _v2883
        _v2883 := usr$Sub_sub$word(end_ptr, ptr)
        usr$mcopy(ptr, 96, _v2883)
      }
      let _mainresult := usr$main()
      mstore(0, _mainresult)
      return(0, 32)
    }
  }
}