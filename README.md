# odin-wayland-bindings
Odin native bindings and protocol generator for Wayland.

 ### Usage
The `protocol_codegen.odin` file contains the code that uses the wayland `*.xml` protocol definitions in `/defs` folder to generate the odin bindings in the `/bindings` folder. To  run or build execute `odin build/run protocol_codegen.odin -file`. Running the protocol_codegen will not display any output other than placing any new bindings into the `/bindings` folder or updating the ones there.
There is an example of using the bindings in the `test.odin` file which can be tested by running `odin build/run test.odin -file`.
