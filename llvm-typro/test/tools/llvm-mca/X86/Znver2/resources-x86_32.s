# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=i686-unknown-unknown -mcpu=znver2 -instruction-tables < %s | FileCheck %s

aaa

aad
aad $7

aam
aam $7

aas

bound %bx, (%eax)
bound %ebx, (%eax)

daa

das

into

leave

salc

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      100   0.25                        aaa
# CHECK-NEXT:  1      100   0.25                        aad
# CHECK-NEXT:  1      100   0.25                        aad	$7
# CHECK-NEXT:  1      100   0.25                        aam
# CHECK-NEXT:  1      100   0.25                        aam	$7
# CHECK-NEXT:  1      100   0.25                        aas
# CHECK-NEXT:  1      100   0.25                  U     bound	%bx, (%eax)
# CHECK-NEXT:  1      100   0.25                  U     bound	%ebx, (%eax)
# CHECK-NEXT:  1      100   0.25                        daa
# CHECK-NEXT:  1      100   0.25                        das
# CHECK-NEXT:  1      100   0.25                  U     into
# CHECK-NEXT:  2      8     0.33    *                   leave
# CHECK-NEXT:  1      1     0.25                  U     salc

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn2AGU0
# CHECK-NEXT: [1]   - Zn2AGU1
# CHECK-NEXT: [2]   - Zn2AGU2
# CHECK-NEXT: [3]   - Zn2ALU0
# CHECK-NEXT: [4]   - Zn2ALU1
# CHECK-NEXT: [5]   - Zn2ALU2
# CHECK-NEXT: [6]   - Zn2ALU3
# CHECK-NEXT: [7]   - Zn2Divider
# CHECK-NEXT: [8]   - Zn2FPU0
# CHECK-NEXT: [9]   - Zn2FPU1
# CHECK-NEXT: [10]  - Zn2FPU2
# CHECK-NEXT: [11]  - Zn2FPU3
# CHECK-NEXT: [12]  - Zn2Multiplier

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]
# CHECK-NEXT: 0.33  0.33   0.33   0.50   0.50   0.50   0.50     -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     aaa
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     aad
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     aad	$7
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     aam
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     aam	$7
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     aas
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     bound	%bx, (%eax)
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     bound	%ebx, (%eax)
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     daa
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     das
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     into
# CHECK-NEXT: 0.33  0.33   0.33   0.25   0.25   0.25   0.25     -      -      -      -      -      -     leave
# CHECK-NEXT:  -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -     salc
