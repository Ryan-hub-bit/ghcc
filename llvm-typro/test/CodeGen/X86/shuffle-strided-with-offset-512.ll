; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+avx512vl,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512BWVL

define void @shuffle_v64i8_to_v32i8_1(<64 x i8>* %L, <32 x i8>* %S) nounwind {
; AVX512F-LABEL: shuffle_v64i8_to_v32i8_1:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[u,u,u,u,u,u,u,u,1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31]
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31,u,u,u,u,u,u,u,u]
; AVX512F-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX512F-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512F-NEXT:    vmovdqa %ymm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v64i8_to_v32i8_1:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512VL-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[u,u,u,u,u,u,u,u,1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31]
; AVX512VL-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31,u,u,u,u,u,u,u,u]
; AVX512VL-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,2,5,7]
; AVX512VL-NEXT:    vpermi2q %ymm1, %ymm0, %ymm2
; AVX512VL-NEXT:    vmovdqa %ymm2, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v64i8_to_v32i8_1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512BW-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[u,u,u,u,u,u,u,u,1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31]
; AVX512BW-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX512BW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512BW-NEXT:    vmovdqa %ymm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v64i8_to_v32i8_1:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512BWVL-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[u,u,u,u,u,u,u,u,1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31]
; AVX512BWVL-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u,17,19,21,23,25,27,29,31,u,u,u,u,u,u,u,u]
; AVX512BWVL-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,2,5,7]
; AVX512BWVL-NEXT:    vpermi2q %ymm1, %ymm0, %ymm2
; AVX512BWVL-NEXT:    vmovdqa %ymm2, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <32 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31, i32 33, i32 35, i32 37, i32 39, i32 41, i32 43, i32 45, i32 47, i32 49, i32 51, i32 53, i32 55, i32 57, i32 59, i32 61, i32 63>
  store <32 x i8> %strided.vec, <32 x i8>* %S
  ret void
}

define void @shuffle_v32i16_to_v16i16_1(<32 x i16>* %L, <16 x i16>* %S) nounwind {
; AVX512F-LABEL: shuffle_v32i16_to_v16i16_1:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[6,7,2,3,4,5,6,7,2,3,6,7,10,11,14,15,22,23,18,19,20,21,22,23,18,19,22,23,26,27,30,31]
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[2,3,6,7,10,11,14,15,14,15,10,11,12,13,14,15,18,19,22,23,26,27,30,31,30,31,26,27,28,29,30,31]
; AVX512F-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX512F-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512F-NEXT:    vmovdqa %ymm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v32i16_to_v16i16_1:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512VL-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[6,7,2,3,4,5,6,7,2,3,6,7,10,11,14,15,22,23,18,19,20,21,22,23,18,19,22,23,26,27,30,31]
; AVX512VL-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[2,3,6,7,10,11,14,15,14,15,10,11,12,13,14,15,18,19,22,23,26,27,30,31,30,31,26,27,28,29,30,31]
; AVX512VL-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,2,5,7]
; AVX512VL-NEXT:    vpermi2q %ymm1, %ymm0, %ymm2
; AVX512VL-NEXT:    vmovdqa %ymm2, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v32i16_to_v16i16_1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vmovdqa 32(%rdi), %ymm1
; AVX512BW-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[6,7,2,3,4,5,6,7,2,3,6,7,10,11,14,15,22,23,18,19,20,21,22,23,18,19,22,23,26,27,30,31]
; AVX512BW-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[2,3,6,7,10,11,14,15,14,15,10,11,12,13,14,15,18,19,22,23,26,27,30,31,30,31,26,27,28,29,30,31]
; AVX512BW-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; AVX512BW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512BW-NEXT:    vmovdqa %ymm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v32i16_to_v16i16_1:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vmovdqa {{.*#+}} ymm1 = [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31]
; AVX512BWVL-NEXT:    vpermi2w 32(%rdi), %ymm0, %ymm1
; AVX512BWVL-NEXT:    vmovdqa %ymm1, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i16>, <32 x i16>* %L
  %strided.vec = shufflevector <32 x i16> %vec, <32 x i16> undef, <16 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15, i32 17, i32 19, i32 21, i32 23, i32 25, i32 27, i32 29, i32 31>
  store <16 x i16> %strided.vec, <16 x i16>* %S
  ret void
}

define void @shuffle_v16i32_to_v8i32_1(<16 x i32>* %L, <8 x i32>* %S) nounwind {
; AVX512F-LABEL: shuffle_v16i32_to_v8i32_1:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %ymm0
; AVX512F-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],mem[1,3],ymm0[5,7],mem[5,7]
; AVX512F-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512F-NEXT:    vmovaps %ymm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v16i32_to_v8i32_1:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vmovdqa {{.*#+}} ymm1 = [1,3,5,7,9,11,13,15]
; AVX512VL-NEXT:    vpermi2d 32(%rdi), %ymm0, %ymm1
; AVX512VL-NEXT:    vmovdqa %ymm1, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v16i32_to_v8i32_1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rdi), %ymm0
; AVX512BW-NEXT:    vshufps {{.*#+}} ymm0 = ymm0[1,3],mem[1,3],ymm0[5,7],mem[5,7]
; AVX512BW-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512BW-NEXT:    vmovaps %ymm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v16i32_to_v8i32_1:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vmovdqa {{.*#+}} ymm1 = [1,3,5,7,9,11,13,15]
; AVX512BWVL-NEXT:    vpermi2d 32(%rdi), %ymm0, %ymm1
; AVX512BWVL-NEXT:    vmovdqa %ymm1, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <16 x i32>, <16 x i32>* %L
  %strided.vec = shufflevector <16 x i32> %vec, <16 x i32> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  store <8 x i32> %strided.vec, <8 x i32>* %S
  ret void
}

define void @shuffle_v64i8_to_v16i8_1(<64 x i8>* %L, <16 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v16i8_1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,u,u,1,5,9,13,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <1,5,9,13,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <16 x i32> <i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29, i32 33, i32 37, i32 41, i32 45, i32 49, i32 53, i32 57, i32 61>
  store <16 x i8> %strided.vec, <16 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v16i8_2(<64 x i8>* %L, <16 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v16i8_2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,u,u,2,6,10,14,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <2,6,10,14,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <16 x i32> <i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30, i32 34, i32 38, i32 42, i32 46, i32 50, i32 54, i32 58, i32 62>
  store <16 x i8> %strided.vec, <16 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v16i8_3(<64 x i8>* %L, <16 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v16i8_3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,u,u,3,7,11,15,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <3,7,11,15,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <16 x i32> <i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31, i32 35, i32 39, i32 43, i32 47, i32 51, i32 55, i32 59, i32 63>
  store <16 x i8> %strided.vec, <16 x i8>* %S
  ret void
}

define void @shuffle_v32i16_to_v8i16_1(<32 x i16>* %L, <8 x i16>* %S) nounwind {
; AVX512F-LABEL: shuffle_v32i16_to_v8i16_1:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = mem[0,2,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[0,1,1,3,4,5,6,7]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = mem[0,2,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm1[0,1,1,3,4,5,6,7]
; AVX512F-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = mem[0,2,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm1[1,3,2,3,4,5,6,7]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm2 = mem[0,2,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm2 = xmm2[1,3,2,3,4,5,6,7]
; AVX512F-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; AVX512F-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v32i16_to_v8i16_1:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512VL-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512VL-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,1,2,3,2,3,10,11,8,9,10,11,12,13,14,15]
; AVX512VL-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512VL-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512VL-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm3 = [2,3,10,11,8,9,10,11,8,9,10,11,12,13,14,15]
; AVX512VL-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512VL-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512VL-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512VL-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v32i16_to_v8i16_1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BW-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512BW-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512BW-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512BW-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,1,2,3,2,3,10,11,8,9,10,11,12,13,14,15]
; AVX512BW-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512BW-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512BW-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512BW-NEXT:    vmovdqa {{.*#+}} xmm3 = [2,3,10,11,8,9,10,11,8,9,10,11,12,13,14,15]
; AVX512BW-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512BW-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512BW-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512BW-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v32i16_to_v8i16_1:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa {{.*#+}} xmm0 = [1,5,9,13,17,21,25,29]
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm1
; AVX512BWVL-NEXT:    vpermt2w 32(%rdi), %ymm0, %ymm1
; AVX512BWVL-NEXT:    vmovdqa %xmm1, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i16>, <32 x i16>* %L
  %strided.vec = shufflevector <32 x i16> %vec, <32 x i16> undef, <8 x i32> <i32 1, i32 5, i32 9, i32 13, i32 17, i32 21, i32 25, i32 29>
  store <8 x i16> %strided.vec, <8 x i16>* %S
  ret void
}

define void @shuffle_v32i16_to_v8i16_2(<32 x i16>* %L, <8 x i16>* %S) nounwind {
; AVX512F-LABEL: shuffle_v32i16_to_v8i16_2:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[0,1,2,0,4,5,6,7]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm1[0,1,2,0,4,5,6,7]
; AVX512F-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm1[2,0,2,3,4,5,6,7]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm2 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm2 = xmm2[2,0,2,3,4,5,6,7]
; AVX512F-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; AVX512F-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v32i16_to_v8i16_2:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512VL-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512VL-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm4 = [12,13,14,15,4,5,12,13,8,9,10,11,12,13,14,15]
; AVX512VL-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512VL-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512VL-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm3 = [4,5,12,13,4,5,6,7,8,9,10,11,12,13,14,15]
; AVX512VL-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512VL-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512VL-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512VL-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v32i16_to_v8i16_2:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BW-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512BW-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512BW-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512BW-NEXT:    vmovdqa {{.*#+}} xmm4 = [12,13,14,15,4,5,12,13,8,9,10,11,12,13,14,15]
; AVX512BW-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512BW-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512BW-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512BW-NEXT:    vmovdqa {{.*#+}} xmm3 = [4,5,12,13,4,5,6,7,8,9,10,11,12,13,14,15]
; AVX512BW-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512BW-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512BW-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512BW-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v32i16_to_v8i16_2:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa {{.*#+}} xmm0 = [2,6,10,14,18,22,26,30]
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm1
; AVX512BWVL-NEXT:    vpermt2w 32(%rdi), %ymm0, %ymm1
; AVX512BWVL-NEXT:    vmovdqa %xmm1, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i16>, <32 x i16>* %L
  %strided.vec = shufflevector <32 x i16> %vec, <32 x i16> undef, <8 x i32> <i32 2, i32 6, i32 10, i32 14, i32 18, i32 22, i32 26, i32 30>
  store <8 x i16> %strided.vec, <8 x i16>* %S
  ret void
}

define void @shuffle_v32i16_to_v8i16_3(<32 x i16>* %L, <8 x i16>* %S) nounwind {
; AVX512F-LABEL: shuffle_v32i16_to_v8i16_3:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[0,1,3,1,4,5,6,7]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm1[0,1,3,1,4,5,6,7]
; AVX512F-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm1 = xmm1[3,1,2,3,4,5,6,7]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm2 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm2 = xmm2[3,1,2,3,4,5,6,7]
; AVX512F-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; AVX512F-NEXT:    vpblendd {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v32i16_to_v8i16_3:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512VL-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512VL-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512VL-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm4 = [12,13,14,15,6,7,14,15,8,9,10,11,12,13,14,15]
; AVX512VL-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512VL-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512VL-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512VL-NEXT:    vmovdqa {{.*#+}} xmm3 = [6,7,14,15,4,5,6,7,8,9,10,11,12,13,14,15]
; AVX512VL-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512VL-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512VL-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512VL-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512VL-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v32i16_to_v8i16_3:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BW-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512BW-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512BW-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512BW-NEXT:    vmovdqa {{.*#+}} xmm4 = [12,13,14,15,6,7,14,15,8,9,10,11,12,13,14,15]
; AVX512BW-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512BW-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512BW-NEXT:    vpunpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; AVX512BW-NEXT:    vmovdqa {{.*#+}} xmm3 = [6,7,14,15,4,5,6,7,8,9,10,11,12,13,14,15]
; AVX512BW-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512BW-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512BW-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX512BW-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3]
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v32i16_to_v8i16_3:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa {{.*#+}} xmm0 = [3,7,11,15,19,23,27,31]
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm1
; AVX512BWVL-NEXT:    vpermt2w 32(%rdi), %ymm0, %ymm1
; AVX512BWVL-NEXT:    vmovdqa %xmm1, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i16>, <32 x i16>* %L
  %strided.vec = shufflevector <32 x i16> %vec, <32 x i16> undef, <8 x i32> <i32 3, i32 7, i32 11, i32 15, i32 19, i32 23, i32 27, i32 31>
  store <8 x i16> %strided.vec, <8 x i16>* %S
  ret void
}

define void @shuffle_v64i8_to_v8i8_1(<64 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v8i8_1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,1,9,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <1,9,u,u,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <8 x i32> <i32 1, i32 9, i32 17, i32 25, i32 33, i32 41, i32 49, i32 57>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v8i8_2(<64 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v8i8_2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,2,10,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <2,10,u,u,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <8 x i32> <i32 2, i32 10, i32 18, i32 26, i32 34, i32 42, i32 50, i32 58>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v8i8_3(<64 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v8i8_3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,3,11,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <3,11,u,u,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <8 x i32> <i32 3, i32 11, i32 19, i32 27, i32 35, i32 43, i32 51, i32 59>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v8i8_4(<64 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v8i8_4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,4,12,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <4,12,u,u,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <8 x i32> <i32 4, i32 12, i32 20, i32 28, i32 36, i32 44, i32 52, i32 60>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v8i8_5(<64 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v8i8_5:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,5,13,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <5,13,u,u,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <8 x i32> <i32 5, i32 13, i32 21, i32 29, i32 37, i32 45, i32 53, i32 61>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v8i8_6(<64 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v8i8_6:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,6,14,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <6,14,u,u,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <8 x i32> <i32 6, i32 14, i32 22, i32 30, i32 38, i32 46, i32 54, i32 62>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v64i8_to_v8i8_7(<64 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX512-LABEL: shuffle_v64i8_to_v8i8_7:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX512-NEXT:    vmovdqa 32(%rdi), %xmm2
; AVX512-NEXT:    vmovdqa 48(%rdi), %xmm3
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm4 = <u,u,7,15,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm4, %xmm3, %xmm3
; AVX512-NEXT:    vpshufb %xmm4, %xmm2, %xmm2
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1],xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; AVX512-NEXT:    vmovdqa {{.*#+}} xmm3 = <7,15,u,u,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX512-NEXT:    vpshufb %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vpshufb %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2,3]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <64 x i8>, <64 x i8>* %L
  %strided.vec = shufflevector <64 x i8> %vec, <64 x i8> undef, <8 x i32> <i32 7, i32 15, i32 23, i32 31, i32 39, i32 47, i32 55, i32 63>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

