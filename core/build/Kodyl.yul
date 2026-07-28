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
      usr$invokable_invoke$t_init_628375(_v15)
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
    function usr$invokable_invoke$t_init_628375 (arg628377) {
      let _v31
      _v31 := arg628377
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
      function usr$ABIDecode_decode$ABIDecoderLmemoryLstringJ_readerJ$CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let _v57
        _v57 := usr$decodeBytesLike$string_CalldataWordReader(ptr, currentHeadOffset)
        _result := _v57
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_address_CalldataWordReader_uint256_address (ptr, currentHeadOffset) -> _v58, _v59 {
        let _v60
        _v60 := ptr
        let _v61
        _v61 := ptr
        let _v62
        let _v63
        _v63 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v60, currentHeadOffset)
        _v62 := _v63
        let _v64
        let _v65
        _v65 := usr$Add_add$word(currentHeadOffset, 32)
        let _v66
        _v66 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader(_v61, _v65)
        _v64 := _v66
        _v58 := _v62
        _v59 := _v64
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_memoryLstringJ_CalldataWordReader_uint256_memoryLstringJ (ptr, currentHeadOffset) -> _v67, _v68 {
        let _v69
        _v69 := ptr
        let _v70
        _v70 := ptr
        let _v71
        let _v72
        _v72 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v69, currentHeadOffset)
        _v71 := _v72
        let _v73
        let _v74
        _v74 := usr$Add_add$word(currentHeadOffset, 32)
        let _v75
        _v75 := usr$ABIDecode_decode$ABIDecoderLmemoryLstringJ_readerJ$CalldataWordReader(_v70, _v74)
        _v73 := _v75
        _v67 := _v71
        _v68 := _v73
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_memoryLstringJJ_CalldataWordReader_uint256_pairLuint256_memoryLstringJJ (ptr, currentHeadOffset) -> _v76, _v77, _v78 {
        let _v79
        _v79 := ptr
        let _v80
        _v80 := ptr
        let _v81
        let _v82
        _v82 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v79, currentHeadOffset)
        _v81 := _v82
        let _v83
        let _v84
        let _v85
        _v85 := usr$Add_add$word(currentHeadOffset, 32)
        let _v86
        let _v87
        _v86, _v87 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_memoryLstringJ_CalldataWordReader_uint256_memoryLstringJ(_v80, _v85)
        _v83 := _v86
        _v84 := _v87
        _v76 := _v81
        _v77 := _v83
        _v78 := _v84
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_memoryLstringJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_memoryLstringJJJ (ptr, currentHeadOffset) -> _v88, _v89, _v90, _v91 {
        let _v92
        _v92 := ptr
        let _v93
        _v93 := ptr
        let _v94
        let _v95
        _v95 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v92, currentHeadOffset)
        _v94 := _v95
        let _v96
        let _v97
        let _v98
        let _v99
        _v99 := usr$Add_add$word(currentHeadOffset, 32)
        let _v100
        let _v101
        let _v102
        _v100, _v101, _v102 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_memoryLstringJJ_CalldataWordReader_uint256_pairLuint256_memoryLstringJJ(_v93, _v99)
        _v96 := _v100
        _v97 := _v101
        _v98 := _v102
        _v88 := _v94
        _v89 := _v96
        _v90 := _v97
        _v91 := _v98
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ (ptr, currentHeadOffset) -> _v103, _v104, _v105, _v106, _v107 {
        let _v108
        _v108 := ptr
        let _v109
        _v109 := ptr
        let _v110
        let _v111
        _v111 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v108, currentHeadOffset)
        _v110 := _v111
        let _v112
        let _v113
        let _v114
        let _v115
        let _v116
        _v116 := usr$Add_add$word(currentHeadOffset, 32)
        let _v117
        let _v118
        let _v119
        let _v120
        _v117, _v118, _v119, _v120 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_memoryLstringJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_memoryLstringJJJ(_v109, _v116)
        _v112 := _v117
        _v113 := _v118
        _v114 := _v119
        _v115 := _v120
        _v103 := _v110
        _v104 := _v112
        _v105 := _v113
        _v106 := _v114
        _v107 := _v115
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ (ptr, currentHeadOffset) -> _v121, _v122, _v123, _v124, _v125, _v126 {
        let _v127
        _v127 := ptr
        let _v128
        _v128 := ptr
        let _v129
        let _v130
        _v130 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v127, currentHeadOffset)
        _v129 := _v130
        let _v131
        let _v132
        let _v133
        let _v134
        let _v135
        let _v136
        _v136 := usr$Add_add$word(currentHeadOffset, 32)
        let _v137
        let _v138
        let _v139
        let _v140
        let _v141
        _v137, _v138, _v139, _v140, _v141 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJ(_v128, _v136)
        _v131 := _v137
        _v132 := _v138
        _v133 := _v139
        _v134 := _v140
        _v135 := _v141
        _v121 := _v129
        _v122 := _v131
        _v123 := _v132
        _v124 := _v133
        _v125 := _v134
        _v126 := _v135
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ (ptr, currentHeadOffset) -> _v142, _v143, _v144, _v145, _v146, _v147, _v148 {
        let _v149
        _v149 := ptr
        let _v150
        _v150 := ptr
        let _v151
        let _v152
        _v152 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v149, currentHeadOffset)
        _v151 := _v152
        let _v153
        let _v154
        let _v155
        let _v156
        let _v157
        let _v158
        let _v159
        _v159 := usr$Add_add$word(currentHeadOffset, 32)
        let _v160
        let _v161
        let _v162
        let _v163
        let _v164
        let _v165
        _v160, _v161, _v162, _v163, _v164, _v165 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJ(_v150, _v159)
        _v153 := _v160
        _v154 := _v161
        _v155 := _v162
        _v156 := _v163
        _v157 := _v164
        _v158 := _v165
        _v142 := _v151
        _v143 := _v153
        _v144 := _v154
        _v145 := _v155
        _v146 := _v156
        _v147 := _v157
        _v148 := _v158
        leave
      }
      function usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let _v166
        _v166 := usr$WordReader_advance$ABIDecoderLty_readerJ$uint256_CalldataWordReader(ptr, currentHeadOffset)
        let _v167
        _v167 := usr$WordReader_read$ABIDecoderLty_readerJ$uint256_CalldataWordReader(_v166)
        let _v168
        _v168 := usr$Typedef_abs$uint256(_v167)
        _result := _v168
        leave
      }
      function usr$ABIEncode_encodeInto$address (x, basePtr, offset, tail) -> _result {
        let repx
        let _v169
        _v169 := usr$Typedef_rep$address(x)
        repx := _v169
        let _v170
        _v170 := usr$Add_add$word(basePtr, offset)
        usr$mstore(_v170, repx)
        _result := tail
        leave
      }
      function usr$ABIEncode_encodeInto$memoryLstringJ (x, basePtr, offset, tail) -> _result {
        let _v171
        _v171 := usr$Typedef_rep$memoryLtJ$string(x)
        let _v172
        _v172 := usr$encodeIntoFromBytesLike(_v171, basePtr, offset, tail)
        _result := _v172
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ (_v173, _v174, _v175, _v176, _v177, _v178, _v179, basePtr, offset, tail) -> _result {
        let newTail
        let _v180
        _v180 := usr$ABIEncode_encodeInto$address(_v173, basePtr, offset, tail)
        newTail := _v180
        let a_sz
        a_sz := 32
        let _v181
        _v181 := usr$Add_add$word(offset, 32)
        let _v182
        _v182 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(_v174, _v175, _v176, _v177, _v178, _v179, basePtr, _v181, newTail)
        _result := _v182
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ (_v183, _v184, _v185, _v186, _v187, _v188, basePtr, offset, tail) -> _result {
        let newTail
        let _v189
        _v189 := usr$ABIEncode_encodeInto$uint256(_v183, basePtr, offset, tail)
        newTail := _v189
        let a_sz
        a_sz := 32
        let _v190
        _v190 := usr$Add_add$word(offset, 32)
        let _v191
        _v191 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ(_v184, _v185, _v186, _v187, _v188, basePtr, _v190, newTail)
        _result := _v191
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ (_v192, _v193, _v194, _v195, _v196, basePtr, offset, tail) -> _result {
        let newTail
        let _v197
        _v197 := usr$ABIEncode_encodeInto$uint256(_v192, basePtr, offset, tail)
        newTail := _v197
        let a_sz
        a_sz := 32
        let _v198
        _v198 := usr$Add_add$word(offset, 32)
        let _v199
        _v199 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v193, _v194, _v195, _v196, basePtr, _v198, newTail)
        _result := _v199
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_pairLuint256_uint256JJ (_v200, _v201, _v202, _v203, basePtr, offset, tail) -> _result {
        let newTail
        let _v204
        _v204 := usr$ABIEncode_encodeInto$uint256(_v200, basePtr, offset, tail)
        newTail := _v204
        let a_sz
        a_sz := 32
        let _v205
        _v205 := usr$Add_add$word(offset, 32)
        let _v206
        _v206 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_uint256J(_v201, _v202, _v203, basePtr, _v205, newTail)
        _result := _v206
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_pairLuint256_uint256J (_v207, _v208, _v209, basePtr, offset, tail) -> _result {
        let newTail
        let _v210
        _v210 := usr$ABIEncode_encodeInto$uint256(_v207, basePtr, offset, tail)
        newTail := _v210
        let a_sz
        a_sz := 32
        let _v211
        _v211 := usr$Add_add$word(offset, 32)
        let _v212
        _v212 := usr$ABIEncode_encodeInto$pairLa_bJ$uint256_uint256(_v208, _v209, basePtr, _v211, newTail)
        _result := _v212
        leave
      }
      function usr$ABIEncode_encodeInto$pairLa_bJ$uint256_uint256 (_v213, _v214, basePtr, offset, tail) -> _result {
        let newTail
        let _v215
        _v215 := usr$ABIEncode_encodeInto$uint256(_v213, basePtr, offset, tail)
        newTail := _v215
        let a_sz
        a_sz := 32
        let _v216
        _v216 := usr$Add_add$word(offset, 32)
        let _v217
        _v217 := usr$ABIEncode_encodeInto$uint256(_v214, basePtr, _v216, newTail)
        _result := _v217
        leave
      }
      function usr$ABIEncode_encodeInto$sumLunit_unitJ (_v218, basePtr, offset, tail) -> _result {
        let repx
        let _v219
        _v219 := usr$frombool(_v218)
        repx := _v219
        let _v220
        _v220 := usr$Add_add$word(basePtr, offset)
        usr$mstore(_v220, repx)
        _result := tail
        leave
      }
      function usr$ABIEncode_encodeInto$uint256 (x, basePtr, offset, tail) -> _result {
        let repx
        let _v221
        _v221 := usr$Typedef_rep$uint256(x)
        repx := _v221
        let _v222
        _v222 := usr$Add_add$word(basePtr, offset)
        usr$mstore(_v222, repx)
        _result := tail
        leave
      }
      function usr$ABIEncode_encodeInto$unit (basePtr, offset, tail) -> _result {
        _result := tail
        leave
      }
      function usr$Add_add$uint256 (x, y) -> _result {
        let _v223
        _v223 := usr$Typedef_rep$uint256(x)
        let _v224
        _v224 := usr$Typedef_rep$uint256(y)
        let _v225
        _v225 := usr$Add_add$word(_v223, _v224)
        let _v226
        _v226 := usr$Typedef_abs$uint256(_v225)
        _result := _v226
        leave
      }
      function usr$Add_add$word (l, r) -> _result {
        let _v227
        _v227 := usr$addWord(l, r)
        _result := _v227
        leave
      }
      function usr$ArrayPush_push$storageLarrayLtJJ$string_memoryLstringJ (arr, val) {
        let slot
        let _v228
        _v228 := usr$Typedef_rep$storageLtJ$arrayLstringJ(arr)
        slot := _v228
        let n
        let _v229
        _v229 := usr$sload(slot)
        n := _v229
        let _v230
        _v230 := usr$hash1(slot)
        let _v231
        _v231 := usr$Add_add$word(_v230, n)
        usr$CanStore_store$storageLstringJ(_v231, val)
        let _v232
        _v232 := usr$Add_add$word(n, 1)
        usr$sstore(slot, _v232)
      }
      function usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus (l, _v233, _v234, _v235, _v236) {
        usr$CanStore_store$storageLAttendeeStatusJ(l, _v233, _v234, _v235, _v236)
        leave
      }
      function usr$Assign_assign$a$storageLCountersJ_Counters (l, _v237, _v238, _v239, _v240) {
        usr$CanStore_store$storageLCountersJ(l, _v237, _v238, _v239, _v240)
        leave
      }
      function usr$Assign_assign$a$storageLEventRecJ_EventRec (l, _v241, _v242, _v243, _v244, _v245, _v246, _v247, _v248) {
        usr$CanStore_store$storageLEventRecJ(l, _v241, _v242, _v243, _v244, _v245, _v246, _v247, _v248)
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
      function usr$Assign_assign$a$storageLsumLunit_unitJJ_sumLunit_unitJ (l, _v249) {
        usr$CanStore_store$storageLsumLf_gJJ$unit_unit(l, _v249)
        leave
      }
      function usr$Assign_assign$a$storageLuint256J_uint256 (l, r) {
        usr$CanStore_store$storageLuint256J(l, r)
        leave
      }
      function usr$CanStore_load$storageLAttendeeStatusJ (_r) -> _v250, _v251, _v252, _v253 {
        let _v254
        let _v255
        let _v256
        let _v257
        let _v258
        _v258 := usr$Typedef_rep$storageLtJ$AttendeeStatus(_r)
        let _v259
        let _v260
        let _v261
        let _v262
        _v259, _v260, _v261, _v262 := usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ(_v258)
        _v254 := _v259
        _v255 := _v260
        _v256 := _v261
        _v257 := _v262
        let _v263
        let _v264
        let _v265
        let _v266
        _v263, _v264, _v265, _v266 := usr$Generic_to$AttendeeStatus(_v254, _v255, _v256, _v257)
        _v250 := _v263
        _v251 := _v264
        _v252 := _v265
        _v253 := _v266
        leave
      }
      function usr$CanStore_load$storageLCountersJ (_r) -> _v267, _v268, _v269, _v270 {
        let _v271
        let _v272
        let _v273
        let _v274
        let _v275
        _v275 := usr$Typedef_rep$storageLtJ$Counters(_r)
        let _v276
        let _v277
        let _v278
        let _v279
        _v276, _v277, _v278, _v279 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v275)
        _v271 := _v276
        _v272 := _v277
        _v273 := _v278
        _v274 := _v279
        let _v280
        let _v281
        let _v282
        let _v283
        _v280, _v281, _v282, _v283 := usr$Generic_to$Counters(_v271, _v272, _v273, _v274)
        _v267 := _v280
        _v268 := _v281
        _v269 := _v282
        _v270 := _v283
        leave
      }
      function usr$CanStore_load$storageLEventRecJ (_r) -> _v284, _v285, _v286, _v287, _v288, _v289, _v290, _v291 {
        let _v292
        let _v293
        let _v294
        let _v295
        let _v296
        let _v297
        let _v298
        let _v299
        let _v300
        _v300 := usr$Typedef_rep$storageLtJ$EventRec(_r)
        let _v301
        let _v302
        let _v303
        let _v304
        let _v305
        let _v306
        let _v307
        let _v308
        _v301, _v302, _v303, _v304, _v305, _v306, _v307, _v308 := usr$CanStore_load$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(_v300)
        _v292 := _v301
        _v293 := _v302
        _v294 := _v303
        _v295 := _v304
        _v296 := _v305
        _v297 := _v306
        _v298 := _v307
        _v299 := _v308
        let _v309
        let _v310
        let _v311
        let _v312
        let _v313
        let _v314
        let _v315
        let _v316
        _v309, _v310, _v311, _v312, _v313, _v314, _v315, _v316 := usr$Generic_to$EventRec(_v292, _v293, _v294, _v295, _v296, _v297, _v298, _v299)
        _v284 := _v309
        _v285 := _v310
        _v286 := _v311
        _v287 := _v312
        _v288 := _v313
        _v289 := _v314
        _v290 := _v315
        _v291 := _v316
        leave
      }
      function usr$CanStore_load$storageLaddressJ (l) -> _result {
        let _v317
        _v317 := usr$Typedef_rep$storageLtJ$address(l)
        let _v318
        _v318 := usr$StorageType_load$address(_v317)
        _result := _v318
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ (r) -> _v319, _v320, _v321, _v322, _v323, _v324, _v325 {
        let base
        let _v326
        _v326 := usr$Typedef_rep$storageLtJ$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(r)
        base := _v326
        let a_sz
        a_sz := 1
        let _v327
        let _v328
        _v328 := usr$CanStore_load$storageLaddressJ(base)
        _v327 := _v328
        let _v329
        let _v330
        let _v331
        let _v332
        let _v333
        let _v334
        let _v335
        _v335 := usr$Add_add$word(base, 1)
        let _v336
        let _v337
        let _v338
        let _v339
        let _v340
        let _v341
        _v336, _v337, _v338, _v339, _v340, _v341 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(_v335)
        _v329 := _v336
        _v330 := _v337
        _v331 := _v338
        _v332 := _v339
        _v333 := _v340
        _v334 := _v341
        _v319 := _v327
        _v320 := _v329
        _v321 := _v330
        _v322 := _v331
        _v323 := _v332
        _v324 := _v333
        _v325 := _v334
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ (r) -> _v342, _v343, _v344, _v345, _v346, _v347 {
        let base
        let _v348
        _v348 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(r)
        base := _v348
        let a_sz
        a_sz := 1
        let _v349
        let _v350
        _v350 := usr$CanStore_load$storageLuint256J(base)
        _v349 := _v350
        let _v351
        let _v352
        let _v353
        let _v354
        let _v355
        let _v356
        _v356 := usr$Add_add$word(base, 1)
        let _v357
        let _v358
        let _v359
        let _v360
        let _v361
        _v357, _v358, _v359, _v360, _v361 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ(_v356)
        _v351 := _v357
        _v352 := _v358
        _v353 := _v359
        _v354 := _v360
        _v355 := _v361
        _v342 := _v349
        _v343 := _v351
        _v344 := _v352
        _v345 := _v353
        _v346 := _v354
        _v347 := _v355
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ (r) -> _v362, _v363, _v364, _v365, _v366 {
        let base
        let _v367
        _v367 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(r)
        base := _v367
        let a_sz
        a_sz := 1
        let _v368
        let _v369
        _v369 := usr$CanStore_load$storageLuint256J(base)
        _v368 := _v369
        let _v370
        let _v371
        let _v372
        let _v373
        let _v374
        _v374 := usr$Add_add$word(base, 1)
        let _v375
        let _v376
        let _v377
        let _v378
        _v375, _v376, _v377, _v378 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v374)
        _v370 := _v375
        _v371 := _v376
        _v372 := _v377
        _v373 := _v378
        _v362 := _v368
        _v363 := _v370
        _v364 := _v371
        _v365 := _v372
        _v366 := _v373
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ (r) -> _v379, _v380, _v381, _v382 {
        let base
        let _v383
        _v383 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_uint256JJJ(r)
        base := _v383
        let a_sz
        a_sz := 1
        let _v384
        let _v385
        _v385 := usr$CanStore_load$storageLuint256J(base)
        _v384 := _v385
        let _v386
        let _v387
        let _v388
        let _v389
        _v389 := usr$Add_add$word(base, 1)
        let _v390
        let _v391
        let _v392
        _v390, _v391, _v392 := usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_uint256J(_v389)
        _v386 := _v390
        _v387 := _v391
        _v388 := _v392
        _v379 := _v384
        _v380 := _v386
        _v381 := _v387
        _v382 := _v388
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_pairLuint256_uint256J (r) -> _v393, _v394, _v395 {
        let base
        let _v396
        _v396 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_uint256JJ(r)
        base := _v396
        let a_sz
        a_sz := 1
        let _v397
        let _v398
        _v398 := usr$CanStore_load$storageLuint256J(base)
        _v397 := _v398
        let _v399
        let _v400
        let _v401
        _v401 := usr$Add_add$word(base, 1)
        let _v402
        let _v403
        _v402, _v403 := usr$CanStore_load$storageLpairLa_bJJ$uint256_uint256(_v401)
        _v399 := _v402
        _v400 := _v403
        _v393 := _v397
        _v394 := _v399
        _v395 := _v400
        leave
      }
      function usr$CanStore_load$storageLpairLa_bJJ$uint256_uint256 (r) -> _v404, _v405 {
        let base
        let _v406
        _v406 := usr$Typedef_rep$storageLtJ$pairLuint256_uint256J(r)
        base := _v406
        let a_sz
        a_sz := 1
        let _v407
        let _v408
        _v408 := usr$CanStore_load$storageLuint256J(base)
        _v407 := _v408
        let _v409
        let _v410
        _v410 := usr$Add_add$word(base, 1)
        let _v411
        _v411 := usr$CanStore_load$storageLuint256J(_v410)
        _v409 := _v411
        _v404 := _v407
        _v405 := _v409
        leave
      }
      function usr$CanStore_load$storageLstringJ (src) -> _result {
        let srcPtr
        let _v412
        _v412 := usr$Typedef_rep$storageLtJ$string(src)
        srcPtr := _v412
        let dstPtr
        let _v413
        _v413 := usr$get_free_memory()
        dstPtr := _v413
        let endPtr
        let _v414
        _v414 := usr$loadBytesFromStorage(srcPtr, dstPtr)
        endPtr := _v414
        usr$set_free_memory(endPtr)
        _result := dstPtr
        leave
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ (r) -> _v415, _v416, _v417, _v418, _v419, _v420, _v421, _v422 {
        let base
        let _v423
        _v423 := usr$Typedef_rep$storageLtJ$sumLunit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJJ(r)
        base := _v423
        let tag
        let _v424
        _v424 := usr$sload(base)
        tag := _v424
        switch tag
          case 0 {_v415 := false
                  leave}
        default {let _v425
                 _v425 := usr$Add_add$word(base, 1)
                 let _v426
                 let _v427
                 let _v428
                 let _v429
                 let _v430
                 let _v431
                 let _v432
                 _v426, _v427, _v428, _v429, _v430, _v431, _v432 := usr$CanStore_load$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(_v425)
                 _v415 := true
                 _v416 := _v426
                 _v417 := _v427
                 _v418 := _v428
                 _v419 := _v429
                 _v420 := _v430
                 _v421 := _v431
                 _v422 := _v432
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ (r) -> _v433, _v434, _v435, _v436 {
        let base
        let _v437
        _v437 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_sumLunit_unitJJJJ(r)
        base := _v437
        let tag
        let _v438
        _v438 := usr$sload(base)
        tag := _v438
        switch tag
          case 0 {_v433 := false
                  leave}
        default {let _v439
                 _v439 := usr$Add_add$word(base, 1)
                 let _v440
                 let _v441
                 let _v442
                 _v440, _v441, _v442 := usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ(_v439)
                 _v433 := true
                 _v434 := _v440
                 _v435 := _v441
                 _v436 := _v442
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ (r) -> _v443, _v444, _v445 {
        let base
        let _v446
        _v446 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_unitJJJ(r)
        base := _v446
        let tag
        let _v447
        _v447 := usr$sload(base)
        tag := _v447
        switch tag
          case 0 {_v443 := false
                  leave}
        default {let _v448
                 _v448 := usr$Add_add$word(base, 1)
                 let _v449
                 let _v450
                 _v449, _v450 := usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_unitJ(_v448)
                 _v443 := true
                 _v444 := _v449
                 _v445 := _v450
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_sumLunit_unitJ (r) -> _v451, _v452 {
        let base
        let _v453
        _v453 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_unitJJ(r)
        base := _v453
        let tag
        let _v454
        _v454 := usr$sload(base)
        tag := _v454
        switch tag
          case 0 {_v451 := false
                  leave}
        default {let _v455
                 _v455 := usr$Add_add$word(base, 1)
                 let _v456
                 _v456 := usr$CanStore_load$storageLsumLf_gJJ$unit_unit(_v455)
                 _v451 := true
                 _v452 := _v456
                 leave}
      }
      function usr$CanStore_load$storageLsumLf_gJJ$unit_unit (r) -> _v457 {
        let base
        let _v458
        _v458 := usr$Typedef_rep$storageLtJ$sumLunit_unitJ(r)
        base := _v458
        let tag
        let _v459
        _v459 := usr$sload(base)
        tag := _v459
        switch tag
          case 0 {_v457 := false
                  leave}
        default {_v457 := true
                 leave}
      }
      function usr$CanStore_load$storageLuint256J (l) -> _result {
        let _v460
        _v460 := usr$Typedef_rep$storageLtJ$uint256(l)
        let _v461
        _v461 := usr$StorageType_load$uint256(_v460)
        _result := _v461
        leave
      }
      function usr$CanStore_store$storageLAttendeeStatusJ (_r, _v462, _v463, _v464, _v465) {
        let _v466
        _v466 := usr$Typedef_rep$storageLtJ$AttendeeStatus(_r)
        let _v467
        let _v468
        let _v469
        let _v470
        _v467, _v468, _v469, _v470 := usr$Generic_from$AttendeeStatus(_v462, _v463, _v464, _v465)
        usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ(_v466, _v467, _v468, _v469, _v470)
      }
      function usr$CanStore_store$storageLCountersJ (_r, _v471, _v472, _v473, _v474) {
        let _v475
        _v475 := usr$Typedef_rep$storageLtJ$Counters(_r)
        let _v476
        let _v477
        let _v478
        let _v479
        _v476, _v477, _v478, _v479 := usr$Generic_from$Counters(_v471, _v472, _v473, _v474)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v475, _v476, _v477, _v478, _v479)
      }
      function usr$CanStore_store$storageLEventRecJ (_r, _v480, _v481, _v482, _v483, _v484, _v485, _v486, _v487) {
        let _v488
        _v488 := usr$Typedef_rep$storageLtJ$EventRec(_r)
        let _v489
        let _v490
        let _v491
        let _v492
        let _v493
        let _v494
        let _v495
        let _v496
        _v489, _v490, _v491, _v492, _v493, _v494, _v495, _v496 := usr$Generic_from$EventRec(_v480, _v481, _v482, _v483, _v484, _v485, _v486, _v487)
        usr$CanStore_store$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(_v488, _v489, _v490, _v491, _v492, _v493, _v494, _v495, _v496)
      }
      function usr$CanStore_store$storageLaddressJ (l, r) {
        let _v497
        _v497 := usr$Typedef_rep$storageLtJ$address(l)
        usr$StorageType_store$address(_v497, r)
        leave
      }
      function usr$CanStore_store$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ (r, _v498, _v499, _v500, _v501, _v502, _v503, _v504) {
        let base
        let _v505
        _v505 := usr$Typedef_rep$storageLtJ$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(r)
        base := _v505
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLaddressJ(base, _v498)
        let _v506
        _v506 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(_v506, _v499, _v500, _v501, _v502, _v503, _v504)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ (r, _v507, _v508, _v509, _v510, _v511, _v512) {
        let base
        let _v513
        _v513 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(r)
        base := _v513
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v507)
        let _v514
        _v514 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ(_v514, _v508, _v509, _v510, _v511, _v512)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJ (r, _v515, _v516, _v517, _v518, _v519) {
        let base
        let _v520
        _v520 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJ(r)
        base := _v520
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v515)
        let _v521
        _v521 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ(_v521, _v516, _v517, _v518, _v519)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_pairLuint256_uint256JJ (r, _v522, _v523, _v524, _v525) {
        let base
        let _v526
        _v526 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_pairLuint256_uint256JJJ(r)
        base := _v526
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v522)
        let _v527
        _v527 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_uint256J(_v527, _v523, _v524, _v525)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_pairLuint256_uint256J (r, _v528, _v529, _v530) {
        let base
        let _v531
        _v531 := usr$Typedef_rep$storageLtJ$pairLuint256_pairLuint256_uint256JJ(r)
        base := _v531
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v528)
        let _v532
        _v532 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLpairLa_bJJ$uint256_uint256(_v532, _v529, _v530)
      }
      function usr$CanStore_store$storageLpairLa_bJJ$uint256_uint256 (r, _v533, _v534) {
        let base
        let _v535
        _v535 := usr$Typedef_rep$storageLtJ$pairLuint256_uint256J(r)
        base := _v535
        let a_sz
        a_sz := 1
        usr$CanStore_store$storageLuint256J(base, _v533)
        let _v536
        _v536 := usr$Add_add$word(base, 1)
        usr$CanStore_store$storageLuint256J(_v536, _v534)
      }
      function usr$CanStore_store$storageLstringJ (dst, src) {
        let srcPtr
        let _v537
        _v537 := usr$Typedef_rep$memoryLtJ$string(src)
        srcPtr := _v537
        let slot
        let _v538
        _v538 := usr$Typedef_rep$storageLtJ$string(dst)
        slot := _v538
        usr$storeBytesFromMemory(slot, srcPtr)
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ (r, _v539, _v540, _v541, _v542, _v543, _v544, _v545, _v546) {
        let base
        let _v547
        _v547 := usr$Typedef_rep$storageLtJ$sumLunit_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJJ(r)
        base := _v547
        switch _v539
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v548
                     _v548 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLpairLa_bJJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(_v548, _v540, _v541, _v542, _v543, _v544, _v545, _v546)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_sumLunit_unitJJJ (r, _v549, _v550, _v551, _v552) {
        let base
        let _v553
        _v553 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_sumLunit_unitJJJJ(r)
        base := _v553
        switch _v549
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v554
                     _v554 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ(_v554, _v550, _v551, _v552)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_sumLunit_unitJJ (r, _v555, _v556, _v557) {
        let base
        let _v558
        _v558 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_sumLunit_unitJJJ(r)
        base := _v558
        switch _v555
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v559
                     _v559 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_unitJ(_v559, _v556, _v557)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_sumLunit_unitJ (r, _v560, _v561) {
        let base
        let _v562
        _v562 := usr$Typedef_rep$storageLtJ$sumLunit_sumLunit_unitJJ(r)
        base := _v562
        switch _v560
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)
                     let _v563
                     _v563 := usr$Add_add$word(base, 1)
                     usr$CanStore_store$storageLsumLf_gJJ$unit_unit(_v563, _v561)}
      }
      function usr$CanStore_store$storageLsumLf_gJJ$unit_unit (r, _v564) {
        let base
        let _v565
        _v565 := usr$Typedef_rep$storageLtJ$sumLunit_unitJ(r)
        base := _v565
        switch _v564
          case false {usr$sstore(base, 0)}
          case true {usr$sstore(base, 1)}
      }
      function usr$CanStore_store$storageLuint256J (l, r) {
        let _v566
        _v566 := usr$Typedef_rep$storageLtJ$uint256(l)
        usr$StorageType_store$uint256(_v566, r)
        leave
      }
      function usr$Div_div$uint256 (x, y) -> _result {
        let _v567
        _v567 := usr$Typedef_rep$uint256(x)
        let _v568
        _v568 := usr$Typedef_rep$uint256(y)
        let _v569
        _v569 := usr$Div_div$word(_v567, _v568)
        let _v570
        _v570 := usr$Typedef_abs$uint256(_v569)
        _result := _v570
        leave
      }
      function usr$Div_div$word (l, r) -> _result {
        let _v571
        _v571 := usr$div(l, r)
        _result := _v571
        leave
      }
      function usr$Eq_eq$address (x, y) -> _v572 {
        let _v573
        _v573 := usr$Typedef_rep$address(x)
        let _v574
        _v574 := usr$Typedef_rep$address(y)
        let _v575
        _v575 := usr$Eq_eq$word(_v573, _v574)
        _v572 := _v575
        leave
      }
      function usr$Eq_eq$uint256 (x, y) -> _v576 {
        let _v577
        _v577 := usr$Typedef_rep$uint256(x)
        let _v578
        _v578 := usr$Typedef_rep$uint256(y)
        let _v579
        _v579 := usr$Eq_eq$word(_v577, _v578)
        _v576 := _v579
        leave
      }
      function usr$Eq_eq$word (x, y) -> _v580 {
        let _v581
        _v581 := usr$eqWord(x, y)
        _v580 := _v581
        leave
      }
      function usr$ExecMethod_exec$FallbackLpayability_unit_unit_fnJ$Payable_t_fallback604097 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$Payable()
        usr$invokable_invoke$t_fallback604097()
        stop()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_unit_uint256_t_DUST_CLAIM_TIMEOUT593002 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_DUST_CLAIM_TIMEOUT593002()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MAX_BATCH_SIZE_unit_uint256_t_MAX_BATCH_SIZE587826 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_MAX_BATCH_SIZE587826()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_unit_uint256_t_MIN_CANCELLATION_BUFFER582668 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_MIN_CANCELLATION_BUFFER582668()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_attendees_pairLuint256_addressJ_uint256_t_attendees577523 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_addressJ_uint256_t_attendees577523()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelEvent_uint256_unit_t_cancelEvent564882 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_cancelEvent564882()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancel_uint256_unit_t_cancel572080 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_cancel572080()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelled_uint256_sumLunit_unitJ_t_cancelled558964 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_sumLunit_unitJ_t_cancelled558964()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkIn_pairLuint256_addressJ_unit_t_checkIn553620 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_addressJ_unit_t_checkIn553620()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkedInCount_uint256_uint256_t_checkedInCount536682 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_checkedInCount536682()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimDust_uint256_unit_t_claimDust524010 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_claimDust524010()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimRefund_uint256_unit_t_claimRefund517003 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_claimRefund517003()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claim_uint256_unit_t_claim531385 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_unit_t_claim531385()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimedCount_uint256_uint256_t_claimedCount509695 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_claimedCount509695()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_createEvent_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_eventCount_unit_uint256_t_eventCount498664 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_eventCount498664()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getEvent_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getState_uint256_uint256_t_getState488429 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_getState488429()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_held_uint256_uint256_t_held483049 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_held483049()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_maintainer_unit_address_t_maintainer477915 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_address_t_maintainer477915()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_metadataURI_uint256_memoryLstringJ_t_metadataURI472965 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_memoryLstringJ_t_metadataURI472965()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_organizer_uint256_address_t_organizer467391 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_address_t_organizer467391()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_registeredCount_uint256_uint256_t_registeredCount455191 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_registeredCount455191()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_rewardPerAttendee_uint256_uint256_t_rewardPerAttendee450146 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$uint256_uint256_t_rewardPerAttendee450146()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_address_unit_t_setMaintainer440130 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$address_unit_t_setMaintainer440130()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMetadataURI_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720()
      }
      function usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_totalHeld_unit_uint256_t_totalHeld429515 () {
        usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable()
        usr$do_exec$unit_uint256_t_totalHeld429515()
      }
      function usr$ExecMethod_exec$MethodLname_Payable_args_rets_fnJ$DispatchNameTy_Kodyl_register_uint256_unit_t_register462360 () {
        usr$do_exec$uint256_unit_t_register462360()
      }
      function usr$Generic_from$AttendeeStatus (_v582, _v583, _v584, _v585) -> _v586, _v587, _v588, _v589 {
        switch _v582
          case false {_v586 := false
                      leave}
          case true {switch _v583
                       case false {_v586 := true
                                   _v587 := false
                                   leave}
                       case true {switch _v584
                                    case false {_v586 := true
                                                _v587 := true
                                                _v588 := false
                                                leave}
                                    case true {switch _v585
                                                 case false {_v586 := true
                                                             _v587 := true
                                                             _v588 := true
                                                             _v589 := false
                                                             leave}
                                                 case true {_v586 := true
                                                            _v587 := true
                                                            _v588 := true
                                                            _v589 := true
                                                            leave}}}}
      }
      function usr$Generic_from$Counters (_v590, _v591, _v592, _v593) -> _v594, _v595, _v596, _v597 {
        _v594 := _v590
        _v595 := _v591
        _v596 := _v592
        _v597 := _v593
        leave
      }
      function usr$Generic_from$EventRec (_v598, _v599, _v600, _v601, _v602, _v603, _v604, _v605) -> _v606, _v607, _v608, _v609, _v610, _v611, _v612, _v613 {
        switch _v598
          case false {_v606 := false
                      leave}
          case true {_v606 := true
                     _v607 := _v599
                     _v608 := _v600
                     _v609 := _v601
                     _v610 := _v602
                     _v611 := _v603
                     _v612 := _v604
                     _v613 := _v605
                     leave}
      }
      function usr$Generic_to$AttendeeStatus (_v614, _v615, _v616, _v617) -> _v618, _v619, _v620, _v621 {
        switch _v614
          case false {_v618 := false
                      leave}
          case true {switch _v615
                       case false {_v618 := true
                                   _v619 := false
                                   leave}
                       case true {switch _v616
                                    case false {_v618 := true
                                                _v619 := true
                                                _v620 := false
                                                leave}
                                    case true {switch _v617
                                                 case false {_v618 := true
                                                             _v619 := true
                                                             _v620 := true
                                                             _v621 := false
                                                             leave}
                                                 case true {_v618 := true
                                                            _v619 := true
                                                            _v620 := true
                                                            _v621 := true
                                                            leave}}}}
      }
      function usr$Generic_to$Counters (_v622, _v623, _v624, _v625) -> _v626, _v627, _v628, _v629 {
        _v626 := _v622
        _v627 := _v623
        _v628 := _v624
        _v629 := _v625
        leave
      }
      function usr$Generic_to$EventRec (_v630, _v631, _v632, _v633, _v634, _v635, _v636, _v637) -> _v638, _v639, _v640, _v641, _v642, _v643, _v644, _v645 {
        switch _v630
          case false {_v638 := false
                      leave}
          case true {_v638 := true
                     _v639 := _v631
                     _v640 := _v632
                     _v641 := _v633
                     _v642 := _v634
                     _v643 := _v635
                     _v644 := _v636
                     _v645 := _v637
                     leave}
      }
      function usr$HasWordReader_getWordReader$calldataLbytesJ (x) -> _result {
        let _v646
        _v646 := usr$Typedef_rep$calldataLtJ$bytes(x)
        _result := _v646
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256 (_v647, _v648) -> _result {
        let slot
        let _v649
        _v649 := usr$Typedef_rep$storageLtJ$arrayLstringJ(_v647)
        slot := _v649
        let idx
        let _v650
        _v650 := usr$Typedef_rep$uint256(_v648)
        idx := _v650
        let _v651
        let _v652
        _v652 := usr$sload(slot)
        let _v653
        _v653 := usr$ge$word(idx, _v652)
        _v651 := _v653
        switch _v651
          case false {}
          case true {usr$out_of_bounds()}
        let _v654
        _v654 := usr$hash1(slot)
        let _v655
        _v655 := usr$Add_add$word(_v654, idx)
        _result := _v655
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus (_v656, _v657) -> _result {
        let _v658
        _v658 := usr$Typedef_rep$storageLtJ$mappingLaddress_AttendeeStatusJ(_v656)
        let _v659
        _v659 := usr$Typedef_rep$address(_v657)
        let _v660
        _v660 := usr$hash2(_v658, _v659)
        _result := _v660
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters (_v661, _v662) -> _result {
        let _v663
        _v663 := usr$Typedef_rep$storageLtJ$mappingLuint256_CountersJ(_v661)
        let _v664
        _v664 := usr$Typedef_rep$uint256(_v662)
        let _v665
        _v665 := usr$hash2(_v663, _v664)
        _result := _v665
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec (_v666, _v667) -> _result {
        let _v668
        _v668 := usr$Typedef_rep$storageLtJ$mappingLuint256_EventRecJ(_v666)
        let _v669
        _v669 := usr$Typedef_rep$uint256(_v667)
        let _v670
        _v670 := usr$hash2(_v668, _v669)
        _result := _v670
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_mappingLaddress_AttendeeStatusJ (_v671, _v672) -> _result {
        let _v673
        _v673 := usr$Typedef_rep$storageLtJ$mappingLuint256_mappingLaddress_AttendeeStatusJJ(_v671)
        let _v674
        _v674 := usr$Typedef_rep$uint256(_v672)
        let _v675
        _v675 := usr$hash2(_v673, _v674)
        _result := _v675
        leave
      }
      function usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ (_v676, _v677) -> _result {
        let _v678
        _v678 := usr$Typedef_rep$storageLtJ$mappingLuint256_sumLunit_unitJJ(_v676)
        let _v679
        _v679 := usr$Typedef_rep$uint256(_v677)
        let _v680
        _v680 := usr$hash2(_v678, _v679)
        _result := _v680
        leave
      }
      function usr$MethodLevelCallvalueCheck_checkCallvalue$NonPayable () {
        let _v681
        let _v682
        let _v683
        _v681 := false
        _v682 := 3046674083
        let _v684
        _v684 := usr$callvalue()
        let _v685
        _v685 := usr$Eq_eq$word(_v684, 0)
        usr$require(_v685, false, 3046674083, 911)
      }
      function usr$MethodLevelCallvalueCheck_checkCallvalue$Payable () {
      }
      function usr$Mul_mul$uint256 (x, y) -> _result {
        let _v686
        _v686 := usr$Typedef_rep$uint256(x)
        let _v687
        _v687 := usr$Typedef_rep$uint256(y)
        let _v688
        _v688 := usr$Mul_mul$word(_v686, _v687)
        let _v689
        _v689 := usr$Typedef_abs$uint256(_v688)
        _result := _v689
        leave
      }
      function usr$Mul_mul$word (l, r) -> _result {
        let _v690
        _v690 := usr$mulWord(l, r)
        _result := _v690
        leave
      }
      function usr$Ord_gt$uint256 (x, y) -> _v691 {
        let _v692
        _v692 := usr$Typedef_rep$uint256(x)
        let _v693
        _v693 := usr$Typedef_rep$uint256(y)
        let _v694
        _v694 := usr$Ord_gt$word(_v692, _v693)
        _v691 := _v694
        leave
      }
      function usr$Ord_gt$word (x, y) -> _v695 {
        let _v696
        _v696 := usr$gtWord(x, y)
        _v695 := _v696
        leave
      }
      function usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_eventCount_sel_uint256_pairLaddress_unitJ () -> _result {
        let offset
        offset := 1
        let _v697
        _v697 := usr$CanStore_load$storageLuint256J(1)
        _result := _v697
        leave
      }
      function usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit () -> _result {
        let offset
        offset := 0
        let _v698
        _v698 := usr$CanStore_load$storageLaddressJ(0)
        _result := _v698
        leave
      }
      function usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ () -> _result {
        let offset
        offset := 2
        let _v699
        _v699 := usr$CanStore_load$storageLuint256J(2)
        _result := _v699
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256_memoryLstringJ (_v700, _v701) -> _result {
        let _v702
        _v702 := usr$LValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256(_v700, _v701)
        let _v703
        _v703 := usr$CanStore_load$storageLstringJ(_v702)
        _result := _v703
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus (_v704, _v705) -> _v706, _v707, _v708, _v709 {
        let _v710
        _v710 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus(_v704, _v705)
        let _v711
        let _v712
        let _v713
        let _v714
        _v711, _v712, _v713, _v714 := usr$readStorage$AttendeeStatus(_v710)
        _v706 := _v711
        _v707 := _v712
        _v708 := _v713
        _v709 := _v714
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters (_v715, _v716) -> _v717, _v718, _v719, _v720 {
        let _v721
        _v721 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters(_v715, _v716)
        let _v722
        let _v723
        let _v724
        let _v725
        _v722, _v723, _v724, _v725 := usr$readStorage$Counters(_v721)
        _v717 := _v722
        _v718 := _v723
        _v719 := _v724
        _v720 := _v725
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec (_v726, _v727) -> _v728, _v729, _v730, _v731, _v732, _v733, _v734, _v735 {
        let _v736
        _v736 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec(_v726, _v727)
        let _v737
        let _v738
        let _v739
        let _v740
        let _v741
        let _v742
        let _v743
        let _v744
        _v737, _v738, _v739, _v740, _v741, _v742, _v743, _v744 := usr$readStorage$EventRec(_v736)
        _v728 := _v737
        _v729 := _v738
        _v730 := _v739
        _v731 := _v740
        _v732 := _v741
        _v733 := _v742
        _v734 := _v743
        _v735 := _v744
        leave
      }
      function usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ (_v745, _v746) -> _v747 {
        let _v748
        _v748 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ(_v745, _v746)
        let _v749
        _v749 := usr$readStorage$sumLunit_unitJ(_v748)
        _v747 := _v749
        leave
      }
      function usr$RunContract_exec$ContractLmethods_fbJ$pairLMethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJJJJ_FallbackLPayable_unit_unit_t_fallback604097J () {
        mstore(64, memoryguard(128))
        let _v750
        let _v751
        _v751 := usr$calldatasize()
        let _v752
        _v752 := usr$ge$word(_v751, 4)
        _v750 := _v752
        switch _v750
          case false {}
          case true {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJJJ()}
        usr$ExecMethod_exec$FallbackLpayability_unit_unit_fnJ$Payable_t_fallback604097()
      }
      function usr$RunDispatch_go$MethodLname_payability_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130 () {
        let _v753
        let _v754
        _v754 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130J()
        _v753 := _v754
        switch _v753
          case false {leave}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_address_unit_t_setMaintainer440130()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJ () {
        let _v755
        let _v756
        _v756 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J()
        _v755 := _v756
        switch _v755
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_unit_uint256_t_DUST_CLAIM_TIMEOUT593002()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJ () {
        let _v757
        let _v758
        _v758 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J()
        _v757 := _v758
        switch _v757
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MAX_BATCH_SIZE_unit_uint256_t_MAX_BATCH_SIZE587826()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJ () {
        let _v759
        let _v760
        _v760 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J()
        _v759 := _v760
        switch _v759
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_unit_uint256_t_MIN_CANCELLATION_BUFFER582668()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJ () {
        let _v761
        let _v762
        _v762 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J()
        _v761 := _v762
        switch _v761
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_attendees_pairLuint256_addressJ_uint256_t_attendees577523()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJ () {
        let _v763
        let _v764
        _v764 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J()
        _v763 := _v764
        switch _v763
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelEvent_uint256_unit_t_cancelEvent564882()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJ () {
        let _v765
        let _v766
        _v766 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J()
        _v765 := _v766
        switch _v765
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancel_uint256_unit_t_cancel572080()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJ () {
        let _v767
        let _v768
        _v768 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J()
        _v767 := _v768
        switch _v767
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_cancelled_uint256_sumLunit_unitJ_t_cancelled558964()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJ () {
        let _v769
        let _v770
        _v770 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J()
        _v769 := _v770
        switch _v769
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkIn_pairLuint256_addressJ_unit_t_checkIn553620()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJ () {
        let _v771
        let _v772
        _v772 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J()
        _v771 := _v772
        switch _v771
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_checkedInCount_uint256_uint256_t_checkedInCount536682()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130J () {
        let _v773
        let _v774
        _v774 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J()
        _v773 := _v774
        switch _v773
          case false {usr$RunDispatch_go$MethodLname_payability_args_rets_fnJ$DispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimDust_uint256_unit_t_claimDust524010()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJ () {
        let _v775
        let _v776
        _v776 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J()
        _v775 := _v776
        switch _v775
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimRefund_uint256_unit_t_claimRefund517003()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJ () {
        let _v777
        let _v778
        _v778 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J()
        _v777 := _v778
        switch _v777
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claim_uint256_unit_t_claim531385()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJ () {
        let _v779
        let _v780
        _v780 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J()
        _v779 := _v780
        switch _v779
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_claimedCount_uint256_uint256_t_claimedCount509695()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v781
        let _v782
        _v782 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446J()
        _v781 := _v782
        switch _v781
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_createEvent_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v783
        let _v784
        _v784 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J()
        _v783 := _v784
        switch _v783
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_eventCount_unit_uint256_t_eventCount498664()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJ () {
        let _v785
        let _v786
        _v786 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J()
        _v785 := _v786
        switch _v785
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getEvent_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJ () {
        let _v787
        let _v788
        _v788 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J()
        _v787 := _v788
        switch _v787
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_getState_uint256_uint256_t_getState488429()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJ () {
        let _v789
        let _v790
        _v790 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J()
        _v789 := _v790
        switch _v789
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_held_uint256_uint256_t_held483049()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v791
        let _v792
        _v792 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J()
        _v791 := _v792
        switch _v791
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_maintainer_unit_address_t_maintainer477915()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJ () {
        let _v793
        let _v794
        _v794 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J()
        _v793 := _v794
        switch _v793
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_metadataURI_uint256_memoryLstringJ_t_metadataURI472965()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJ () {
        let _v795
        let _v796
        _v796 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J()
        _v795 := _v796
        switch _v795
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_organizer_uint256_address_t_organizer467391()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJ () {
        let _v797
        let _v798
        _v798 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J()
        _v797 := _v798
        switch _v797
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_Payable_args_rets_fnJ$DispatchNameTy_Kodyl_register_uint256_unit_t_register462360()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJ () {
        let _v799
        let _v800
        _v800 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J()
        _v799 := _v800
        switch _v799
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_registeredCount_uint256_uint256_t_registeredCount455191()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJ () {
        let _v801
        let _v802
        _v802 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J()
        _v801 := _v802
        switch _v801
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_rewardPerAttendee_uint256_uint256_t_rewardPerAttendee450146()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJ () {
        let _v803
        let _v804
        _v804 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J()
        _v803 := _v804
        switch _v803
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130J()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_setMetadataURI_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720()}
      }
      function usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJ () {
        let _v805
        let _v806
        _v806 := usr$selector_matches$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J()
        _v805 := _v806
        switch _v805
          case false {usr$RunDispatch_go$pairLn_mJ$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJ()}
          case true {usr$ExecMethod_exec$MethodLname_NonPayable_args_rets_fnJ$DispatchNameTy_Kodyl_totalHeld_unit_uint256_t_totalHeld429515()}
      }
      function usr$StorageType_load$address (ptr) -> _result {
        let _v807
        _v807 := usr$StorageType_load$word(ptr)
        _result := _v807
        leave
      }
      function usr$StorageType_load$uint256 (ptr) -> _result {
        let _v808
        _v808 := usr$StorageType_load$word(ptr)
        _result := _v808
        leave
      }
      function usr$StorageType_load$word (ptr) -> _result {
        let _v809
        _v809 := usr$sload(ptr)
        _result := _v809
        leave
      }
      function usr$StorageType_store$address (ptr, value) {
        let _v810
        _v810 := usr$Typedef_rep$address(value)
        usr$StorageType_store$word(ptr, _v810)
        leave
      }
      function usr$StorageType_store$uint256 (ptr, value) {
        let _v811
        _v811 := usr$Typedef_rep$uint256(value)
        usr$StorageType_store$word(ptr, _v811)
        leave
      }
      function usr$StorageType_store$word (ptr, value) {
        usr$sstore(ptr, value)
        leave
      }
      function usr$Sub_sub$uint256 (x, y) -> _result {
        let _v812
        _v812 := usr$Typedef_rep$uint256(x)
        let _v813
        _v813 := usr$Typedef_rep$uint256(y)
        let _v814
        _v814 := usr$Sub_sub$word(_v812, _v813)
        let _v815
        _v815 := usr$Typedef_abs$uint256(_v814)
        _result := _v815
        leave
      }
      function usr$Sub_sub$word (l, r) -> _result {
        let _v816
        _v816 := usr$subWord(l, r)
        _result := _v816
        leave
      }
      function usr$Typedef_abs$address (x) -> _result {
        _result := x
        leave
      }
      function usr$Typedef_abs$uint256 (w) -> _result {
        _result := w
        leave
      }
      function usr$Typedef_rep$address (x) -> _result {
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
        let _v817
        _v817 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v817
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader (decoder, offset) -> _result {
        let _v818
        _v818 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v818
        leave
      }
      function usr$WordReader_advance$ABIDecoderLty_readerJ$uint256_CalldataWordReader (decoder, offset) -> _result {
        let _v819
        _v819 := usr$WordReader_advance$CalldataWordReader(decoder, offset)
        _result := _v819
        leave
      }
      function usr$WordReader_advance$CalldataWordReader (reader, offset) -> _result {
        let _v820
        _v820 := usr$Add_add$word(reader, offset)
        _result := _v820
        leave
      }
      function usr$WordReader_copyToMem$CalldataWordReader (reader, dst, cnt) {
        usr$calldatacopy(dst, reader, cnt)
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$address_CalldataWordReader (decoder) -> _result {
        let _v821
        _v821 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v821
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader (decoder) -> _result {
        let _v822
        _v822 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v822
        leave
      }
      function usr$WordReader_read$ABIDecoderLty_readerJ$uint256_CalldataWordReader (decoder) -> _result {
        let _v823
        _v823 := usr$WordReader_read$CalldataWordReader(decoder)
        _result := _v823
        leave
      }
      function usr$WordReader_read$CalldataWordReader (reader) -> _result {
        let _v824
        _v824 := usr$calldataload(reader)
        _result := _v824
        leave
      }
      function usr$abi_decode$calldataLbytesJ_address_CalldataWordReader_address (decodable) -> _result {
        let _v825
        let _v826
        _v826 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v825 := _v826
        let _v827
        _v827 := usr$ABIDecode_decode$ABIDecoderLaddress_readerJ$CalldataWordReader(_v825, 0)
        _result := _v827
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ (decodable) -> _v828, _v829 {
        let _v830
        let _v831
        _v831 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v830 := _v831
        let _v832
        let _v833
        _v832, _v833 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_address_CalldataWordReader_uint256_address(_v830, 0)
        _v828 := _v832
        _v829 := _v833
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_memoryLstringJJ_CalldataWordReader_pairLuint256_memoryLstringJJ (decodable) -> _v834, _v835 {
        let _v836
        let _v837
        _v837 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v836 := _v837
        let _v838
        let _v839
        _v838, _v839 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_memoryLstringJ_CalldataWordReader_uint256_memoryLstringJ(_v836, 0)
        _v834 := _v838
        _v835 := _v839
        leave
      }
      function usr$abi_decode$calldataLbytesJ_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_CalldataWordReader_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ (decodable) -> _v840, _v841, _v842, _v843, _v844, _v845, _v846 {
        let _v847
        let _v848
        _v848 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v847 := _v848
        let _v849
        let _v850
        let _v851
        let _v852
        let _v853
        let _v854
        let _v855
        _v849, _v850, _v851, _v852, _v853, _v854, _v855 := usr$ABIDecode_decode$ABIDecoderLpairLa_bJ_readerJ$uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ_CalldataWordReader_uint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJ(_v847, 0)
        _v840 := _v849
        _v841 := _v850
        _v842 := _v851
        _v843 := _v852
        _v844 := _v853
        _v845 := _v854
        _v846 := _v855
        leave
      }
      function usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256 (decodable) -> _result {
        let _v856
        let _v857
        _v857 := usr$HasWordReader_getWordReader$calldataLbytesJ(decodable)
        _v856 := _v857
        let _v858
        _v858 := usr$ABIDecode_decode$ABIDecoderLuint256_readerJ$CalldataWordReader(_v856, 0)
        _result := _v858
        leave
      }
      function usr$abi_encode$address (val) -> _result {
        let free
        let _v859
        _v859 := usr$get_free_memory()
        free := _v859
        let tail
        let _v860
        _v860 := usr$Add_add$word(free, 32)
        let _v861
        _v861 := usr$ABIEncode_encodeInto$address(val, free, 0, _v860)
        tail := _v861
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$memoryLstringJ (val) -> _result {
        let free
        let _v862
        _v862 := usr$get_free_memory()
        free := _v862
        let tail
        let _v863
        _v863 := usr$Add_add$word(free, 32)
        let _v864
        _v864 := usr$ABIEncode_encodeInto$memoryLstringJ(val, free, 0, _v863)
        tail := _v864
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ (_v865, _v866, _v867, _v868, _v869, _v870, _v871) -> _result {
        let free
        let _v872
        _v872 := usr$get_free_memory()
        free := _v872
        let tail
        let _v873
        _v873 := usr$Add_add$word(free, 224)
        let _v874
        _v874 := usr$ABIEncode_encodeInto$pairLa_bJ$address_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJ(_v865, _v866, _v867, _v868, _v869, _v870, _v871, free, 0, _v873)
        tail := _v874
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$sumLunit_unitJ (_v875) -> _result {
        let free
        let _v876
        _v876 := usr$get_free_memory()
        free := _v876
        let tail
        let _v877
        _v877 := usr$Add_add$word(free, 32)
        let _v878
        _v878 := usr$ABIEncode_encodeInto$sumLunit_unitJ(_v875, free, 0, _v877)
        tail := _v878
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$uint256 (val) -> _result {
        let free
        let _v879
        _v879 := usr$get_free_memory()
        free := _v879
        let tail
        let _v880
        _v880 := usr$Add_add$word(free, 32)
        let _v881
        _v881 := usr$ABIEncode_encodeInto$uint256(val, free, 0, _v880)
        tail := _v881
        usr$set_free_memory(tail)
        _result := free
        leave
      }
      function usr$abi_encode$unit () -> _result {
        let free
        let _v882
        _v882 := usr$get_free_memory()
        free := _v882
        let tail
        let _v883
        _v883 := usr$Add_add$word(free, 0)
        let _v884
        _v884 := usr$ABIEncode_encodeInto$unit(free, 0, _v883)
        tail := _v884
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
        let _v885
        let _v886
        _v886 := usr$Add_add$uint256(x, y)
        _v885 := _v886
        let _v887
        let _v888
        _v888 := usr$lt$uint256(_v885, x)
        _v887 := _v888
        switch _v887
          case false {}
          case true {usr$panic(17)}
        _result := _v885
        leave
      }
      function usr$addWord (l, r) -> _result {
        let _v889
        _v889 := usr$add(l, r)
        _result := _v889
        leave
      }
      function usr$allocate_memory (size) -> _result {
        let ptr
        let _v890
        _v890 := usr$get_free_memory()
        ptr := _v890
        let _v891
        _v891 := usr$Add_add$word(ptr, size)
        usr$set_free_memory(_v891)
        _result := ptr
        leave
      }
      function usr$and (_v892, _v893) -> _v894 {
        switch _v892
          case false {_v894 := false
                      leave}
          case true {_v894 := _v893
                     leave}
      }
      function usr$and_ (a, b) -> _result {
        let res
        res := and(a, b)
        _result := res
        leave
      }
      function usr$attendees (eid, a) -> _result {
        let _v895
        _v895 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
        let _v896
        let _v897
        let _v898
        let _v899
        _v896, _v897, _v898, _v899 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v895, a)
        let _v900
        _v900 := usr$statusOrd(_v896, _v897, _v898, _v899)
        _result := _v900
        leave
      }
      function usr$balanceSelf () -> _result {
        let _v901
        _v901 := usr$selfbalance()
        _result := _v901
        leave
      }
      function usr$bumpCheckedIn (eid, n) {
        let _v902
        let _v903
        _v903 := usr$Eq_eq$uint256(n, 0)
        _v902 := _v903
        switch _v902
          case false {}
          case true {leave}
        let _v904
        let _v905
        let _v906
        let _v907
        let _v908
        let _v909
        let _v910
        let _v911
        _v908, _v909, _v910, _v911 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v904 := _v908
        _v905 := _v909
        _v906 := _v910
        _v907 := _v911
        let _v912
        _v912 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
        let _v913
        _v913 := usr$Add_add$uint256(_v905, n)
        usr$Assign_assign$a$storageLCountersJ_Counters(_v912, _v904, _v913, _v906, _v907)
      }
      function usr$calcReward (reg, chk, dep) -> _result {
        let _v914
        let _v915
        _v915 := usr$Eq_eq$uint256(chk, 0)
        _v914 := _v915
        switch _v914
          case false {}
          case true {_result := 0
                     leave}
        let _v916
        let _v917
        _v917 := usr$subCk(reg, chk)
        _v916 := _v917
        let _v918
        _v918 := usr$mulCk(_v916, dep)
        let _v919
        _v919 := usr$Div_div$uint256(_v918, chk)
        _result := _v919
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
        let _v920
        _v920 := usr$caller_()
        _result := _v920
        leave
      }
      function usr$caller_ () -> _result {
        let res
        res := caller()
        _result := res
        leave
      }
      function usr$caller_value () -> _result {
        let _v921
        _v921 := usr$callvalue_()
        _result := _v921
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
        let _v922
        let _v923
        let _v924
        let _v925
        let _v926
        let _v927
        let _v928
        let _v929
        let _v930
        let _v931
        let _v932
        let _v933
        let _v934
        let _v935
        let _v936
        let _v937
        _v930, _v931, _v932, _v933, _v934, _v935, _v936, _v937 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v922 := _v930
        _v923 := _v931
        _v924 := _v932
        _v925 := _v933
        _v926 := _v934
        _v927 := _v935
        _v928 := _v936
        _v929 := _v937
        switch _v922
          case false {usr$revertNotFound()}
          case true {let _v938
                     _v938 := usr$timeNow()
                     let _v939
                     _v939 := usr$le$uint256(_v938, _v925)
                     usr$requireK(_v939, 1320495838)
                     let _v940
                     _v940 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v941
                     _v941 := usr$caller()
                     let _v942
                     let _v943
                     let _v944
                     let _v945
                     _v942, _v943, _v944, _v945 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v940, _v941)
                     usr$requireStatus(_v942, _v943, _v944, _v945, 1)
                     let _v946
                     _v946 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v947
                     _v947 := usr$caller()
                     let _v948
                     _v948 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v946, _v947)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v948, true, true, false, 911)
                     let _v949
                     let _v950
                     let _v951
                     let _v952
                     let _v953
                     let _v954
                     let _v955
                     let _v956
                     _v953, _v954, _v955, _v956 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v949 := _v953
                     _v950 := _v954
                     _v951 := _v955
                     _v952 := _v956
                     let _v957
                     _v957 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v958
                     _v958 := usr$Sub_sub$uint256(_v949, 1)
                     let _v959
                     _v959 := usr$subCk(_v952, _v924)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v957, _v958, _v950, _v951, _v959)
                     let _v960
                     _v960 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v961
                     _v961 := usr$subCk(_v960, _v924)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v961)
                     let _v962
                     _v962 := usr$caller()
                     usr$sendValue(_v962, _v924)
                     let _v963
                     _v963 := usr$balanceSelf()
                     let _v964
                     _v964 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v965
                     _v965 := usr$ge$uint256(_v963, _v964)
                     usr$solAssert(_v965)
                     let _v966
                     _v966 := usr$Typedef_rep$uint256(eid)
                     let _v967
                     _v967 := usr$caller()
                     let _v968
                     _v968 := usr$Typedef_rep$address(_v967)
                     usr$emitLog3(49258998252148748962151988473322413374541890325925337282821714030898856777338, _v966, _v968)}
      }
      function usr$cancelEvent (eid) {
        let _v969
        let _v970
        let _v971
        let _v972
        let _v973
        let _v974
        let _v975
        let _v976
        let _v977
        let _v978
        let _v979
        let _v980
        let _v981
        let _v982
        let _v983
        let _v984
        _v977, _v978, _v979, _v980, _v981, _v982, _v983, _v984 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v969 := _v977
        _v970 := _v978
        _v971 := _v979
        _v972 := _v980
        _v973 := _v981
        _v974 := _v982
        _v975 := _v983
        _v976 := _v984
        switch _v969
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v970)
                     let _v985
                     _v985 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v986
                     let _v987
                     let _v988
                     let _v989
                     _v986, _v987, _v988, _v989 := usr$deriveState(_v985, _v973, _v974, _v975)
                     let _v990
                     _v990 := usr$stateOrd(_v986, _v987, _v988, _v989)
                     let _v991
                     _v991 := usr$Eq_eq$uint256(_v990, 0)
                     usr$requireK(_v991, 2829790501)
                     let _v992
                     _v992 := usr$lidx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_storageLsumLunit_unitJJ(5, eid)
                     usr$Assign_assign$a$storageLsumLunit_unitJJ_sumLunit_unitJ(_v992, true)
                     let _v993
                     _v993 := usr$Typedef_rep$uint256(eid)
                     usr$emitLog2(99616089577665513926284212068781508364134431091285324813305771500819559365945, _v993)}
      }
      function usr$cancelled (eid) -> _v994 {
        let _v995
        _v995 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
        _v994 := _v995
        leave
      }
      function usr$checkIn (eid, a) {
        let _v996
        let _v997
        let _v998
        let _v999
        let _v1000
        let _v1001
        let _v1002
        let _v1003
        let _v1004
        let _v1005
        let _v1006
        let _v1007
        let _v1008
        let _v1009
        let _v1010
        let _v1011
        _v1004, _v1005, _v1006, _v1007, _v1008, _v1009, _v1010, _v1011 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v996 := _v1004
        _v997 := _v1005
        _v998 := _v1006
        _v999 := _v1007
        _v1000 := _v1008
        _v1001 := _v1009
        _v1002 := _v1010
        _v1003 := _v1011
        switch _v996
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v997)
                     let _v1012
                     _v1012 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     usr$requireCheckInOpen(_v1012, _v1000, _v1001, _v1002)
                     let _v1013
                     _v1013 := usr$checkInInner(eid, a)
                     usr$bumpCheckedIn(eid, _v1013)}
      }
      function usr$checkInBatchImpl () {
        let _v1014
        let _v1015
        _v1015 := usr$calldataload(4)
        _v1014 := _v1015
        let _v1016
        let _v1017
        let _v1018
        let _v1019
        let _v1020
        let _v1021
        let _v1022
        let _v1023
        let _v1024
        let _v1025
        let _v1026
        let _v1027
        let _v1028
        let _v1029
        let _v1030
        let _v1031
        _v1024, _v1025, _v1026, _v1027, _v1028, _v1029, _v1030, _v1031 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, _v1014)
        _v1016 := _v1024
        _v1017 := _v1025
        _v1018 := _v1026
        _v1019 := _v1027
        _v1020 := _v1028
        _v1021 := _v1029
        _v1022 := _v1030
        _v1023 := _v1031
        switch _v1016
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v1017)
                     let _v1032
                     _v1032 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, _v1014)
                     usr$requireCheckInOpen(_v1032, _v1020, _v1021, _v1022)
                     let lenPtr
                     let _v1033
                     _v1033 := usr$calldataload(36)
                     let _v1034
                     _v1034 := usr$Add_add$word(4, _v1033)
                     lenPtr := _v1034
                     let len
                     let _v1035
                     _v1035 := usr$calldataload(lenPtr)
                     len := _v1035
                     let maxB
                     maxB := 100
                     let _v1036
                     let _v1037
                     _v1037 := usr$Ord_gt$word(len, 100)
                     _v1036 := _v1037
                     switch _v1036
                       case false {}
                       case true {usr$revertWith2(3139221259, len, 100)}
                     let _v1038
                     _v1038 := 0
                     for {let i i := 0 let _v1039 let _v1040 _v1039 := usr$lt$word(i, len)} _v1039 {_v1040 := usr$Add_add$word(i, 1) i := _v1040 _v1039 := usr$lt$word(i, len)}
                     {let w
                      let _v1041
                      _v1041 := usr$Add_add$word(lenPtr, 32)
                      let _v1042
                      _v1042 := usr$Mul_mul$word(i, 32)
                      let _v1043
                      _v1043 := usr$Add_add$word(_v1041, _v1042)
                      let _v1044
                      _v1044 := usr$calldataload(_v1043)
                      w := _v1044
                      let _v1045
                      _v1045 := usr$shr(160, w)
                      let _v1046
                      _v1046 := usr$Eq_eq$word(_v1045, 0)
                      usr$requireK(_v1046, 2092978087)
                      let _v1047
                      _v1047 := usr$checkInInner(_v1014, w)
                      let _v1048
                      _v1048 := usr$Add_add$uint256(_v1038, _v1047)
                      _v1038 := _v1048}
                     usr$bumpCheckedIn(_v1014, _v1038)}
      }
      function usr$checkInInner (eid, a) -> _result {
        let _v1049
        let _v1050
        _v1050 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
        let _v1051
        let _v1052
        let _v1053
        let _v1054
        _v1051, _v1052, _v1053, _v1054 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1050, a)
        let _v1055
        _v1055 := usr$statusOrd(_v1051, _v1052, _v1053, _v1054)
        let _v1056
        _v1056 := usr$Eq_eq$uint256(_v1055, 1)
        _v1049 := _v1056
        switch _v1049
          case false {}
          case true {let _v1057
                     _v1057 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1058
                     _v1058 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1057, a)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1058, true, true, true, false)
                     let _v1059
                     _v1059 := usr$Typedef_rep$uint256(eid)
                     let _v1060
                     _v1060 := usr$Typedef_rep$address(a)
                     usr$emitLog3(50872910645629032543601523280981675582310894594853385402616470856132378936092, _v1059, _v1060)
                     _result := 1
                     leave}
        _result := 0
        leave
      }
      function usr$checkedInCount (eid) -> _result {
        let _v1061
        let _v1062
        let _v1063
        let _v1064
        let _v1065
        let _v1066
        let _v1067
        let _v1068
        _v1065, _v1066, _v1067, _v1068 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v1061 := _v1065
        _v1062 := _v1066
        _v1063 := _v1067
        _v1064 := _v1068
        _result := _v1062
        leave
      }
      function usr$claim (eid) {
        let _v1069
        let _v1070
        let _v1071
        let _v1072
        let _v1073
        let _v1074
        let _v1075
        let _v1076
        let _v1077
        let _v1078
        let _v1079
        let _v1080
        let _v1081
        let _v1082
        let _v1083
        let _v1084
        _v1077, _v1078, _v1079, _v1080, _v1081, _v1082, _v1083, _v1084 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1069 := _v1077
        _v1070 := _v1078
        _v1071 := _v1079
        _v1072 := _v1080
        _v1073 := _v1081
        _v1074 := _v1082
        _v1075 := _v1083
        _v1076 := _v1084
        switch _v1069
          case false {usr$revertNotFound()}
          case true {let _v1085
                     _v1085 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v1086
                     let _v1087
                     let _v1088
                     let _v1089
                     _v1086, _v1087, _v1088, _v1089 := usr$deriveState(_v1085, _v1073, _v1074, _v1075)
                     let _v1090
                     _v1090 := usr$stateOrd(_v1086, _v1087, _v1088, _v1089)
                     let _v1091
                     _v1091 := usr$Eq_eq$uint256(_v1090, 3)
                     usr$requireK(_v1091, 3123878555)
                     let _v1092
                     _v1092 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1093
                     _v1093 := usr$caller()
                     let _v1094
                     let _v1095
                     let _v1096
                     let _v1097
                     _v1094, _v1095, _v1096, _v1097 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1092, _v1093)
                     usr$requireStatus(_v1094, _v1095, _v1096, _v1097, 3)
                     let _v1098
                     _v1098 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1099
                     _v1099 := usr$caller()
                     let _v1100
                     _v1100 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1098, _v1099)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1100, true, true, true, true)
                     let _v1101
                     let _v1102
                     let _v1103
                     let _v1104
                     let _v1105
                     let _v1106
                     let _v1107
                     let _v1108
                     _v1105, _v1106, _v1107, _v1108 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1101 := _v1105
                     _v1102 := _v1106
                     _v1103 := _v1107
                     _v1104 := _v1108
                     let _v1109
                     let _v1110
                     _v1110 := usr$calcReward(_v1101, _v1102, _v1071)
                     let _v1111
                     _v1111 := usr$addCk(_v1071, _v1110)
                     _v1109 := _v1111
                     let _v1112
                     _v1112 := usr$le$uint256(_v1109, _v1104)
                     usr$requireK(_v1112, 3276456545)
                     let _v1113
                     _v1113 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v1114
                     _v1114 := usr$Add_add$uint256(_v1103, 1)
                     let _v1115
                     _v1115 := usr$subCk(_v1104, _v1109)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1113, _v1101, _v1102, _v1114, _v1115)
                     let _v1116
                     _v1116 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1117
                     _v1117 := usr$subCk(_v1116, _v1109)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1117)
                     let _v1118
                     _v1118 := usr$caller()
                     usr$sendValue(_v1118, _v1109)
                     let _v1119
                     _v1119 := usr$balanceSelf()
                     let _v1120
                     _v1120 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1121
                     _v1121 := usr$ge$uint256(_v1119, _v1120)
                     usr$solAssert(_v1121)
                     let _v1122
                     _v1122 := usr$Typedef_rep$uint256(eid)
                     let _v1123
                     _v1123 := usr$caller()
                     let _v1124
                     _v1124 := usr$Typedef_rep$address(_v1123)
                     let _v1125
                     _v1125 := usr$Typedef_rep$uint256(_v1109)
                     usr$emitLog3W1(35635639126918266826417363157745207966733923402123826568285639076591142096934, _v1122, _v1124, _v1125)}
      }
      function usr$claimDust (eid) {
        let _v1126
        let _v1127
        let _v1128
        let _v1129
        let _v1130
        let _v1131
        let _v1132
        let _v1133
        let _v1134
        let _v1135
        let _v1136
        let _v1137
        let _v1138
        let _v1139
        let _v1140
        let _v1141
        _v1134, _v1135, _v1136, _v1137, _v1138, _v1139, _v1140, _v1141 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1126 := _v1134
        _v1127 := _v1135
        _v1128 := _v1136
        _v1129 := _v1137
        _v1130 := _v1138
        _v1131 := _v1139
        _v1132 := _v1140
        _v1133 := _v1141
        switch _v1126
          case false {usr$revertNotFound()}
          case true {let _v1142
                     _v1142 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v1143
                     let _v1144
                     let _v1145
                     let _v1146
                     _v1143, _v1144, _v1145, _v1146 := usr$deriveState(_v1142, _v1130, _v1131, _v1132)
                     let _v1147
                     _v1147 := usr$stateOrd(_v1143, _v1144, _v1145, _v1146)
                     let _v1148
                     _v1148 := usr$Eq_eq$uint256(_v1147, 3)
                     usr$requireK(_v1148, 3123878555)
                     let _v1149
                     let _v1150
                     let _v1151
                     let _v1152
                     let _v1153
                     let _v1154
                     let _v1155
                     let _v1156
                     _v1153, _v1154, _v1155, _v1156 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1149 := _v1153
                     _v1150 := _v1154
                     _v1151 := _v1155
                     _v1152 := _v1156
                     let _v1157
                     let _v1158
                     _v1158 := usr$Eq_eq$uint256(_v1151, _v1150)
                     _v1157 := _v1158
                     let _v1159
                     let _v1160
                     _v1160 := usr$timeNow()
                     let _v1161
                     _v1161 := usr$addCk(_v1131, _v1132)
                     let _v1162
                     _v1162 := usr$addCk(_v1161, 2592000)
                     let _v1163
                     _v1163 := usr$Ord_gt$uint256(_v1160, _v1162)
                     _v1159 := _v1163
                     let _v1164
                     let _v1165
                     _v1165 := usr$not(_v1157)
                     let _v1166
                     _v1166 := usr$not(_v1159)
                     let _v1167
                     _v1167 := usr$and(_v1165, _v1166)
                     _v1164 := _v1167
                     switch _v1164
                       case false {}
                       case true {usr$fail(3985512035)}
                     let _v1168
                     _v1168 := _v1152
                     let _v1169
                     _v1169 := usr$ne$uint256(_v1168, 0)
                     usr$requireK(_v1169, 3985512035)
                     let _v1170
                     _v1170 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1170, _v1149, _v1150, _v1151, 0)
                     let _v1171
                     _v1171 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1172
                     _v1172 := usr$subCk(_v1171, _v1168)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1172)
                     let _v1173
                     _v1173 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
                     usr$sendValue(_v1173, _v1168)
                     let _v1174
                     _v1174 := usr$balanceSelf()
                     let _v1175
                     _v1175 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1176
                     _v1176 := usr$ge$uint256(_v1174, _v1175)
                     usr$solAssert(_v1176)
                     let _v1177
                     _v1177 := usr$Typedef_rep$uint256(eid)
                     let _v1178
                     _v1178 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
                     let _v1179
                     _v1179 := usr$Typedef_rep$address(_v1178)
                     let _v1180
                     _v1180 := usr$Typedef_rep$uint256(_v1168)
                     usr$emitLog3W1(65148424199380802297895668972783112174360658145439419530254325341241767658246, _v1177, _v1179, _v1180)}
      }
      function usr$claimRefund (eid) {
        let _v1181
        let _v1182
        let _v1183
        let _v1184
        let _v1185
        let _v1186
        let _v1187
        let _v1188
        let _v1189
        let _v1190
        let _v1191
        let _v1192
        let _v1193
        let _v1194
        let _v1195
        let _v1196
        _v1189, _v1190, _v1191, _v1192, _v1193, _v1194, _v1195, _v1196 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1181 := _v1189
        _v1182 := _v1190
        _v1183 := _v1191
        _v1184 := _v1192
        _v1185 := _v1193
        _v1186 := _v1194
        _v1187 := _v1195
        _v1188 := _v1196
        switch _v1181
          case false {usr$revertNotFound()}
          case true {let _v1197
                     _v1197 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     usr$requireK(_v1197, 3139381005)
                     let _v1198
                     _v1198 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1199
                     _v1199 := usr$caller()
                     let _v1200
                     let _v1201
                     let _v1202
                     let _v1203
                     _v1200, _v1201, _v1202, _v1203 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1198, _v1199)
                     usr$requireStatus(_v1200, _v1201, _v1202, _v1203, 1)
                     let _v1204
                     _v1204 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1205
                     _v1205 := usr$caller()
                     let _v1206
                     _v1206 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1204, _v1205)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1206, true, true, false, 911)
                     let _v1207
                     let _v1208
                     let _v1209
                     let _v1210
                     let _v1211
                     let _v1212
                     let _v1213
                     let _v1214
                     _v1211, _v1212, _v1213, _v1214 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1207 := _v1211
                     _v1208 := _v1212
                     _v1209 := _v1213
                     _v1210 := _v1214
                     let _v1215
                     _v1215 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v1216
                     _v1216 := usr$Sub_sub$uint256(_v1207, 1)
                     let _v1217
                     _v1217 := usr$subCk(_v1210, _v1183)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1215, _v1216, _v1208, _v1209, _v1217)
                     let _v1218
                     _v1218 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1219
                     _v1219 := usr$subCk(_v1218, _v1183)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1219)
                     let _v1220
                     _v1220 := usr$caller()
                     usr$sendValue(_v1220, _v1183)
                     let _v1221
                     _v1221 := usr$balanceSelf()
                     let _v1222
                     _v1222 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1223
                     _v1223 := usr$ge$uint256(_v1221, _v1222)
                     usr$solAssert(_v1223)
                     let _v1224
                     _v1224 := usr$Typedef_rep$uint256(eid)
                     let _v1225
                     _v1225 := usr$caller()
                     let _v1226
                     _v1226 := usr$Typedef_rep$address(_v1225)
                     let _v1227
                     _v1227 := usr$Typedef_rep$uint256(_v1183)
                     usr$emitLog3W1(110343147773003590039951001576381795264397980198489142373951635958240417622108, _v1224, _v1226, _v1227)}
      }
      function usr$claimedCount (eid) -> _result {
        let _v1228
        let _v1229
        let _v1230
        let _v1231
        let _v1232
        let _v1233
        let _v1234
        let _v1235
        _v1232, _v1233, _v1234, _v1235 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v1228 := _v1232
        _v1229 := _v1233
        _v1230 := _v1234
        _v1231 := _v1235
        _result := _v1230
        leave
      }
      function usr$createEvent (depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod, maxAttendees, metadataURI_) -> _result {
        usr$validateEventParams(depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod)
        let _v1236
        let _v1237
        _v1237 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_eventCount_sel_uint256_pairLaddress_unitJ()
        let _v1238
        _v1238 := usr$Add_add$uint256(_v1237, 1)
        _v1236 := _v1238
        usr$Assign_assign$a$storageLuint256J_uint256(1, _v1236)
        let _v1239
        _v1239 := usr$lidx$storageLmappingLuint256_EventRecJJ_uint256_storageLEventRecJ(3, _v1236)
        let _v1240
        _v1240 := usr$caller()
        usr$Assign_assign$a$storageLEventRecJ_EventRec(_v1239, true, _v1240, depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod, maxAttendees)
        usr$ArrayPush_push$storageLarrayLtJJ$string_memoryLstringJ(4, metadataURI_)
        let _v1241
        _v1241 := usr$Typedef_rep$uint256(_v1236)
        let _v1242
        _v1242 := usr$caller()
        let _v1243
        _v1243 := usr$Typedef_rep$address(_v1242)
        let _v1244
        _v1244 := usr$Typedef_rep$uint256(depositAmount)
        let _v1245
        _v1245 := usr$Typedef_rep$uint256(eventStart)
        let _v1246
        _v1246 := usr$Typedef_rep$uint256(eventEnd)
        usr$emitLog3W3(26039434587326103136200597718789237852261263058874806093281554555545441090759, _v1241, _v1243, _v1244, _v1245, _v1246)
        _result := _v1236
        leave
      }
      function usr$decodeBytesLike$string_CalldataWordReader (ptr, currentHeadOffset) -> _result {
        let tmp
        let _v1247
        let _v1248
        _v1248 := usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(ptr, currentHeadOffset)
        _v1247 := _v1248
        let tailPtr
        let _v1249
        _v1249 := usr$WordReader_read$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(_v1247)
        tailPtr := _v1249
        let _v1250
        let _v1251
        _v1251 := usr$WordReader_advance$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(ptr, tailPtr)
        _v1250 := _v1251
        let _v1252
        let _v1253
        _v1253 := usr$getReader$memoryLstringJ_CalldataWordReader(_v1250)
        _v1252 := _v1253
        let length
        let _v1254
        _v1254 := usr$WordReader_read$ABIDecoderLty_readerJ$memoryLstringJ_CalldataWordReader(_v1250)
        length := _v1254
        let total
        let _v1255
        _v1255 := usr$Add_add$word(length, 32)
        total := _v1255
        let rounded
        let _v1256
        _v1256 := usr$round_up_to_mul_of_32(total)
        rounded := _v1256
        let resultPtr
        let _v1257
        _v1257 := usr$allocate_memory(rounded)
        resultPtr := _v1257
        usr$WordReader_copyToMem$CalldataWordReader(_v1252, resultPtr, total)
        _result := resultPtr
        leave
      }
      function usr$deriveState (_v1258, eventStart, eventEnd, disputePeriod) -> _v1259, _v1260, _v1261, _v1262 {
        switch _v1258
          case false {}
          case true {_v1259 := true
                     _v1260 := true
                     _v1261 := true
                     _v1262 := true
                     leave}
        let _v1263
        let _v1264
        _v1264 := usr$timeNow()
        _v1263 := _v1264
        let _v1265
        let _v1266
        _v1266 := usr$lt$uint256(_v1263, eventStart)
        _v1265 := _v1266
        switch _v1265
          case false {}
          case true {_v1259 := false
                     leave}
        let _v1267
        let _v1268
        _v1268 := usr$le$uint256(_v1263, eventEnd)
        _v1267 := _v1268
        switch _v1267
          case false {}
          case true {_v1259 := true
                     _v1260 := false
                     leave}
        let _v1269
        let _v1270
        _v1270 := usr$addCk(eventEnd, disputePeriod)
        let _v1271
        _v1271 := usr$le$uint256(_v1263, _v1270)
        _v1269 := _v1271
        switch _v1269
          case false {}
          case true {_v1259 := true
                     _v1260 := true
                     _v1261 := false
                     leave}
        _v1259 := true
        _v1260 := true
        _v1261 := true
        _v1262 := false
        leave
      }
      function usr$div (a, b) -> _result {
        let res
        res := div(a, b)
        _result := res
        leave
      }
      function usr$do_exec$address_unit_t_setMaintainer440130 () {
        let _v1272
        _v1272 := usr$calldatasize()
        let _v1273
        _v1273 := usr$ge$word(_v1272, 36)
        usr$require(_v1273, false, 140739926, 911)
        let _v1274
        _v1274 := 4
        let _v1275
        let _v1276
        _v1276 := usr$abi_decode$calldataLbytesJ_address_CalldataWordReader_address(4)
        _v1275 := _v1276
        usr$invokable_invoke$t_setMaintainer440130(_v1275)
        let _v1277
        let _v1278
        _v1278 := usr$abi_encode$unit()
        _v1277 := _v1278
        let start
        let _v1279
        _v1279 := usr$Typedef_rep$memoryLtJ$bytes(_v1277)
        start := _v1279
        let end
        let _v1280
        _v1280 := usr$get_free_memory()
        end := _v1280
        let retSz
        let _v1281
        _v1281 := usr$Sub_sub$word(end, start)
        retSz := _v1281
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_addressJ_uint256_t_attendees577523 () {
        let _v1282
        _v1282 := usr$calldatasize()
        let _v1283
        _v1283 := usr$ge$word(_v1282, 68)
        usr$require(_v1283, false, 140739926, 911)
        let _v1284
        _v1284 := 4
        let _v1285
        let _v1286
        let _v1287
        let _v1288
        _v1287, _v1288 := usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ(4)
        _v1285 := _v1287
        _v1286 := _v1288
        let _v1289
        let _v1290
        _v1290 := usr$invokable_invoke$t_attendees577523(_v1285, _v1286)
        _v1289 := _v1290
        let _v1291
        let _v1292
        _v1292 := usr$abi_encode$uint256(_v1289)
        _v1291 := _v1292
        let start
        let _v1293
        _v1293 := usr$Typedef_rep$memoryLtJ$bytes(_v1291)
        start := _v1293
        let end
        let _v1294
        _v1294 := usr$get_free_memory()
        end := _v1294
        let retSz
        let _v1295
        _v1295 := usr$Sub_sub$word(end, start)
        retSz := _v1295
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_addressJ_unit_t_checkIn553620 () {
        let _v1296
        _v1296 := usr$calldatasize()
        let _v1297
        _v1297 := usr$ge$word(_v1296, 68)
        usr$require(_v1297, false, 140739926, 911)
        let _v1298
        _v1298 := 4
        let _v1299
        let _v1300
        let _v1301
        let _v1302
        _v1301, _v1302 := usr$abi_decode$calldataLbytesJ_pairLuint256_addressJ_CalldataWordReader_pairLuint256_addressJ(4)
        _v1299 := _v1301
        _v1300 := _v1302
        usr$invokable_invoke$t_checkIn553620(_v1299, _v1300)
        let _v1303
        let _v1304
        _v1304 := usr$abi_encode$unit()
        _v1303 := _v1304
        let start
        let _v1305
        _v1305 := usr$Typedef_rep$memoryLtJ$bytes(_v1303)
        start := _v1305
        let end
        let _v1306
        _v1306 := usr$get_free_memory()
        end := _v1306
        let retSz
        let _v1307
        _v1307 := usr$Sub_sub$word(end, start)
        retSz := _v1307
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720 () {
        let _v1308
        _v1308 := usr$calldatasize()
        let _v1309
        _v1309 := usr$ge$word(_v1308, 68)
        usr$require(_v1309, false, 140739926, 911)
        let _v1310
        _v1310 := 4
        let _v1311
        let _v1312
        let _v1313
        let _v1314
        _v1313, _v1314 := usr$abi_decode$calldataLbytesJ_pairLuint256_memoryLstringJJ_CalldataWordReader_pairLuint256_memoryLstringJJ(4)
        _v1311 := _v1313
        _v1312 := _v1314
        usr$invokable_invoke$t_setMetadataURI434720(_v1311, _v1312)
        let _v1315
        let _v1316
        _v1316 := usr$abi_encode$unit()
        _v1315 := _v1316
        let start
        let _v1317
        _v1317 := usr$Typedef_rep$memoryLtJ$bytes(_v1315)
        start := _v1317
        let end
        let _v1318
        _v1318 := usr$get_free_memory()
        end := _v1318
        let retSz
        let _v1319
        _v1319 := usr$Sub_sub$word(end, start)
        retSz := _v1319
        return(start, retSz)
      }
      function usr$do_exec$pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446 () {
        let _v1320
        _v1320 := usr$calldatasize()
        let _v1321
        _v1321 := usr$ge$word(_v1320, 228)
        usr$require(_v1321, false, 140739926, 911)
        let _v1322
        _v1322 := 4
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
        let _v1333
        let _v1334
        let _v1335
        let _v1336
        _v1330, _v1331, _v1332, _v1333, _v1334, _v1335, _v1336 := usr$abi_decode$calldataLbytesJ_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_CalldataWordReader_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ(4)
        _v1323 := _v1330
        _v1324 := _v1331
        _v1325 := _v1332
        _v1326 := _v1333
        _v1327 := _v1334
        _v1328 := _v1335
        _v1329 := _v1336
        let _v1337
        let _v1338
        _v1338 := usr$invokable_invoke$t_createEvent504446(_v1323, _v1324, _v1325, _v1326, _v1327, _v1328, _v1329)
        _v1337 := _v1338
        let _v1339
        let _v1340
        _v1340 := usr$abi_encode$uint256(_v1337)
        _v1339 := _v1340
        let start
        let _v1341
        _v1341 := usr$Typedef_rep$memoryLtJ$bytes(_v1339)
        start := _v1341
        let end
        let _v1342
        _v1342 := usr$get_free_memory()
        end := _v1342
        let retSz
        let _v1343
        _v1343 := usr$Sub_sub$word(end, start)
        retSz := _v1343
        return(start, retSz)
      }
      function usr$do_exec$uint256_address_t_organizer467391 () {
        let _v1344
        _v1344 := usr$calldatasize()
        let _v1345
        _v1345 := usr$ge$word(_v1344, 36)
        usr$require(_v1345, false, 140739926, 911)
        let _v1346
        _v1346 := 4
        let _v1347
        let _v1348
        _v1348 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1347 := _v1348
        let _v1349
        let _v1350
        _v1350 := usr$invokable_invoke$t_organizer467391(_v1347)
        _v1349 := _v1350
        let _v1351
        let _v1352
        _v1352 := usr$abi_encode$address(_v1349)
        _v1351 := _v1352
        let start
        let _v1353
        _v1353 := usr$Typedef_rep$memoryLtJ$bytes(_v1351)
        start := _v1353
        let end
        let _v1354
        _v1354 := usr$get_free_memory()
        end := _v1354
        let retSz
        let _v1355
        _v1355 := usr$Sub_sub$word(end, start)
        retSz := _v1355
        return(start, retSz)
      }
      function usr$do_exec$uint256_memoryLstringJ_t_metadataURI472965 () {
        let _v1356
        _v1356 := usr$calldatasize()
        let _v1357
        _v1357 := usr$ge$word(_v1356, 36)
        usr$require(_v1357, false, 140739926, 911)
        let _v1358
        _v1358 := 4
        let _v1359
        let _v1360
        _v1360 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1359 := _v1360
        let _v1361
        let _v1362
        _v1362 := usr$invokable_invoke$t_metadataURI472965(_v1359)
        _v1361 := _v1362
        let _v1363
        let _v1364
        _v1364 := usr$abi_encode$memoryLstringJ(_v1361)
        _v1363 := _v1364
        let start
        let _v1365
        _v1365 := usr$Typedef_rep$memoryLtJ$bytes(_v1363)
        start := _v1365
        let end
        let _v1366
        _v1366 := usr$get_free_memory()
        end := _v1366
        let retSz
        let _v1367
        _v1367 := usr$Sub_sub$word(end, start)
        retSz := _v1367
        return(start, retSz)
      }
      function usr$do_exec$uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628 () {
        let _v1368
        _v1368 := usr$calldatasize()
        let _v1369
        _v1369 := usr$ge$word(_v1368, 36)
        usr$require(_v1369, false, 140739926, 911)
        let _v1370
        _v1370 := 4
        let _v1371
        let _v1372
        _v1372 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1371 := _v1372
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
        let _v1386
        _v1380, _v1381, _v1382, _v1383, _v1384, _v1385, _v1386 := usr$invokable_invoke$t_getEvent493628(_v1371)
        _v1373 := _v1380
        _v1374 := _v1381
        _v1375 := _v1382
        _v1376 := _v1383
        _v1377 := _v1384
        _v1378 := _v1385
        _v1379 := _v1386
        let _v1387
        let _v1388
        _v1388 := usr$abi_encode$pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ(_v1373, _v1374, _v1375, _v1376, _v1377, _v1378, _v1379)
        _v1387 := _v1388
        let start
        let _v1389
        _v1389 := usr$Typedef_rep$memoryLtJ$bytes(_v1387)
        start := _v1389
        let end
        let _v1390
        _v1390 := usr$get_free_memory()
        end := _v1390
        let retSz
        let _v1391
        _v1391 := usr$Sub_sub$word(end, start)
        retSz := _v1391
        return(start, retSz)
      }
      function usr$do_exec$uint256_sumLunit_unitJ_t_cancelled558964 () {
        let _v1392
        _v1392 := usr$calldatasize()
        let _v1393
        _v1393 := usr$ge$word(_v1392, 36)
        usr$require(_v1393, false, 140739926, 911)
        let _v1394
        _v1394 := 4
        let _v1395
        let _v1396
        _v1396 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1395 := _v1396
        let _v1397
        let _v1398
        _v1398 := usr$invokable_invoke$t_cancelled558964(_v1395)
        _v1397 := _v1398
        let _v1399
        let _v1400
        _v1400 := usr$abi_encode$sumLunit_unitJ(_v1397)
        _v1399 := _v1400
        let start
        let _v1401
        _v1401 := usr$Typedef_rep$memoryLtJ$bytes(_v1399)
        start := _v1401
        let end
        let _v1402
        _v1402 := usr$get_free_memory()
        end := _v1402
        let retSz
        let _v1403
        _v1403 := usr$Sub_sub$word(end, start)
        retSz := _v1403
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_checkedInCount536682 () {
        let _v1404
        _v1404 := usr$calldatasize()
        let _v1405
        _v1405 := usr$ge$word(_v1404, 36)
        usr$require(_v1405, false, 140739926, 911)
        let _v1406
        _v1406 := 4
        let _v1407
        let _v1408
        _v1408 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1407 := _v1408
        let _v1409
        let _v1410
        _v1410 := usr$invokable_invoke$t_checkedInCount536682(_v1407)
        _v1409 := _v1410
        let _v1411
        let _v1412
        _v1412 := usr$abi_encode$uint256(_v1409)
        _v1411 := _v1412
        let start
        let _v1413
        _v1413 := usr$Typedef_rep$memoryLtJ$bytes(_v1411)
        start := _v1413
        let end
        let _v1414
        _v1414 := usr$get_free_memory()
        end := _v1414
        let retSz
        let _v1415
        _v1415 := usr$Sub_sub$word(end, start)
        retSz := _v1415
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_claimedCount509695 () {
        let _v1416
        _v1416 := usr$calldatasize()
        let _v1417
        _v1417 := usr$ge$word(_v1416, 36)
        usr$require(_v1417, false, 140739926, 911)
        let _v1418
        _v1418 := 4
        let _v1419
        let _v1420
        _v1420 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1419 := _v1420
        let _v1421
        let _v1422
        _v1422 := usr$invokable_invoke$t_claimedCount509695(_v1419)
        _v1421 := _v1422
        let _v1423
        let _v1424
        _v1424 := usr$abi_encode$uint256(_v1421)
        _v1423 := _v1424
        let start
        let _v1425
        _v1425 := usr$Typedef_rep$memoryLtJ$bytes(_v1423)
        start := _v1425
        let end
        let _v1426
        _v1426 := usr$get_free_memory()
        end := _v1426
        let retSz
        let _v1427
        _v1427 := usr$Sub_sub$word(end, start)
        retSz := _v1427
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_getState488429 () {
        let _v1428
        _v1428 := usr$calldatasize()
        let _v1429
        _v1429 := usr$ge$word(_v1428, 36)
        usr$require(_v1429, false, 140739926, 911)
        let _v1430
        _v1430 := 4
        let _v1431
        let _v1432
        _v1432 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1431 := _v1432
        let _v1433
        let _v1434
        _v1434 := usr$invokable_invoke$t_getState488429(_v1431)
        _v1433 := _v1434
        let _v1435
        let _v1436
        _v1436 := usr$abi_encode$uint256(_v1433)
        _v1435 := _v1436
        let start
        let _v1437
        _v1437 := usr$Typedef_rep$memoryLtJ$bytes(_v1435)
        start := _v1437
        let end
        let _v1438
        _v1438 := usr$get_free_memory()
        end := _v1438
        let retSz
        let _v1439
        _v1439 := usr$Sub_sub$word(end, start)
        retSz := _v1439
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_held483049 () {
        let _v1440
        _v1440 := usr$calldatasize()
        let _v1441
        _v1441 := usr$ge$word(_v1440, 36)
        usr$require(_v1441, false, 140739926, 911)
        let _v1442
        _v1442 := 4
        let _v1443
        let _v1444
        _v1444 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1443 := _v1444
        let _v1445
        let _v1446
        _v1446 := usr$invokable_invoke$t_held483049(_v1443)
        _v1445 := _v1446
        let _v1447
        let _v1448
        _v1448 := usr$abi_encode$uint256(_v1445)
        _v1447 := _v1448
        let start
        let _v1449
        _v1449 := usr$Typedef_rep$memoryLtJ$bytes(_v1447)
        start := _v1449
        let end
        let _v1450
        _v1450 := usr$get_free_memory()
        end := _v1450
        let retSz
        let _v1451
        _v1451 := usr$Sub_sub$word(end, start)
        retSz := _v1451
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_registeredCount455191 () {
        let _v1452
        _v1452 := usr$calldatasize()
        let _v1453
        _v1453 := usr$ge$word(_v1452, 36)
        usr$require(_v1453, false, 140739926, 911)
        let _v1454
        _v1454 := 4
        let _v1455
        let _v1456
        _v1456 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1455 := _v1456
        let _v1457
        let _v1458
        _v1458 := usr$invokable_invoke$t_registeredCount455191(_v1455)
        _v1457 := _v1458
        let _v1459
        let _v1460
        _v1460 := usr$abi_encode$uint256(_v1457)
        _v1459 := _v1460
        let start
        let _v1461
        _v1461 := usr$Typedef_rep$memoryLtJ$bytes(_v1459)
        start := _v1461
        let end
        let _v1462
        _v1462 := usr$get_free_memory()
        end := _v1462
        let retSz
        let _v1463
        _v1463 := usr$Sub_sub$word(end, start)
        retSz := _v1463
        return(start, retSz)
      }
      function usr$do_exec$uint256_uint256_t_rewardPerAttendee450146 () {
        let _v1464
        _v1464 := usr$calldatasize()
        let _v1465
        _v1465 := usr$ge$word(_v1464, 36)
        usr$require(_v1465, false, 140739926, 911)
        let _v1466
        _v1466 := 4
        let _v1467
        let _v1468
        _v1468 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1467 := _v1468
        let _v1469
        let _v1470
        _v1470 := usr$invokable_invoke$t_rewardPerAttendee450146(_v1467)
        _v1469 := _v1470
        let _v1471
        let _v1472
        _v1472 := usr$abi_encode$uint256(_v1469)
        _v1471 := _v1472
        let start
        let _v1473
        _v1473 := usr$Typedef_rep$memoryLtJ$bytes(_v1471)
        start := _v1473
        let end
        let _v1474
        _v1474 := usr$get_free_memory()
        end := _v1474
        let retSz
        let _v1475
        _v1475 := usr$Sub_sub$word(end, start)
        retSz := _v1475
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_cancel572080 () {
        let _v1476
        _v1476 := usr$calldatasize()
        let _v1477
        _v1477 := usr$ge$word(_v1476, 36)
        usr$require(_v1477, false, 140739926, 911)
        let _v1478
        _v1478 := 4
        let _v1479
        let _v1480
        _v1480 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1479 := _v1480
        usr$invokable_invoke$t_cancel572080(_v1479)
        let _v1481
        let _v1482
        _v1482 := usr$abi_encode$unit()
        _v1481 := _v1482
        let start
        let _v1483
        _v1483 := usr$Typedef_rep$memoryLtJ$bytes(_v1481)
        start := _v1483
        let end
        let _v1484
        _v1484 := usr$get_free_memory()
        end := _v1484
        let retSz
        let _v1485
        _v1485 := usr$Sub_sub$word(end, start)
        retSz := _v1485
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_cancelEvent564882 () {
        let _v1486
        _v1486 := usr$calldatasize()
        let _v1487
        _v1487 := usr$ge$word(_v1486, 36)
        usr$require(_v1487, false, 140739926, 911)
        let _v1488
        _v1488 := 4
        let _v1489
        let _v1490
        _v1490 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1489 := _v1490
        usr$invokable_invoke$t_cancelEvent564882(_v1489)
        let _v1491
        let _v1492
        _v1492 := usr$abi_encode$unit()
        _v1491 := _v1492
        let start
        let _v1493
        _v1493 := usr$Typedef_rep$memoryLtJ$bytes(_v1491)
        start := _v1493
        let end
        let _v1494
        _v1494 := usr$get_free_memory()
        end := _v1494
        let retSz
        let _v1495
        _v1495 := usr$Sub_sub$word(end, start)
        retSz := _v1495
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_claim531385 () {
        let _v1496
        _v1496 := usr$calldatasize()
        let _v1497
        _v1497 := usr$ge$word(_v1496, 36)
        usr$require(_v1497, false, 140739926, 911)
        let _v1498
        _v1498 := 4
        let _v1499
        let _v1500
        _v1500 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1499 := _v1500
        usr$invokable_invoke$t_claim531385(_v1499)
        let _v1501
        let _v1502
        _v1502 := usr$abi_encode$unit()
        _v1501 := _v1502
        let start
        let _v1503
        _v1503 := usr$Typedef_rep$memoryLtJ$bytes(_v1501)
        start := _v1503
        let end
        let _v1504
        _v1504 := usr$get_free_memory()
        end := _v1504
        let retSz
        let _v1505
        _v1505 := usr$Sub_sub$word(end, start)
        retSz := _v1505
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_claimDust524010 () {
        let _v1506
        _v1506 := usr$calldatasize()
        let _v1507
        _v1507 := usr$ge$word(_v1506, 36)
        usr$require(_v1507, false, 140739926, 911)
        let _v1508
        _v1508 := 4
        let _v1509
        let _v1510
        _v1510 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1509 := _v1510
        usr$invokable_invoke$t_claimDust524010(_v1509)
        let _v1511
        let _v1512
        _v1512 := usr$abi_encode$unit()
        _v1511 := _v1512
        let start
        let _v1513
        _v1513 := usr$Typedef_rep$memoryLtJ$bytes(_v1511)
        start := _v1513
        let end
        let _v1514
        _v1514 := usr$get_free_memory()
        end := _v1514
        let retSz
        let _v1515
        _v1515 := usr$Sub_sub$word(end, start)
        retSz := _v1515
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_claimRefund517003 () {
        let _v1516
        _v1516 := usr$calldatasize()
        let _v1517
        _v1517 := usr$ge$word(_v1516, 36)
        usr$require(_v1517, false, 140739926, 911)
        let _v1518
        _v1518 := 4
        let _v1519
        let _v1520
        _v1520 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1519 := _v1520
        usr$invokable_invoke$t_claimRefund517003(_v1519)
        let _v1521
        let _v1522
        _v1522 := usr$abi_encode$unit()
        _v1521 := _v1522
        let start
        let _v1523
        _v1523 := usr$Typedef_rep$memoryLtJ$bytes(_v1521)
        start := _v1523
        let end
        let _v1524
        _v1524 := usr$get_free_memory()
        end := _v1524
        let retSz
        let _v1525
        _v1525 := usr$Sub_sub$word(end, start)
        retSz := _v1525
        return(start, retSz)
      }
      function usr$do_exec$uint256_unit_t_register462360 () {
        let _v1526
        _v1526 := usr$calldatasize()
        let _v1527
        _v1527 := usr$ge$word(_v1526, 36)
        usr$require(_v1527, false, 140739926, 911)
        let _v1528
        _v1528 := 4
        let _v1529
        let _v1530
        _v1530 := usr$abi_decode$calldataLbytesJ_uint256_CalldataWordReader_uint256(4)
        _v1529 := _v1530
        usr$invokable_invoke$t_register462360(_v1529)
        let _v1531
        let _v1532
        _v1532 := usr$abi_encode$unit()
        _v1531 := _v1532
        let start
        let _v1533
        _v1533 := usr$Typedef_rep$memoryLtJ$bytes(_v1531)
        start := _v1533
        let end
        let _v1534
        _v1534 := usr$get_free_memory()
        end := _v1534
        let retSz
        let _v1535
        _v1535 := usr$Sub_sub$word(end, start)
        retSz := _v1535
        return(start, retSz)
      }
      function usr$do_exec$unit_address_t_maintainer477915 () {
        let _v1536
        _v1536 := usr$calldatasize()
        let _v1537
        _v1537 := usr$ge$word(_v1536, 4)
        usr$require(_v1537, false, 140739926, 911)
        let _v1538
        _v1538 := 4
        let _v1539
        let _v1540
        _v1540 := usr$invokable_invoke$t_maintainer477915()
        _v1539 := _v1540
        let _v1541
        let _v1542
        _v1542 := usr$abi_encode$address(_v1539)
        _v1541 := _v1542
        let start
        let _v1543
        _v1543 := usr$Typedef_rep$memoryLtJ$bytes(_v1541)
        start := _v1543
        let end
        let _v1544
        _v1544 := usr$get_free_memory()
        end := _v1544
        let retSz
        let _v1545
        _v1545 := usr$Sub_sub$word(end, start)
        retSz := _v1545
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_DUST_CLAIM_TIMEOUT593002 () {
        let _v1546
        _v1546 := usr$calldatasize()
        let _v1547
        _v1547 := usr$ge$word(_v1546, 4)
        usr$require(_v1547, false, 140739926, 911)
        let _v1548
        _v1548 := 4
        let _v1549
        let _v1550
        _v1550 := usr$invokable_invoke$t_DUST_CLAIM_TIMEOUT593002()
        _v1549 := _v1550
        let _v1551
        let _v1552
        _v1552 := usr$abi_encode$uint256(_v1549)
        _v1551 := _v1552
        let start
        let _v1553
        _v1553 := usr$Typedef_rep$memoryLtJ$bytes(_v1551)
        start := _v1553
        let end
        let _v1554
        _v1554 := usr$get_free_memory()
        end := _v1554
        let retSz
        let _v1555
        _v1555 := usr$Sub_sub$word(end, start)
        retSz := _v1555
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_MAX_BATCH_SIZE587826 () {
        let _v1556
        _v1556 := usr$calldatasize()
        let _v1557
        _v1557 := usr$ge$word(_v1556, 4)
        usr$require(_v1557, false, 140739926, 911)
        let _v1558
        _v1558 := 4
        let _v1559
        let _v1560
        _v1560 := usr$invokable_invoke$t_MAX_BATCH_SIZE587826()
        _v1559 := _v1560
        let _v1561
        let _v1562
        _v1562 := usr$abi_encode$uint256(_v1559)
        _v1561 := _v1562
        let start
        let _v1563
        _v1563 := usr$Typedef_rep$memoryLtJ$bytes(_v1561)
        start := _v1563
        let end
        let _v1564
        _v1564 := usr$get_free_memory()
        end := _v1564
        let retSz
        let _v1565
        _v1565 := usr$Sub_sub$word(end, start)
        retSz := _v1565
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_MIN_CANCELLATION_BUFFER582668 () {
        let _v1566
        _v1566 := usr$calldatasize()
        let _v1567
        _v1567 := usr$ge$word(_v1566, 4)
        usr$require(_v1567, false, 140739926, 911)
        let _v1568
        _v1568 := 4
        let _v1569
        let _v1570
        _v1570 := usr$invokable_invoke$t_MIN_CANCELLATION_BUFFER582668()
        _v1569 := _v1570
        let _v1571
        let _v1572
        _v1572 := usr$abi_encode$uint256(_v1569)
        _v1571 := _v1572
        let start
        let _v1573
        _v1573 := usr$Typedef_rep$memoryLtJ$bytes(_v1571)
        start := _v1573
        let end
        let _v1574
        _v1574 := usr$get_free_memory()
        end := _v1574
        let retSz
        let _v1575
        _v1575 := usr$Sub_sub$word(end, start)
        retSz := _v1575
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_eventCount498664 () {
        let _v1576
        _v1576 := usr$calldatasize()
        let _v1577
        _v1577 := usr$ge$word(_v1576, 4)
        usr$require(_v1577, false, 140739926, 911)
        let _v1578
        _v1578 := 4
        let _v1579
        let _v1580
        _v1580 := usr$invokable_invoke$t_eventCount498664()
        _v1579 := _v1580
        let _v1581
        let _v1582
        _v1582 := usr$abi_encode$uint256(_v1579)
        _v1581 := _v1582
        let start
        let _v1583
        _v1583 := usr$Typedef_rep$memoryLtJ$bytes(_v1581)
        start := _v1583
        let end
        let _v1584
        _v1584 := usr$get_free_memory()
        end := _v1584
        let retSz
        let _v1585
        _v1585 := usr$Sub_sub$word(end, start)
        retSz := _v1585
        return(start, retSz)
      }
      function usr$do_exec$unit_uint256_t_totalHeld429515 () {
        let _v1586
        _v1586 := usr$calldatasize()
        let _v1587
        _v1587 := usr$ge$word(_v1586, 4)
        usr$require(_v1587, false, 140739926, 911)
        let _v1588
        _v1588 := 4
        let _v1589
        let _v1590
        _v1590 := usr$invokable_invoke$t_totalHeld429515()
        _v1589 := _v1590
        let _v1591
        let _v1592
        _v1592 := usr$abi_encode$uint256(_v1589)
        _v1591 := _v1592
        let start
        let _v1593
        _v1593 := usr$Typedef_rep$memoryLtJ$bytes(_v1591)
        start := _v1593
        let end
        let _v1594
        _v1594 := usr$get_free_memory()
        end := _v1594
        let retSz
        let _v1595
        _v1595 := usr$Sub_sub$word(end, start)
        retSz := _v1595
        return(start, retSz)
      }
      function usr$emitLog2 (t0, t1) {
        usr$log2_(0, 0, t0, t1)
        leave
      }
      function usr$emitLog2Str (t0, t1, s) {
        let _v1596
        let _v1597
        _v1597 := usr$abi_encode$memoryLstringJ(s)
        _v1596 := _v1597
        let start
        let _v1598
        _v1598 := usr$Typedef_rep$memoryLtJ$bytes(_v1596)
        start := _v1598
        let _v1599
        _v1599 := usr$get_free_memory()
        let _v1600
        _v1600 := usr$Sub_sub$word(_v1599, start)
        usr$log2_(start, _v1600, t0, t1)
      }
      function usr$emitLog3 (t0, t1, t2) {
        usr$log3_(0, 0, t0, t1, t2)
        leave
      }
      function usr$emitLog3W1 (t0, t1, t2, d0) {
        let p
        let _v1601
        _v1601 := usr$get_free_memory()
        p := _v1601
        usr$mstore(p, d0)
        usr$log3_(p, 32, t0, t1, t2)
      }
      function usr$emitLog3W3 (t0, t1, t2, d0, d1, d2) {
        let p
        let _v1602
        _v1602 := usr$get_free_memory()
        p := _v1602
        usr$mstore(p, d0)
        let _v1603
        _v1603 := usr$Add_add$word(p, 32)
        usr$mstore(_v1603, d1)
        let _v1604
        _v1604 := usr$Add_add$word(p, 64)
        usr$mstore(_v1604, d2)
        usr$log3_(p, 96, t0, t1, t2)
      }
      function usr$encodeIntoFromBytesLike (srcPtr, basePtr, offset, tail) -> _result {
        let length
        let _v1605
        _v1605 := usr$mload(srcPtr)
        length := _v1605
        let total
        let _v1606
        _v1606 := usr$Add_add$word(length, 32)
        total := _v1606
        let _v1607
        _v1607 := usr$Add_add$word(basePtr, offset)
        let _v1608
        _v1608 := usr$Sub_sub$word(tail, basePtr)
        usr$mstore(_v1607, _v1608)
        usr$mcopy(tail, srcPtr, total)
        let rounded
        let _v1609
        _v1609 := usr$round_up_to_mul_of_32(total)
        rounded := _v1609
        let _v1610
        _v1610 := usr$Add_add$word(tail, total)
        let _v1611
        _v1611 := usr$Sub_sub$word(rounded, total)
        usr$zeroize_memory(_v1610, _v1611)
        let _v1612
        _v1612 := usr$Add_add$word(tail, rounded)
        _result := _v1612
        leave
      }
      function usr$eq (a, b) -> _result {
        let res
        res := eq(a, b)
        _result := res
        leave
      }
      function usr$eqWord (x, y) -> _v1613 {
        let _v1614
        _v1614 := usr$eq(x, y)
        let _v1615
        _v1615 := usr$tobool(_v1614)
        _v1613 := _v1615
        leave
      }
      function usr$eventCount () -> _result {
        let _v1616
        _v1616 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_eventCount_sel_uint256_pairLaddress_unitJ()
        _result := _v1616
        leave
      }
      function usr$fail (e) { usr$require(false, false, e, 911) }
      function usr$fallback () {
        let sz
        let _v1617
        _v1617 := usr$calldatasize()
        sz := _v1617
        let _v1618
        _v1618 := usr$ne$word(sz, 0)
        usr$requireK(_v1618, 2428038168)
        let _v1619
        let _v1620
        _v1620 := usr$ge$word(sz, 4)
        _v1619 := _v1620
        switch _v1619
          case false {}
          case true {let _v1621
                     let _v1622
                     _v1622 := usr$calldataload(0)
                     let _v1623
                     _v1623 := usr$shr(224, _v1622)
                     let _v1624
                     _v1624 := usr$Eq_eq$word(_v1623, 3180056963)
                     _v1621 := _v1624
                     switch _v1621
                       case false {}
                       case true {let _v1625
                                  let _v1626
                                  _v1626 := usr$callvalue_()
                                  let _v1627
                                  _v1627 := usr$ne$word(_v1626, 0)
                                  _v1625 := _v1627
                                  switch _v1625
                                    case false {}
                                    case true {usr$revertEmpty()}
                                  usr$checkInBatchImpl()
                                  leave}}
        usr$revertEmpty()
      }
      function usr$frombool (_v1628) -> _result {
        switch _v1628
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
      function usr$ge$uint256 (x, y) -> _v1629 {
        let _v1630
        _v1630 := usr$le$uint256(y, x)
        _v1629 := _v1630
        leave
      }
      function usr$ge$word (x, y) -> _v1631 {
        let _v1632
        _v1632 := usr$le$word(y, x)
        _v1631 := _v1632
        leave
      }
      function usr$getEvent (eid) -> _v1633, _v1634, _v1635, _v1636, _v1637, _v1638, _v1639 {
        let _v1640
        let _v1641
        let _v1642
        let _v1643
        let _v1644
        let _v1645
        let _v1646
        let _v1647
        let _v1648
        let _v1649
        let _v1650
        let _v1651
        let _v1652
        let _v1653
        let _v1654
        let _v1655
        _v1648, _v1649, _v1650, _v1651, _v1652, _v1653, _v1654, _v1655 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1640 := _v1648
        _v1641 := _v1649
        _v1642 := _v1650
        _v1643 := _v1651
        _v1644 := _v1652
        _v1645 := _v1653
        _v1646 := _v1654
        _v1647 := _v1655
        switch _v1640
          case false {usr$revertNotFound()
                      _v1633 := 0
                      _v1634 := 0
                      _v1635 := 0
                      _v1636 := 0
                      _v1637 := 0
                      _v1638 := 0
                      _v1639 := 0
                      leave}
          case true {_v1633 := _v1641
                     _v1634 := _v1642
                     _v1635 := _v1643
                     _v1636 := _v1644
                     _v1637 := _v1645
                     _v1638 := _v1646
                     _v1639 := _v1647
                     leave}
      }
      function usr$getReader$memoryLstringJ_CalldataWordReader (d) -> _result {
        _result := d
        leave
      }
      function usr$getState (eid) -> _result {
        let _v1656
        let _v1657
        let _v1658
        let _v1659
        let _v1660
        let _v1661
        let _v1662
        let _v1663
        let _v1664
        let _v1665
        let _v1666
        let _v1667
        let _v1668
        let _v1669
        let _v1670
        let _v1671
        _v1664, _v1665, _v1666, _v1667, _v1668, _v1669, _v1670, _v1671 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1656 := _v1664
        _v1657 := _v1665
        _v1658 := _v1666
        _v1659 := _v1667
        _v1660 := _v1668
        _v1661 := _v1669
        _v1662 := _v1670
        _v1663 := _v1671
        switch _v1656
          case false {usr$revertNotFound()
                      _result := 0
                      leave}
          case true {let _v1672
                     _v1672 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v1673
                     let _v1674
                     let _v1675
                     let _v1676
                     _v1673, _v1674, _v1675, _v1676 := usr$deriveState(_v1672, _v1660, _v1661, _v1662)
                     let _v1677
                     _v1677 := usr$stateOrd(_v1673, _v1674, _v1675, _v1676)
                     _result := _v1677
                     leave}
      }
      function usr$get_free_memory () -> _result {
        let _v1678
        _v1678 := usr$mload(64)
        _result := _v1678
        leave
      }
      function usr$gtWord (x, y) -> _v1679 {
        let _v1680
        _v1680 := usr$gt_(x, y)
        let _v1681
        _v1681 := usr$tobool(_v1680)
        _v1679 := _v1681
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
        let _v1682
        _v1682 := usr$keccak256(0, 32)
        _result := _v1682
        leave
      }
      function usr$hash2 (x, y) -> _result {
        usr$mstore(0, x)
        usr$mstore(32, y)
        let _v1683
        _v1683 := usr$keccak256(0, 64)
        _result := _v1683
        leave
      }
      function usr$held (eid) -> _result {
        let _v1684
        let _v1685
        let _v1686
        let _v1687
        let _v1688
        let _v1689
        let _v1690
        let _v1691
        _v1688, _v1689, _v1690, _v1691 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v1684 := _v1688
        _v1685 := _v1689
        _v1686 := _v1690
        _v1687 := _v1691
        _result := _v1687
        leave
      }
      function usr$invokable_invoke$t_DUST_CLAIM_TIMEOUT593002 () -> _result {
        _result := 2592000
        leave
      }
      function usr$invokable_invoke$t_MAX_BATCH_SIZE587826 () -> _result {
        _result := 100
        leave
      }
      function usr$invokable_invoke$t_MIN_CANCELLATION_BUFFER582668 () -> _result {
        _result := 7200
        leave
      }
      function usr$invokable_invoke$t_attendees577523 (_v1692, _v1693) -> _result {
        let _v1694
        let _v1695
        _v1694 := _v1692
        _v1695 := _v1693
        let _v1696
        _v1696 := usr$attendees(_v1694, _v1695)
        _result := _v1696
        leave
      }
      function usr$invokable_invoke$t_cancel572080 (arg572082) {
        let _v1697
        _v1697 := arg572082
        usr$cancel(_v1697)
        leave
      }
      function usr$invokable_invoke$t_cancelEvent564882 (arg564884) {
        let _v1698
        _v1698 := arg564884
        usr$cancelEvent(_v1698)
        leave
      }
      function usr$invokable_invoke$t_cancelled558964 (arg558966) -> _v1699 {
        let _v1700
        _v1700 := arg558966
        let _v1701
        _v1701 := usr$cancelled(_v1700)
        _v1699 := _v1701
        leave
      }
      function usr$invokable_invoke$t_checkIn553620 (_v1702, _v1703) {
        let _v1704
        let _v1705
        _v1704 := _v1702
        _v1705 := _v1703
        usr$checkIn(_v1704, _v1705)
        leave
      }
      function usr$invokable_invoke$t_checkedInCount536682 (arg536684) -> _result {
        let _v1706
        _v1706 := arg536684
        let _v1707
        _v1707 := usr$checkedInCount(_v1706)
        _result := _v1707
        leave
      }
      function usr$invokable_invoke$t_claim531385 (arg531387) {
        let _v1708
        _v1708 := arg531387
        usr$claim(_v1708)
        leave
      }
      function usr$invokable_invoke$t_claimDust524010 (arg524012) {
        let _v1709
        _v1709 := arg524012
        usr$claimDust(_v1709)
        leave
      }
      function usr$invokable_invoke$t_claimRefund517003 (arg517005) {
        let _v1710
        _v1710 := arg517005
        usr$claimRefund(_v1710)
        leave
      }
      function usr$invokable_invoke$t_claimedCount509695 (arg509697) -> _result {
        let _v1711
        _v1711 := arg509697
        let _v1712
        _v1712 := usr$claimedCount(_v1711)
        _result := _v1712
        leave
      }
      function usr$invokable_invoke$t_createEvent504446 (_v1713, _v1714, _v1715, _v1716, _v1717, _v1718, _v1719) -> _result {
        let _v1720
        let _v1721
        let _v1722
        let _v1723
        let _v1724
        let _v1725
        let _v1726
        _v1720 := _v1713
        _v1721 := _v1714
        _v1722 := _v1715
        _v1723 := _v1716
        _v1724 := _v1717
        _v1725 := _v1718
        _v1726 := _v1719
        let _v1727
        _v1727 := usr$createEvent(_v1720, _v1721, _v1722, _v1723, _v1724, _v1725, _v1726)
        _result := _v1727
        leave
      }
      function usr$invokable_invoke$t_eventCount498664 () -> _result {
        let _v1728
        _v1728 := usr$eventCount()
        _result := _v1728
        leave
      }
      function usr$invokable_invoke$t_fallback604097 () {
        usr$fallback()
        leave
      }
      function usr$invokable_invoke$t_getEvent493628 (arg493630) -> _v1729, _v1730, _v1731, _v1732, _v1733, _v1734, _v1735 {
        let _v1736
        _v1736 := arg493630
        let _v1737
        let _v1738
        let _v1739
        let _v1740
        let _v1741
        let _v1742
        let _v1743
        _v1737, _v1738, _v1739, _v1740, _v1741, _v1742, _v1743 := usr$getEvent(_v1736)
        _v1729 := _v1737
        _v1730 := _v1738
        _v1731 := _v1739
        _v1732 := _v1740
        _v1733 := _v1741
        _v1734 := _v1742
        _v1735 := _v1743
        leave
      }
      function usr$invokable_invoke$t_getState488429 (arg488431) -> _result {
        let _v1744
        _v1744 := arg488431
        let _v1745
        _v1745 := usr$getState(_v1744)
        _result := _v1745
        leave
      }
      function usr$invokable_invoke$t_held483049 (arg483051) -> _result {
        let _v1746
        _v1746 := arg483051
        let _v1747
        _v1747 := usr$held(_v1746)
        _result := _v1747
        leave
      }
      function usr$invokable_invoke$t_maintainer477915 () -> _result {
        let _v1748
        _v1748 := usr$maintainer()
        _result := _v1748
        leave
      }
      function usr$invokable_invoke$t_metadataURI472965 (arg472967) -> _result {
        let _v1749
        _v1749 := arg472967
        let _v1750
        _v1750 := usr$metadataURI(_v1749)
        _result := _v1750
        leave
      }
      function usr$invokable_invoke$t_organizer467391 (arg467393) -> _result {
        let _v1751
        _v1751 := arg467393
        let _v1752
        _v1752 := usr$organizer(_v1751)
        _result := _v1752
        leave
      }
      function usr$invokable_invoke$t_register462360 (arg462362) {
        let _v1753
        _v1753 := arg462362
        usr$register(_v1753)
        leave
      }
      function usr$invokable_invoke$t_registeredCount455191 (arg455193) -> _result {
        let _v1754
        _v1754 := arg455193
        let _v1755
        _v1755 := usr$registeredCount(_v1754)
        _result := _v1755
        leave
      }
      function usr$invokable_invoke$t_rewardPerAttendee450146 (arg450148) -> _result {
        let _v1756
        _v1756 := arg450148
        let _v1757
        _v1757 := usr$rewardPerAttendee(_v1756)
        _result := _v1757
        leave
      }
      function usr$invokable_invoke$t_setMaintainer440130 (arg440132) {
        let _v1758
        _v1758 := arg440132
        usr$setMaintainer(_v1758)
        leave
      }
      function usr$invokable_invoke$t_setMetadataURI434720 (_v1759, _v1760) {
        let _v1761
        let _v1762
        _v1761 := _v1759
        _v1762 := _v1760
        usr$setMetadataURI(_v1761, _v1762)
        leave
      }
      function usr$invokable_invoke$t_totalHeld429515 () -> _result {
        let _v1763
        _v1763 := usr$totalHeld()
        _result := _v1763
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
      function usr$le$uint256 (x, y) -> _v1764 {
        let _v1765
        _v1765 := usr$Ord_gt$uint256(x, y)
        let _v1766
        _v1766 := usr$not(_v1765)
        _v1764 := _v1766
        leave
      }
      function usr$le$word (x, y) -> _v1767 {
        let _v1768
        _v1768 := usr$Ord_gt$word(x, y)
        let _v1769
        _v1769 := usr$not(_v1768)
        _v1767 := _v1769
        leave
      }
      function usr$lidx$storageLarrayLstringJJ_uint256_storageLstringJ (c, i) -> _result {
        let _v1770
        _v1770 := usr$LValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256(c, i)
        _result := _v1770
        leave
      }
      function usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ (c, i) -> _result {
        let _v1771
        _v1771 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus(c, i)
        _result := _v1771
        leave
      }
      function usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ (c, i) -> _result {
        let _v1772
        _v1772 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters(c, i)
        _result := _v1772
        leave
      }
      function usr$lidx$storageLmappingLuint256_EventRecJJ_uint256_storageLEventRecJ (c, i) -> _result {
        let _v1773
        _v1773 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec(c, i)
        _result := _v1773
        leave
      }
      function usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ (c, i) -> _result {
        let _v1774
        _v1774 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_mappingLaddress_AttendeeStatusJ(c, i)
        _result := _v1774
        leave
      }
      function usr$lidx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_storageLsumLunit_unitJJ (c, i) -> _result {
        let _v1775
        _v1775 := usr$LValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ(c, i)
        _result := _v1775
        leave
      }
      function usr$loadBytesFromStorage (slot, memPtr) -> _result {
        let pos
        pos := memPtr
        let slotValue
        let _v1776
        _v1776 := usr$sload(slot)
        slotValue := _v1776
        let length
        let _v1777
        _v1777 := usr$Div_div$word(slotValue, 2)
        length := _v1777
        let _v1778
        let _v1779
        _v1779 := usr$and_(slotValue, 1)
        let _v1780
        _v1780 := usr$tobool(_v1779)
        _v1778 := _v1780
        let _v1781
        let _v1782
        _v1782 := usr$not(_v1778)
        _v1781 := _v1782
        switch _v1781
          case false {}
          case true {let _v1783
                     _v1783 := usr$and_(length, 127)
                     length := _v1783}
        usr$mstore(pos, length)
        let _v1784
        _v1784 := usr$Add_add$word(pos, 32)
        pos := _v1784
        switch _v1778
          case false {let _v1785
                      _v1785 := usr$and_(slotValue, 115792089237316195423570985008687907853269984665640564039457584007913129639680)
                      usr$mstore(pos, _v1785)
                      let empty
                      let _v1786
                      _v1786 := usr$iszero(length)
                      empty := _v1786
                      let notzero
                      let _v1787
                      _v1787 := usr$iszero(empty)
                      notzero := _v1787
                      let _v1788
                      _v1788 := usr$Mul_mul$word(notzero, 32)
                      let _v1789
                      _v1789 := usr$Add_add$word(pos, _v1788)
                      _result := _v1789
                      leave}
          case true {let dataPos
                     let _v1790
                     _v1790 := usr$hash1(slot)
                     dataPos := _v1790
                     let i
                     i := 0
                     for {let _v1791 let _v1792 _v1791 := usr$lt$word(i, length)} _v1791 {_v1792 := usr$Add_add$word(i, 32) i := _v1792 _v1791 := usr$lt$word(i, length)}
                     {let _v1793
                      _v1793 := usr$Add_add$word(pos, i)
                      let _v1794
                      _v1794 := usr$sload(dataPos)
                      usr$mstore(_v1793, _v1794)
                      let _v1795
                      _v1795 := usr$Add_add$word(dataPos, 1)
                      dataPos := _v1795}
                     let _v1796
                     _v1796 := usr$Add_add$word(pos, i)
                     _result := _v1796
                     leave}
      }
      function usr$log2_ (a, b, c, d) { log2(a, b, c, d) }
      function usr$log3_ (a, b, c, d, e) { log3(a, b, c, d, e) }
      function usr$lt$uint256 (x, y) -> _v1797 {
        let _v1798
        _v1798 := usr$Ord_gt$uint256(y, x)
        _v1797 := _v1798
        leave
      }
      function usr$lt$word (x, y) -> _v1799 {
        let _v1800
        _v1800 := usr$Ord_gt$word(y, x)
        _v1799 := _v1800
        leave
      }
      function usr$main () -> _v1801 {
        usr$RunContract_exec$ContractLmethods_fbJ$pairLMethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446J_pairLMethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J_pairLMethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J_pairLMethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J_pairLMethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J_pairLMethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J_pairLMethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J_pairLMethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J_pairLMethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J_pairLMethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J_pairLMethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J_pairLMethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J_pairLMethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J_pairLMethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J_pairLMethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J_pairLMethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J_pairLMethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J_pairLMethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J_pairLMethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J_pairLMethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J_pairLMethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J_pairLMethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J_pairLMethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J_pairLMethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J_pairLMethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J_pairLMethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J_MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130JJJJJJJJJJJJJJJJJJJJJJJJJJJ_FallbackLPayable_unit_unit_t_fallback604097J()
      }
      function usr$maintainer () -> _result {
        let _v1802
        _v1802 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        _result := _v1802
        leave
      }
      function usr$mcopy (a, b, c) { mcopy(a, b, c) }
      function usr$metadataURI (eid) -> _result {
        let _v1803
        let _v1804
        let _v1805
        let _v1806
        let _v1807
        let _v1808
        let _v1809
        let _v1810
        let _v1811
        let _v1812
        let _v1813
        let _v1814
        let _v1815
        let _v1816
        let _v1817
        let _v1818
        _v1811, _v1812, _v1813, _v1814, _v1815, _v1816, _v1817, _v1818 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1803 := _v1811
        _v1804 := _v1812
        _v1805 := _v1813
        _v1806 := _v1814
        _v1807 := _v1815
        _v1808 := _v1816
        _v1809 := _v1817
        _v1810 := _v1818
        switch _v1803
          case false {usr$revertNotFound()
                      let _v1819
                      _v1819 := usr$ridx$storageLarrayLstringJJ_uint256_memoryLstringJ(4, 0)
                      _result := _v1819
                      leave}
          case true {let _v1820
                     _v1820 := usr$Sub_sub$uint256(eid, 1)
                     let _v1821
                     _v1821 := usr$ridx$storageLarrayLstringJJ_uint256_memoryLstringJ(4, _v1820)
                     _result := _v1821
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
        let _v1822
        let _v1823
        _v1823 := usr$Eq_eq$uint256(x, 0)
        _v1822 := _v1823
        switch _v1822
          case false {}
          case true {_result := 0
                     leave}
        let _v1824
        let _v1825
        _v1825 := usr$Mul_mul$uint256(x, y)
        _v1824 := _v1825
        let _v1826
        let _v1827
        _v1827 := usr$Div_div$uint256(_v1824, x)
        let _v1828
        _v1828 := usr$ne$uint256(_v1827, y)
        _v1826 := _v1828
        switch _v1826
          case false {}
          case true {usr$panic(17)}
        _result := _v1824
        leave
      }
      function usr$mulWord (l, r) -> _result {
        let _v1829
        _v1829 := usr$mul(l, r)
        _result := _v1829
        leave
      }
      function usr$ne$uint256 (x, y) -> _v1830 {
        let _v1831
        _v1831 := usr$Eq_eq$uint256(x, y)
        let _v1832
        _v1832 := usr$not(_v1831)
        _v1830 := _v1832
        leave
      }
      function usr$ne$word (x, y) -> _v1833 {
        let _v1834
        _v1834 := usr$Eq_eq$word(x, y)
        let _v1835
        _v1835 := usr$not(_v1834)
        _v1833 := _v1835
        leave
      }
      function usr$not (_v1836) -> _v1837 {
        switch _v1836
          case false {_v1837 := true
                      leave}
          case true {_v1837 := false
                     leave}
      }
      function usr$onlyOrganizerOf (org) {
        let _v1838
        _v1838 := usr$caller()
        let _v1839
        _v1839 := usr$Eq_eq$address(_v1838, org)
        usr$requireK(_v1839, 2403396036)
        leave
      }
      function usr$organizer (eid) -> _result {
        let _v1840
        let _v1841
        let _v1842
        let _v1843
        let _v1844
        let _v1845
        let _v1846
        let _v1847
        let _v1848
        let _v1849
        let _v1850
        let _v1851
        let _v1852
        let _v1853
        let _v1854
        let _v1855
        _v1848, _v1849, _v1850, _v1851, _v1852, _v1853, _v1854, _v1855 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1840 := _v1848
        _v1841 := _v1849
        _v1842 := _v1850
        _v1843 := _v1851
        _v1844 := _v1852
        _v1845 := _v1853
        _v1846 := _v1854
        _v1847 := _v1855
        switch _v1840
          case false {usr$revertNotFound()
                      _result := 0
                      leave}
          case true {_result := _v1841
                     leave}
      }
      function usr$out_of_bounds () {
        let _v1856
        let _v1857
        let _v1858
        _v1856 := false
        _v1857 := 3021082388
        usr$revertWithError(false, 3021082388, 911)
      }
      function usr$panic (code) {
        let p
        let _v1859
        _v1859 := usr$get_free_memory()
        p := _v1859
        usr$mstore(p, 1313373041)
        let _v1860
        _v1860 := usr$Add_add$word(p, 32)
        usr$mstore(_v1860, code)
        let _v1861
        _v1861 := usr$Add_add$word(p, 28)
        usr$revert_(_v1861, 36)
      }
      function usr$readStorage$AttendeeStatus (x) -> _v1862, _v1863, _v1864, _v1865 {
        let _v1866
        let _v1867
        let _v1868
        let _v1869
        _v1866, _v1867, _v1868, _v1869 := usr$CanStore_load$storageLAttendeeStatusJ(x)
        _v1862 := _v1866
        _v1863 := _v1867
        _v1864 := _v1868
        _v1865 := _v1869
        leave
      }
      function usr$readStorage$Counters (x) -> _v1870, _v1871, _v1872, _v1873 {
        let _v1874
        let _v1875
        let _v1876
        let _v1877
        _v1874, _v1875, _v1876, _v1877 := usr$CanStore_load$storageLCountersJ(x)
        _v1870 := _v1874
        _v1871 := _v1875
        _v1872 := _v1876
        _v1873 := _v1877
        leave
      }
      function usr$readStorage$EventRec (x) -> _v1878, _v1879, _v1880, _v1881, _v1882, _v1883, _v1884, _v1885 {
        let _v1886
        let _v1887
        let _v1888
        let _v1889
        let _v1890
        let _v1891
        let _v1892
        let _v1893
        _v1886, _v1887, _v1888, _v1889, _v1890, _v1891, _v1892, _v1893 := usr$CanStore_load$storageLEventRecJ(x)
        _v1878 := _v1886
        _v1879 := _v1887
        _v1880 := _v1888
        _v1881 := _v1889
        _v1882 := _v1890
        _v1883 := _v1891
        _v1884 := _v1892
        _v1885 := _v1893
        leave
      }
      function usr$readStorage$sumLunit_unitJ (x) -> _v1894 {
        let _v1895
        _v1895 := usr$CanStore_load$storageLsumLf_gJJ$unit_unit(x)
        _v1894 := _v1895
        leave
      }
      function usr$register (eid) {
        let _v1896
        let _v1897
        let _v1898
        let _v1899
        let _v1900
        let _v1901
        let _v1902
        let _v1903
        let _v1904
        let _v1905
        let _v1906
        let _v1907
        let _v1908
        let _v1909
        let _v1910
        let _v1911
        _v1904, _v1905, _v1906, _v1907, _v1908, _v1909, _v1910, _v1911 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v1896 := _v1904
        _v1897 := _v1905
        _v1898 := _v1906
        _v1899 := _v1907
        _v1900 := _v1908
        _v1901 := _v1909
        _v1902 := _v1910
        _v1903 := _v1911
        switch _v1896
          case false {usr$revertNotFound()}
          case true {let _v1912
                     _v1912 := usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ(5, eid)
                     let _v1913
                     let _v1914
                     let _v1915
                     let _v1916
                     _v1913, _v1914, _v1915, _v1916 := usr$deriveState(_v1912, _v1900, _v1901, _v1902)
                     let _v1917
                     _v1917 := usr$stateOrd(_v1913, _v1914, _v1915, _v1916)
                     let _v1918
                     _v1918 := usr$Eq_eq$uint256(_v1917, 0)
                     usr$requireK(_v1918, 801245683)
                     let _v1919
                     _v1919 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1920
                     _v1920 := usr$caller()
                     let _v1921
                     let _v1922
                     let _v1923
                     let _v1924
                     _v1921, _v1922, _v1923, _v1924 := usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus(_v1919, _v1920)
                     usr$registerGuard(_v1921, _v1922, _v1923, _v1924)
                     let _v1925
                     let _v1926
                     _v1926 := usr$caller_value()
                     let _v1927
                     _v1927 := usr$ne$uint256(_v1926, _v1898)
                     _v1925 := _v1927
                     switch _v1925
                       case false {}
                       case true {let _v1928
                                  _v1928 := usr$Typedef_rep$uint256(_v1898)
                                  let _v1929
                                  _v1929 := usr$caller_value()
                                  let _v1930
                                  _v1930 := usr$Typedef_rep$uint256(_v1929)
                                  usr$revertWith2(3128224419, _v1928, _v1930)}
                     let _v1931
                     let _v1932
                     let _v1933
                     let _v1934
                     let _v1935
                     let _v1936
                     let _v1937
                     let _v1938
                     _v1935, _v1936, _v1937, _v1938 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v1931 := _v1935
                     _v1932 := _v1936
                     _v1933 := _v1937
                     _v1934 := _v1938
                     let _v1939
                     let _v1940
                     _v1940 := usr$Ord_gt$uint256(_v1903, 0)
                     let _v1941
                     _v1941 := usr$ge$uint256(_v1931, _v1903)
                     let _v1942
                     _v1942 := usr$and(_v1940, _v1941)
                     _v1939 := _v1942
                     switch _v1939
                       case false {}
                       case true {usr$fail(4220419778)}
                     let _v1943
                     _v1943 := usr$lidx$storageLmappingLuint256_mappingLaddress_AttendeeStatusJJJ_uint256_storageLmappingLaddress_AttendeeStatusJJ(6, eid)
                     let _v1944
                     _v1944 := usr$caller()
                     let _v1945
                     _v1945 := usr$lidx$storageLmappingLaddress_AttendeeStatusJJ_address_storageLAttendeeStatusJ(_v1943, _v1944)
                     usr$Assign_assign$a$storageLAttendeeStatusJ_AttendeeStatus(_v1945, true, false, 911, 911)
                     let _v1946
                     _v1946 := usr$lidx$storageLmappingLuint256_CountersJJ_uint256_storageLCountersJ(7, eid)
                     let _v1947
                     _v1947 := usr$Add_add$uint256(_v1931, 1)
                     let _v1948
                     _v1948 := usr$addCk(_v1934, _v1898)
                     usr$Assign_assign$a$storageLCountersJ_Counters(_v1946, _v1947, _v1932, _v1933, _v1948)
                     let _v1949
                     _v1949 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1950
                     _v1950 := usr$addCk(_v1949, _v1898)
                     usr$Assign_assign$a$storageLuint256J_uint256(2, _v1950)
                     let _v1951
                     _v1951 := usr$balanceSelf()
                     let _v1952
                     _v1952 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
                     let _v1953
                     _v1953 := usr$ge$uint256(_v1951, _v1952)
                     usr$solAssert(_v1953)
                     let _v1954
                     _v1954 := usr$Typedef_rep$uint256(eid)
                     let _v1955
                     _v1955 := usr$caller()
                     let _v1956
                     _v1956 := usr$Typedef_rep$address(_v1955)
                     usr$emitLog3(49232042970260620028455006004981854637665831504696444699019501292186195787732, _v1954, _v1956)}
      }
      function usr$registerGuard (_v1957, _v1958, _v1959, _v1960) {
        switch _v1957
          case false {leave}
          case true {switch _v1958
                       case false {usr$fail(981587708)}
                       case true {switch _v1959
                                    case false {leave}
                                    case true {switch _v1960
                                                 case false {usr$revertWith2(3281772918, 3, 0)}
                                                 case true {usr$revertWith2(3281772918, 4, 0)}}}}
      }
      function usr$registeredCount (eid) -> _result {
        let _v1961
        let _v1962
        let _v1963
        let _v1964
        let _v1965
        let _v1966
        let _v1967
        let _v1968
        _v1965, _v1966, _v1967, _v1968 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
        _v1961 := _v1965
        _v1962 := _v1966
        _v1963 := _v1967
        _v1964 := _v1968
        _result := _v1961
        leave
      }
      function usr$require (_v1969, _v1970, _v1971, _v1972) {
        let _v1973
        let _v1974
        _v1974 := usr$not(_v1969)
        _v1973 := _v1974
        switch _v1973
          case false {}
          case true {usr$revertWithError(_v1970, _v1971, _v1972)}
      }
      function usr$requireCheckInOpen (_v1975, start, end_, dispute) {
        let _v1976
        let _v1977
        let _v1978
        let _v1979
        let _v1980
        _v1977, _v1978, _v1979, _v1980 := usr$deriveState(_v1975, start, end_, dispute)
        let _v1981
        _v1981 := usr$stateOrd(_v1977, _v1978, _v1979, _v1980)
        _v1976 := _v1981
        let _v1982
        let _v1983
        _v1983 := usr$ne$uint256(_v1976, 1)
        let _v1984
        _v1984 := usr$ne$uint256(_v1976, 2)
        let _v1985
        _v1985 := usr$and(_v1983, _v1984)
        _v1982 := _v1985
        switch _v1982
          case false {}
          case true {usr$fail(3988669644)}
      }
      function usr$requireK (_v1986, e) {
        usr$require(_v1986, false, e, 911)
      }
      function usr$requireStatus (_v1987, _v1988, _v1989, _v1990, expected) {
        let cur
        let _v1991
        _v1991 := usr$statusOrd(_v1987, _v1988, _v1989, _v1990)
        let _v1992
        _v1992 := usr$Typedef_rep$uint256(_v1991)
        cur := _v1992
        let _v1993
        let _v1994
        _v1994 := usr$ne$word(cur, expected)
        _v1993 := _v1994
        switch _v1993
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
        let _v1995
        _v1995 := usr$get_free_memory()
        p := _v1995
        usr$mstore(p, e)
        let _v1996
        _v1996 := usr$Add_add$word(p, 32)
        usr$mstore(_v1996, 32)
        let sptr
        let _v1997
        _v1997 := usr$Typedef_rep$memoryLtJ$string(msg)
        sptr := _v1997
        let len
        let _v1998
        _v1998 := usr$mload(sptr)
        len := _v1998
        let _v1999
        _v1999 := usr$Add_add$word(p, 64)
        usr$mstore(_v1999, len)
        let padded
        let _v2000
        _v2000 := usr$Add_add$word(len, 31)
        let _v2001
        _v2001 := usr$shr(5, _v2000)
        let _v2002
        _v2002 := usr$Mul_mul$word(_v2001, 32)
        padded := _v2002
        for {let i i := 0 let _v2003 let _v2004 _v2003 := usr$lt$word(i, padded)} _v2003 {_v2004 := usr$Add_add$word(i, 32) i := _v2004 _v2003 := usr$lt$word(i, padded)}
        {let _v2005
         _v2005 := usr$Add_add$word(p, 96)
         let _v2006
         _v2006 := usr$Add_add$word(_v2005, i)
         let _v2007
         _v2007 := usr$Add_add$word(sptr, 32)
         let _v2008
         _v2008 := usr$Add_add$word(_v2007, i)
         let _v2009
         _v2009 := usr$mload(_v2008)
         usr$mstore(_v2006, _v2009)}
        let _v2010
        _v2010 := usr$Add_add$word(p, 28)
        let _v2011
        _v2011 := usr$Add_add$word(68, padded)
        usr$revert_(_v2010, _v2011)
      }
      function usr$revertWith2 (e, a, b) {
        let p
        let _v2012
        _v2012 := usr$get_free_memory()
        p := _v2012
        usr$mstore(p, e)
        let _v2013
        _v2013 := usr$Add_add$word(p, 32)
        usr$mstore(_v2013, a)
        let _v2014
        _v2014 := usr$Add_add$word(p, 64)
        usr$mstore(_v2014, b)
        let _v2015
        _v2015 := usr$Add_add$word(p, 28)
        usr$revert_(_v2015, 68)
      }
      function usr$revertWithError (_v2016, _v2017, _v2018) {
        switch _v2016
          case false {usr$mstore(0, _v2017)
                      usr$revert_(28, 4)}
          case true {switch _v2017
                       case false {usr$revert_(0, 0)}
                       case true {let msg_
                                  let _v2019
                                  _v2019 := usr$Typedef_rep$memoryLtJ$string(_v2018)
                                  msg_ := _v2019
                                  let _v2020
                                  _v2020 := usr$Add_add$word(msg_, 32)
                                  let _v2021
                                  _v2021 := usr$mload(msg_)
                                  usr$revert_(_v2020, _v2021)}}
      }
      function usr$revert_ (a, b) { revert(a, b) }
      function usr$rewardPerAttendee (eid) -> _result {
        let _v2022
        let _v2023
        let _v2024
        let _v2025
        let _v2026
        let _v2027
        let _v2028
        let _v2029
        let _v2030
        let _v2031
        let _v2032
        let _v2033
        let _v2034
        let _v2035
        let _v2036
        let _v2037
        _v2030, _v2031, _v2032, _v2033, _v2034, _v2035, _v2036, _v2037 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2022 := _v2030
        _v2023 := _v2031
        _v2024 := _v2032
        _v2025 := _v2033
        _v2026 := _v2034
        _v2027 := _v2035
        _v2028 := _v2036
        _v2029 := _v2037
        switch _v2022
          case false {usr$revertNotFound()
                      _result := 0
                      leave}
          case true {let _v2038
                     let _v2039
                     let _v2040
                     let _v2041
                     let _v2042
                     let _v2043
                     let _v2044
                     let _v2045
                     _v2042, _v2043, _v2044, _v2045 := usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters(7, eid)
                     _v2038 := _v2042
                     _v2039 := _v2043
                     _v2040 := _v2044
                     _v2041 := _v2045
                     let _v2046
                     _v2046 := usr$calcReward(_v2038, _v2039, _v2024)
                     _result := _v2046
                     leave}
      }
      function usr$ridx$storageLarrayLstringJJ_uint256_memoryLstringJ (c, i) -> _result {
        let _v2047
        _v2047 := usr$RValueIdxAccess_lookup$pairLstorageLarrayLaJJ_iJ$string_uint256_memoryLstringJ(c, i)
        _result := _v2047
        leave
      }
      function usr$ridx$storageLmappingLaddress_AttendeeStatusJJ_address_AttendeeStatus (c, i) -> _v2048, _v2049, _v2050, _v2051 {
        let _v2052
        let _v2053
        let _v2054
        let _v2055
        _v2052, _v2053, _v2054, _v2055 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$address_AttendeeStatus(c, i)
        _v2048 := _v2052
        _v2049 := _v2053
        _v2050 := _v2054
        _v2051 := _v2055
        leave
      }
      function usr$ridx$storageLmappingLuint256_CountersJJ_uint256_Counters (c, i) -> _v2056, _v2057, _v2058, _v2059 {
        let _v2060
        let _v2061
        let _v2062
        let _v2063
        _v2060, _v2061, _v2062, _v2063 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_Counters(c, i)
        _v2056 := _v2060
        _v2057 := _v2061
        _v2058 := _v2062
        _v2059 := _v2063
        leave
      }
      function usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec (c, i) -> _v2064, _v2065, _v2066, _v2067, _v2068, _v2069, _v2070, _v2071 {
        let _v2072
        let _v2073
        let _v2074
        let _v2075
        let _v2076
        let _v2077
        let _v2078
        let _v2079
        _v2072, _v2073, _v2074, _v2075, _v2076, _v2077, _v2078, _v2079 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_EventRec(c, i)
        _v2064 := _v2072
        _v2065 := _v2073
        _v2066 := _v2074
        _v2067 := _v2075
        _v2068 := _v2076
        _v2069 := _v2077
        _v2070 := _v2078
        _v2071 := _v2079
        leave
      }
      function usr$ridx$storageLmappingLuint256_sumLunit_unitJJJ_uint256_sumLunit_unitJ (c, i) -> _v2080 {
        let _v2081
        _v2081 := usr$RValueIdxAccess_lookup$pairLstorageLmappingLi_aJJ_iJ$uint256_sumLunit_unitJ(c, i)
        _v2080 := _v2081
        leave
      }
      function usr$round_up_to_mul_of_32 (value) -> _result {
        let _v2082
        _v2082 := usr$Add_add$word(value, 31)
        let _v2083
        _v2083 := usr$and_(_v2082, 115792089237316195423570985008687907853269984665640564039457584007913129639904)
        _result := _v2083
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_DUST_CLAIM_TIMEOUT_NonPayable_unit_uint256_t_DUST_CLAIM_TIMEOUT593002J () -> _v2084 {
        let candidate
        candidate := 412119810
        let selector
        let _v2085
        _v2085 := usr$calldataload(0)
        let _v2086
        _v2086 := usr$shr(224, _v2085)
        selector := _v2086
        let _v2087
        _v2087 := usr$Eq_eq$word(selector, 412119810)
        _v2084 := _v2087
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_MAX_BATCH_SIZE_NonPayable_unit_uint256_t_MAX_BATCH_SIZE587826J () -> _v2088 {
        let candidate
        candidate := 3487298132
        let selector
        let _v2089
        _v2089 := usr$calldataload(0)
        let _v2090
        _v2090 := usr$shr(224, _v2089)
        selector := _v2090
        let _v2091
        _v2091 := usr$Eq_eq$word(selector, 3487298132)
        _v2088 := _v2091
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_MIN_CANCELLATION_BUFFER_NonPayable_unit_uint256_t_MIN_CANCELLATION_BUFFER582668J () -> _v2092 {
        let candidate
        candidate := 2832447516
        let selector
        let _v2093
        _v2093 := usr$calldataload(0)
        let _v2094
        _v2094 := usr$shr(224, _v2093)
        selector := _v2094
        let _v2095
        _v2095 := usr$Eq_eq$word(selector, 2832447516)
        _v2092 := _v2095
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_attendees_NonPayable_pairLuint256_addressJ_uint256_t_attendees577523J () -> _v2096 {
        let candidate
        candidate := 119447252
        let selector
        let _v2097
        _v2097 := usr$calldataload(0)
        let _v2098
        _v2098 := usr$shr(224, _v2097)
        selector := _v2098
        let _v2099
        _v2099 := usr$Eq_eq$word(selector, 119447252)
        _v2096 := _v2099
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelEvent_NonPayable_uint256_unit_t_cancelEvent564882J () -> _v2100 {
        let candidate
        candidate := 1063893693
        let selector
        let _v2101
        _v2101 := usr$calldataload(0)
        let _v2102
        _v2102 := usr$shr(224, _v2101)
        selector := _v2102
        let _v2103
        _v2103 := usr$Eq_eq$word(selector, 1063893693)
        _v2100 := _v2103
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancel_NonPayable_uint256_unit_t_cancel572080J () -> _v2104 {
        let candidate
        candidate := 1088786149
        let selector
        let _v2105
        _v2105 := usr$calldataload(0)
        let _v2106
        _v2106 := usr$shr(224, _v2105)
        selector := _v2106
        let _v2107
        _v2107 := usr$Eq_eq$word(selector, 1088786149)
        _v2104 := _v2107
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_cancelled_NonPayable_uint256_sumLunit_unitJ_t_cancelled558964J () -> _v2108 {
        let candidate
        candidate := 3763387991
        let selector
        let _v2109
        _v2109 := usr$calldataload(0)
        let _v2110
        _v2110 := usr$shr(224, _v2109)
        selector := _v2110
        let _v2111
        _v2111 := usr$Eq_eq$word(selector, 3763387991)
        _v2108 := _v2111
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkIn_NonPayable_pairLuint256_addressJ_unit_t_checkIn553620J () -> _v2112 {
        let candidate
        candidate := 2911723263
        let selector
        let _v2113
        _v2113 := usr$calldataload(0)
        let _v2114
        _v2114 := usr$shr(224, _v2113)
        selector := _v2114
        let _v2115
        _v2115 := usr$Eq_eq$word(selector, 2911723263)
        _v2112 := _v2115
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_checkedInCount_NonPayable_uint256_uint256_t_checkedInCount536682J () -> _v2116 {
        let candidate
        candidate := 4280154022
        let selector
        let _v2117
        _v2117 := usr$calldataload(0)
        let _v2118
        _v2118 := usr$shr(224, _v2117)
        selector := _v2118
        let _v2119
        _v2119 := usr$Eq_eq$word(selector, 4280154022)
        _v2116 := _v2119
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimDust_NonPayable_uint256_unit_t_claimDust524010J () -> _v2120 {
        let candidate
        candidate := 798921810
        let selector
        let _v2121
        _v2121 := usr$calldataload(0)
        let _v2122
        _v2122 := usr$shr(224, _v2121)
        selector := _v2122
        let _v2123
        _v2123 := usr$Eq_eq$word(selector, 798921810)
        _v2120 := _v2123
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimRefund_NonPayable_uint256_unit_t_claimRefund517003J () -> _v2124 {
        let candidate
        candidate := 1534832484
        let selector
        let _v2125
        _v2125 := usr$calldataload(0)
        let _v2126
        _v2126 := usr$shr(224, _v2125)
        selector := _v2126
        let _v2127
        _v2127 := usr$Eq_eq$word(selector, 1534832484)
        _v2124 := _v2127
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claim_NonPayable_uint256_unit_t_claim531385J () -> _v2128 {
        let candidate
        candidate := 932579317
        let selector
        let _v2129
        _v2129 := usr$calldataload(0)
        let _v2130
        _v2130 := usr$shr(224, _v2129)
        selector := _v2130
        let _v2131
        _v2131 := usr$Eq_eq$word(selector, 932579317)
        _v2128 := _v2131
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_claimedCount_NonPayable_uint256_uint256_t_claimedCount509695J () -> _v2132 {
        let candidate
        candidate := 3399060013
        let selector
        let _v2133
        _v2133 := usr$calldataload(0)
        let _v2134
        _v2134 := usr$shr(224, _v2133)
        selector := _v2134
        let _v2135
        _v2135 := usr$Eq_eq$word(selector, 3399060013)
        _v2132 := _v2135
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_createEvent_NonPayable_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_memoryLstringJJJJJJJ_uint256_t_createEvent504446J () -> _v2136 {
        let candidate
        candidate := 3798804022
        let selector
        let _v2137
        _v2137 := usr$calldataload(0)
        let _v2138
        _v2138 := usr$shr(224, _v2137)
        selector := _v2138
        let _v2139
        _v2139 := usr$Eq_eq$word(selector, 3798804022)
        _v2136 := _v2139
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_eventCount_NonPayable_unit_uint256_t_eventCount498664J () -> _v2140 {
        let candidate
        candidate := 1908289098
        let selector
        let _v2141
        _v2141 := usr$calldataload(0)
        let _v2142
        _v2142 := usr$shr(224, _v2141)
        selector := _v2142
        let _v2143
        _v2143 := usr$Eq_eq$word(selector, 1908289098)
        _v2140 := _v2143
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_getEvent_NonPayable_uint256_pairLaddress_pairLuint256_pairLuint256_pairLuint256_pairLuint256_pairLuint256_uint256JJJJJJ_t_getEvent493628J () -> _v2144 {
        let candidate
        candidate := 1830323424
        let selector
        let _v2145
        _v2145 := usr$calldataload(0)
        let _v2146
        _v2146 := usr$shr(224, _v2145)
        selector := _v2146
        let _v2147
        _v2147 := usr$Eq_eq$word(selector, 1830323424)
        _v2144 := _v2147
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_getState_NonPayable_uint256_uint256_t_getState488429J () -> _v2148 {
        let candidate
        candidate := 1154068264
        let selector
        let _v2149
        _v2149 := usr$calldataload(0)
        let _v2150
        _v2150 := usr$shr(224, _v2149)
        selector := _v2150
        let _v2151
        _v2151 := usr$Eq_eq$word(selector, 1154068264)
        _v2148 := _v2151
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_held_NonPayable_uint256_uint256_t_held483049J () -> _v2152 {
        let candidate
        candidate := 3739061976
        let selector
        let _v2153
        _v2153 := usr$calldataload(0)
        let _v2154
        _v2154 := usr$shr(224, _v2153)
        selector := _v2154
        let _v2155
        _v2155 := usr$Eq_eq$word(selector, 3739061976)
        _v2152 := _v2155
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_maintainer_NonPayable_unit_address_t_maintainer477915J () -> _v2156 {
        let candidate
        candidate := 2555433771
        let selector
        let _v2157
        _v2157 := usr$calldataload(0)
        let _v2158
        _v2158 := usr$shr(224, _v2157)
        selector := _v2158
        let _v2159
        _v2159 := usr$Eq_eq$word(selector, 2555433771)
        _v2156 := _v2159
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_metadataURI_NonPayable_uint256_memoryLstringJ_t_metadataURI472965J () -> _v2160 {
        let candidate
        candidate := 202913859
        let selector
        let _v2161
        _v2161 := usr$calldataload(0)
        let _v2162
        _v2162 := usr$shr(224, _v2161)
        selector := _v2162
        let _v2163
        _v2163 := usr$Eq_eq$word(selector, 202913859)
        _v2160 := _v2163
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_organizer_NonPayable_uint256_address_t_organizer467391J () -> _v2164 {
        let candidate
        candidate := 3962601843
        let selector
        let _v2165
        _v2165 := usr$calldataload(0)
        let _v2166
        _v2166 := usr$shr(224, _v2165)
        selector := _v2166
        let _v2167
        _v2167 := usr$Eq_eq$word(selector, 3962601843)
        _v2164 := _v2167
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_register_Payable_uint256_unit_t_register462360J () -> _v2168 {
        let candidate
        candidate := 4060567118
        let selector
        let _v2169
        _v2169 := usr$calldataload(0)
        let _v2170
        _v2170 := usr$shr(224, _v2169)
        selector := _v2170
        let _v2171
        _v2171 := usr$Eq_eq$word(selector, 4060567118)
        _v2168 := _v2171
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_registeredCount_NonPayable_uint256_uint256_t_registeredCount455191J () -> _v2172 {
        let candidate
        candidate := 2141081421
        let selector
        let _v2173
        _v2173 := usr$calldataload(0)
        let _v2174
        _v2174 := usr$shr(224, _v2173)
        selector := _v2174
        let _v2175
        _v2175 := usr$Eq_eq$word(selector, 2141081421)
        _v2172 := _v2175
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_rewardPerAttendee_NonPayable_uint256_uint256_t_rewardPerAttendee450146J () -> _v2176 {
        let candidate
        candidate := 2995498174
        let selector
        let _v2177
        _v2177 := usr$calldataload(0)
        let _v2178
        _v2178 := usr$shr(224, _v2177)
        selector := _v2178
        let _v2179
        _v2179 := usr$Eq_eq$word(selector, 2995498174)
        _v2176 := _v2179
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMaintainer_NonPayable_address_unit_t_setMaintainer440130J () -> _v2180 {
        let candidate
        candidate := 334126377
        let selector
        let _v2181
        _v2181 := usr$calldataload(0)
        let _v2182
        _v2182 := usr$shr(224, _v2181)
        selector := _v2182
        let _v2183
        _v2183 := usr$Eq_eq$word(selector, 334126377)
        _v2180 := _v2183
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_setMetadataURI_NonPayable_pairLuint256_memoryLstringJJ_unit_t_setMetadataURI434720J () -> _v2184 {
        let candidate
        candidate := 142462612
        let selector
        let _v2185
        _v2185 := usr$calldataload(0)
        let _v2186
        _v2186 := usr$shr(224, _v2185)
        selector := _v2186
        let _v2187
        _v2187 := usr$Eq_eq$word(selector, 142462612)
        _v2184 := _v2187
        leave
      }
      function usr$selector_matches$MethodLDispatchNameTy_Kodyl_totalHeld_NonPayable_unit_uint256_t_totalHeld429515J () -> _v2188 {
        let candidate
        candidate := 4097623923
        let selector
        let _v2189
        _v2189 := usr$calldataload(0)
        let _v2190
        _v2190 := usr$shr(224, _v2189)
        selector := _v2190
        let _v2191
        _v2191 := usr$Eq_eq$word(selector, 4097623923)
        _v2188 := _v2191
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
        let _v2192
        _v2192 := usr$gas()
        let _v2193
        _v2193 := usr$Typedef_rep$address(dst)
        let _v2194
        _v2194 := usr$Typedef_rep$uint256(wad)
        let _v2195
        _v2195 := usr$call(_v2192, _v2193, _v2194, 0, 0, 0, 0)
        ret := _v2195
        let _v2196
        _v2196 := usr$ne$word(ret, 0)
        usr$requireK(_v2196, 2428038168)
      }
      function usr$setMaintainer (newMaintainer) {
        let _v2197
        _v2197 := usr$caller()
        let _v2198
        _v2198 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        let _v2199
        _v2199 := usr$Eq_eq$address(_v2197, _v2198)
        usr$requireK(_v2199, 3935194805)
        let _v2200
        let _v2201
        _v2201 := usr$Typedef_rep$address(newMaintainer)
        let _v2202
        _v2202 := usr$Eq_eq$word(_v2201, 0)
        _v2200 := _v2202
        switch _v2200
          case false {}
          case true {let _v2203
                     _v2203 := usr$__strlit_0()
                     usr$revertStr(3276808962, _v2203)}
        let _v2204
        let _v2205
        _v2205 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        let _v2206
        _v2206 := usr$Eq_eq$address(newMaintainer, _v2205)
        _v2204 := _v2206
        switch _v2204
          case false {}
          case true {let _v2207
                     _v2207 := usr$__strlit_1()
                     usr$revertStr(3276808962, _v2207)}
        let _v2208
        let _v2209
        _v2209 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_maintainer_sel_address_unit()
        _v2208 := _v2209
        usr$Assign_assign$a$storageLaddressJ_address(0, newMaintainer)
        let _v2210
        _v2210 := usr$Typedef_rep$address(_v2208)
        let _v2211
        _v2211 := usr$Typedef_rep$address(newMaintainer)
        usr$emitLog3(10544129918642067278015250259818348999806374263767378799394942176964542114757, _v2210, _v2211)
      }
      function usr$setMetadataURI (eid, newUri) {
        let _v2212
        let _v2213
        let _v2214
        let _v2215
        let _v2216
        let _v2217
        let _v2218
        let _v2219
        let _v2220
        let _v2221
        let _v2222
        let _v2223
        let _v2224
        let _v2225
        let _v2226
        let _v2227
        _v2220, _v2221, _v2222, _v2223, _v2224, _v2225, _v2226, _v2227 := usr$ridx$storageLmappingLuint256_EventRecJJ_uint256_EventRec(3, eid)
        _v2212 := _v2220
        _v2213 := _v2221
        _v2214 := _v2222
        _v2215 := _v2223
        _v2216 := _v2224
        _v2217 := _v2225
        _v2218 := _v2226
        _v2219 := _v2227
        switch _v2212
          case false {usr$revertNotFound()}
          case true {usr$onlyOrganizerOf(_v2213)
                     let _v2228
                     _v2228 := usr$Sub_sub$uint256(eid, 1)
                     let _v2229
                     _v2229 := usr$lidx$storageLarrayLstringJJ_uint256_storageLstringJ(4, _v2228)
                     usr$Assign_assign$a$storageLstringJ_memoryLstringJ(_v2229, newUri)
                     let _v2230
                     _v2230 := usr$Typedef_rep$uint256(eid)
                     usr$emitLog2Str(31466384846993879489896657419060636725351630481215761739972181624334831612681, _v2230, newUri)}
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
      function usr$solAssert (_v2231) {
        let _v2232
        let _v2233
        _v2233 := usr$not(_v2231)
        _v2232 := _v2233
        switch _v2232
          case false {}
          case true {usr$panic(1)}
      }
      function usr$sstore (a, b) { sstore(a, b) }
      function usr$stateOrd (_v2234, _v2235, _v2236, _v2237) -> _result {
        switch _v2234
          case false {_result := 0
                      leave}
          case true {switch _v2235
                       case false {_result := 1
                                   leave}
                       case true {switch _v2236
                                    case false {_result := 2
                                                leave}
                                    case true {switch _v2237
                                                 case false {_result := 3
                                                             leave}
                                                 case true {_result := 4
                                                            leave}}}}
      }
      function usr$statusOrd (_v2238, _v2239, _v2240, _v2241) -> _result {
        switch _v2238
          case false {_result := 0
                      leave}
          case true {switch _v2239
                       case false {_result := 1
                                   leave}
                       case true {switch _v2240
                                    case false {_result := 2
                                                leave}
                                    case true {switch _v2241
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
        let _v2242
        let _v2243
        _v2243 := usr$Ord_gt$uint256(y, x)
        _v2242 := _v2243
        switch _v2242
          case false {}
          case true {usr$panic(17)}
        let _v2244
        _v2244 := usr$Sub_sub$uint256(x, y)
        _result := _v2244
        leave
      }
      function usr$subWord (l, r) -> _result {
        let _v2245
        _v2245 := usr$sub(l, r)
        _result := _v2245
        leave
      }
      function usr$timeNow () -> _result {
        let _v2246
        _v2246 := usr$timestamp()
        _result := _v2246
        leave
      }
      function usr$timestamp () -> _result {
        let res
        res := timestamp()
        _result := res
        leave
      }
      function usr$tobool (x) -> _v2247 {
        switch x
          case 0 {_v2247 := false
                  leave}
        default {_v2247 := true
                 leave}
      }
      function usr$totalHeld () -> _result {
        let _v2248
        _v2248 := usr$RVA_acc$MemberAccessProxyLContractStorageLcxtJ_fieldSelector_loadType_offsetTypeJ$KodylCxt_Kodyl_totalHeld_sel_uint256_pairLaddress_pairLuint256_unitJJ()
        _result := _v2248
        leave
      }
      function usr$validateEventParams (depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod) {
        let _v2249
        let _v2250
        _v2250 := usr$Eq_eq$uint256(depositAmount, 0)
        _v2249 := _v2250
        switch _v2249
          case false {}
          case true {let _v2251
                     _v2251 := usr$__strlit_2()
                     usr$revertStr(3276808962, _v2251)}
        let _v2252
        let _v2253
        _v2253 := usr$timeNow()
        let _v2254
        _v2254 := usr$le$uint256(eventStart, _v2253)
        _v2252 := _v2254
        switch _v2252
          case false {}
          case true {let _v2255
                     _v2255 := usr$__strlit_3()
                     usr$revertStr(3276808962, _v2255)}
        let _v2256
        let _v2257
        _v2257 := usr$le$uint256(eventEnd, eventStart)
        _v2256 := _v2257
        switch _v2256
          case false {}
          case true {let _v2258
                     _v2258 := usr$__strlit_4()
                     usr$revertStr(3276808962, _v2258)}
        let _v2259
        let _v2260
        _v2260 := usr$addCk(cancellationDeadline, 7200)
        let _v2261
        _v2261 := usr$Ord_gt$uint256(_v2260, eventStart)
        _v2259 := _v2261
        switch _v2259
          case false {}
          case true {let _v2262
                     _v2262 := usr$__strlit_5()
                     usr$revertStr(3276808962, _v2262)}
        let _v2263
        let _v2264
        _v2264 := usr$timeNow()
        let _v2265
        _v2265 := usr$le$uint256(cancellationDeadline, _v2264)
        _v2263 := _v2265
        switch _v2263
          case false {}
          case true {let _v2266
                     _v2266 := usr$__strlit_6()
                     usr$revertStr(3276808962, _v2266)}
        let _v2267
        let _v2268
        _v2268 := usr$lt$uint256(disputePeriod, 3600)
        _v2267 := _v2268
        switch _v2267
          case false {}
          case true {let _v2269
                     _v2269 := usr$__strlit_7()
                     usr$revertStr(3276808962, _v2269)}
        let _v2270
        let _v2271
        _v2271 := usr$Ord_gt$uint256(disputePeriod, 2592000)
        _v2270 := _v2271
        switch _v2270
          case false {}
          case true {let _v2272
                     _v2272 := usr$__strlit_8()
                     usr$revertStr(3276808962, _v2272)}
      }
      function usr$zeroize_memory (ptr, len) {
        let end_ptr
        let _v2273
        _v2273 := usr$Add_add$word(ptr, len)
        end_ptr := _v2273
        for {let i i := 0 let _v2274 let _v2275 let _v2276 _v2274 := usr$Div_div$word(len, 32) _v2275 := usr$lt$word(i, _v2274)} _v2275 {_v2276 := usr$Add_add$word(i, 1) i := _v2276 _v2274 := usr$Div_div$word(len, 32) _v2275 := usr$lt$word(i, _v2274)}
        {usr$mstore(ptr, 0)
         let _v2277
         _v2277 := usr$Add_add$word(ptr, 32)
         ptr := _v2277}
        let _v2278
        _v2278 := usr$Sub_sub$word(end_ptr, ptr)
        usr$mcopy(ptr, 96, _v2278)
      }
      let _mainresult := usr$main()
      mstore(0, _mainresult)
      return(0, 32)
    }
  }
}