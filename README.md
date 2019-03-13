# hoto-compile-riscv
a script and some instruction to compile riscv-isa-sim (on ubuntu)

## First Step: Clone the repos on your computer
The following are the repos needed to compile spike.
- [riscv-fesvr](https://github.com/riscv/riscv-fesvr)
- [riscv-gnu-toolchain](https://github.com/riscv/riscv-gnu-toolchain)
- [riscv-isa-sim](https://github.com/riscv/riscv-isa-sim)
- [riscv-pk](https://github.com/riscv/riscv-pk)

This repo provides a script to compile them.  If you want to use it, please make sure the repos are in this format in your working directory.
```
(your working directory)
├── hoto-compile-riscv
├── riscv-fesvr
├── riscv-gnu-toolchain
├── riscv-isa-sim
└── riscv-pk

```

## Step 1.5: Fix some bug first
I find some bugs in riscv-fesvr repo.

`write_csr` is both used as macro (in encoding.h, line 198) and as function name (in dtm.cc, line 405), resulting in a compile error.

My solution (not a clever solution, though) is to comment the `#include "encoding.h"` and add `#define CSR_DSCRATCH 0x7b2` in dtm.cc. 
Since `CSR_DSCRATCH` is a constant needed in dtm.cc defined in encoding.h but including encoding.h will cause naming conflict.

i.e. in dtm.cc
replace this
```
#include "dtm.h"
#include "debug_defines.h"
#include "encoding.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <pthread.h>
```
with this
```
#include "dtm.h"
#include "debug_defines.h"
// #include "encoding.h"
#define CSR_DSCRATCH 0x7b2
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <pthread.h>
```
Refer to [this issue](https://github.com/riscv/riscv-fesvr/issues/38) for more info.

## Second Step: Compile them XD
change your directory to this repo:
```
cd hoto-compile-riscv
```
and then run the script with sudo
```
sudo ./build-riscv.sh
```
finally, test if your spike work! 
(Simply follow the instruction in [riscv-isa-sim](https://github.com/riscv/riscv-isa-sim#compiling-and-running-a-simple-c-program))


## Notes:
Here are some problem when I try to compile and run them.  Solutions are also provided.

#### Compile Error: expected unqualified-id before '(' token
As I mentioned, there are currently some problems in dtm.cc in riscv-fesvr.
Solution are listed in step 1.5.


#### Compile error with -mcmodel=medany
- [issue on riscv-pk repo](-mcmodel=medany problem when compiling). 
- Please make sure you use the riscv-gnu-toolchain to compile riscv-pk
(instead of gcc), please build riscv-gnu-toolchain first.

#### Pk not found when testing `spike pk hello`
- [issue on riscv-isa-sim repo](https://github.com/riscv/riscv-isa-sim/issues/268).  
- Spike-pk must be build in the same place as 
riscv-gnu-toolchain.  Make sure you have your `$RISCV` and `--prefix=$RISCV` set when compiling.

#### User segfault when testing `spike pk hello`
- [Related question on stackoverflow](https://stackoverflow.com/questions/33093626/segmentation-fault-when-running-binaries-compiled-using-riscv64-unknown-linux-gn).
- It is said that `--static` must be added when compiling hello.c since dynamic-linked program cannot run on proxy-kernel.  Please added the flag when compiling.

