# crt2dot

Visualize GNU LD Cross Reference Table as a digraph using DOT

```
Usage: crt2dot elf-file map-file out-file <types>

Convert GCC LD Cross Reference Table (--cref) to digraph using DOT

<types> is a comma separated list of symbol types to include in
        the graph. If ommited, only FUNC is included

Only functions in the CRT are used for graph generation. It uses
readelf to determine if a symbol in the CRT is a function or not.
The output is a DOT file, use the dot utility to generate an image.

crt2dot.awk needs to be in the path somwhere ..
```

Below are example outputs from building a ChibiOS testhal application with and
without link time optimization (LTO).

```shell
make -f <makefile> USE_LTO=no
crt2dot path/to/ch.elf path/to/ch.map graph_noLTO.dot # types ommited, will default to FUNC only
dot -Tpng -Grankdir="LR" -o graph_noLTO.png graph_noLTO.dot

make clean

make -f <makefile> USE_LTO=yes
crt2dot path/to/ch.elf path/to/ch.map graph_LTO.dot # types ommited, will default to FUNC only
dot -Tpng -Grankdir="LR" -o graph_LTO.png graph_LTO.dot

```


Without LTO

![Without LTO](docs/img/ch_nolto.png)


With LTO

![With LTO](docs/img/ch.png)
