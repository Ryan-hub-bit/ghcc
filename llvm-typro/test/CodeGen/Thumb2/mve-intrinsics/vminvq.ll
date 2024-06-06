; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

define arm_aapcs_vfpcc i32 @test_vminvq_u32(i32 %a, <4 x i32> %b) {
; CHECK-LABEL: test_vminvq_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vminv.u32 r0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call i32 @llvm.arm.mve.minv.u.v4i32(i32 %a, <4 x i32> %b)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vmaxvq_u8(i32 %a, <16 x i8> %b) {
; CHECK-LABEL: test_vmaxvq_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmaxv.u8 r0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call i32 @llvm.arm.mve.maxv.u.v16i8(i32 %a, <16 x i8> %b)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_vminvq_s16(i32 %a, <8 x i16> %b) {
; CHECK-LABEL: test_vminvq_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vminv.s16 r0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call i32 @llvm.arm.mve.minv.s.v8i16(i32 %a, <8 x i16> %b)
  ret i32 %0
}

declare i32 @llvm.arm.mve.minv.u.v4i32(i32, <4 x i32>)
declare i32 @llvm.arm.mve.maxv.u.v16i8(i32, <16 x i8>)
declare i32 @llvm.arm.mve.minv.s.v8i16(i32, <8 x i16>)