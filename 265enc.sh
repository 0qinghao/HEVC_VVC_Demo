./bin/265SrcEnc -c ./cfg_hevc/encoder_intra_main_LL.cfg -c ./cfg_sequence/snapshot265Src.cfg &
./bin/265NewEnc -c ./cfg_hevc/encoder_intra_main_LL.cfg -c ./cfg_sequence/snapshot265New.cfg &
wait
