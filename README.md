# hello_eejit

Project with scripts and code to test the software build environment
on eejit. In our research software projects we use various 3rd party
software. We use CMake to generate build scripts for us.

Here, we let CMake find the 3rd party software we rely on, and generate
build scripts for compiling very simple test programs. If all this
succeeds, we can assume that the software build environment on eejit
is good.

These steps can be performed to configure and build `hello_eejit`:

- Load software modules
- Generate build scripts
- Build software
- Install software
- Test software

For convenience, a bash script is included that performs these steps in one go:

```
bash ./say_hello_to_eejit.sh
```
