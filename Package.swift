// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "mew-wallet-ios-secp256k1",
  products: [
    .library(
      name: "mew-wallet-ios-secp256k1",
      targets: ["mew-wallet-ios-secp256k1"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "mew-wallet-ios-secp256k1",
      path: "Sources/mew-wallet-ios-secp256k1-lib",
      exclude: [
        "contrib/travis.sh",
        
        "src/asm",
        
        // exclude benchmarks
        "src/bench_ecdh.c",
        "src/bench_ecmult.c",
        "src/bench_internal.c",
        "src/bench_recover.c",
        "src/bench_sign.c",
        "src/bench_verify.c",
        "src/bench_internal.c",
        "src/bench_ecdh.c",
        "src/bench.h",
        
        // already manually added ecmult_static_context.h
        "src/gen_context.c",
        
        // exclude tests
        "src/testrand.h",
        "src/testrand_impl.h",
        "src/tests.c",
        "src/tests_exhaustive.c",
        "src/valgrind_ctime_test.c",
        
        // exclude module tests and makefiles
        "src/modules/ecdh/tests_impl.h",
        "src/modules/recovery/tests_impl.h",
        "src/modules/recovery/Makefile.am.include",
        "src/modules/ecdh/Makefile.am.include",
        
        // exclude docs and autotools related files
        "build-aux",
        "obj",
        "sage",
        "autogen.sh",
        "configure.ac",
        "COPYING",
        "libsecp256k1.pc.in",
        "Makefile.am",
        "README.md",
        "SECURITY.md",
        "TODO",
      ],
      sources: [
        "src",
        "contrib",
        "include",
      ],
      publicHeadersPath: "include",
      cSettings: [
        // speficy availability of libsecp256k1-config.h
        .define("HAVE_CONFIG_H"),
        
        // header paths are relative to target's dir
        .headerSearchPath("./"),
        .headerSearchPath("./src"),
        .headerSearchPath("./spm-compat"),
      ]),
    .testTarget(
      name: "mew-wallet-ios-secp256k1-tests",
      dependencies: ["mew-wallet-ios-secp256k1"]),
  ]
)
