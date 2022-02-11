#!/bin/sh
# GDAL specific script to extract exported libpng symbols that can be renamed
# to keep them internal to GDAL as much as possible

# on macOS run with docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp gcc ./dump_png_symbols.sh

gcc ./*.c -fPIC -shared -o libpng.so -I. -lz

OUT_FILE=gdal_libpng_symbol_rename.h

rm $OUT_FILE 2>/dev/null

echo "/* This is a generated file by dump_symbols.h. *DO NOT EDIT MANUALLY !* */" >> $OUT_FILE

symbol_list=$(objdump -t libpng.so  | grep .text | awk '{print $6}' | grep -v -e .text -e __do_global -e __bss_start -e _edata -e _end -e _fini -e _init -e call_gmon_start -e CPL_IGNORE_RET_VAL_INT -e register_tm_clones | sort)
for symbol in $symbol_list
do
    echo "#define $symbol gdal_$symbol" >> $OUT_FILE
done

rodata_symbol_list=$(objdump -t libpng.so  | grep "\\.rodata" |  awk '{print $6}' | grep -v "\\.")
for symbol in $rodata_symbol_list
do
    echo "#define $symbol gdal_$symbol" >> $OUT_FILE
done

data_symbol_list=$(objdump -t libpng.so  | grep "\\.data" | grep -v __dso_handle | grep -v __TMC_END__ |  awk '{print $6}' | grep -v "\\.")
for symbol in $data_symbol_list
do
    echo "#define $symbol gdal_$symbol" >> $OUT_FILE
done

bss_symbol_list=$(objdump -t libpng.so  | grep "\\.bss" |  awk '{print $6}' | grep -v "\\.")
for symbol in $bss_symbol_list
do
    echo "#define $symbol gdal_$symbol" >> $OUT_FILE
done

echo "#include \"png.h\"" >> $OUT_FILE

rm libpng.so
