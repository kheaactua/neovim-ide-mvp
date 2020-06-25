#!/bin/bash

src=/src/capicxx-fnv-runtime/inttests
bld="${src}/bld";

if [[ -e "${bld}" ]]; then
  rm -rf "${bld}"
fi
cmake -B"${bld}" -H"${src}"                                                   \
  -GNinja                                                                    \
  -DCMAKE_TOOLCHAIN_FILE=${QNX_HOST}/usr/share/buildroot/toolchainfile.cmake \
  -DCAPI_MIDDLEWARE=FNV                                                      \
  -DCMAKE_BUILD_TYPE=Release                                                 \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=YES                                        \
  -DCAPI_FNV_GEN=/src/franca-dev/capicxx-fnv-tools/org.genivi.commonapi.fnv.cli.product/target/products/org.genivi.commonapi.fnv.cli.product/all/commonapi-fnv-generator-linux-x86_64 \
  --log-level=verbose \
  -DCAPI_CORE_GEN=/src/franca-dev/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/generator/commonapi-generator-linux-x86_64 \
  && cmake --build "${bld}" --target build_tests

  # -DCAPI_FNV_GEN=/src/capicxx-fnv-runtime/eugene/commonapi-fnv-generator-linux-x86_64 \

# vim: ts=2 sw=2 sts=0 :
