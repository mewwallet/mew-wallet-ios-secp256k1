// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swiftlint:disable all

import PackageDescription

let package = Package(
  name: "mew-wallet-ios-secp256k1",
  platforms: [
    .iOS(.v11),
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "mew-wallet-ios-secp256k1-lib",
      targets: ["mew-wallet-ios-secp256k1-lib"]),
    .library(
      name: "mew-wallet-ios-secp256k1",
      targets: ["mew-wallet-ios-secp256k1"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0")
  ],
  targets: [
    .target(
      name: "mew-wallet-ios-secp256k1",
      dependencies: [
        "mew-wallet-ios-secp256k1-lib"
      ],
      path: "Sources/mew-wallet-ios-secp256k1",
      plugins: []
    ),
    .target(
      name: "mew-wallet-ios-secp256k1-lib",
      path: "Sources/mew-wallet-ios-secp256k1-lib",
      exclude: [
        "src/asm",
        
        // exclude benchmarks
        "src/bench_ecmult.c",
        "src/bench_internal.c",
        "src/bench.c",
        "src/bench.h",
        "src/modules/ecdh/bench_impl.h",
        "src/modules/recovery/bench_impl.h",
        "src/modules/schnorrsig/bench_impl.h",
        
        // already manually added ecmult_static_context.h
        "src/precompute_ecmult.c",
        "src/precompute_ecmult_gen.c",
        
        // exclude tests
        "src/testrand.h",
        "src/testrand_impl.h",
        "src/tests.c",
        "src/tests_exhaustive.c",
        "src/ctime_tests.c",
        "src/modules/ecdh/tests_impl.h",
        "src/modules/extrakeys/tests_impl.h",
        "src/modules/extrakeys/tests_exhaustive_impl.h",
        "src/modules/recovery/tests_impl.h",
        "src/modules/recovery/tests_exhaustive_impl.h",
        "src/modules/schnorrsig/tests_impl.h",
        "src/modules/schnorrsig/tests_exhaustive_impl.h",
        
        // exclude module tests and makefiles
        "Makefile.am",
        "src/modules/ecdh/Makefile.am.include",
        "src/modules/extrakeys/Makefile.am.include",
        "src/modules/recovery/Makefile.am.include",
        "src/modules/schnorrsig/Makefile.am.include",
        "src/CMakeLists.txt",
        
        // exclude docs and autotools related files
        "build-aux",
        "ci",
        "cmake",
        "doc",
        "examples",
        "sage",
        "autogen.sh",
        "configure.ac",
        "COPYING",
        "libsecp256k1.pc.in",
        "README.md",
        "SECURITY.md"
      ],
      sources: [
        "src",
        "contrib",
        "include",
        "spm-compat"
      ],
      publicHeadersPath: "include",
      cSettings: [
        .define("ENABLE_MODULE_ECDH"),
        .define("ENABLE_MODULE_RECOVERY"),
        .define("ENABLE_MODULE_EXTRAKEYS"),
        .define("ENABLE_MODULE_SCHNORRSIG"),
        
        // header paths are relative to target's dir
        .headerSearchPath("./"),
        .headerSearchPath("./src"),
        .headerSearchPath("./spm-compat"),
      ]
    ),
    .testTarget(
      name: "mew-wallet-ios-secp256k1-tests",
      dependencies: ["mew-wallet-ios-secp256k1"],
      plugins: []
    )
  ]
)

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
package.dependencies
  .append(.package(url: "https://github.com/realm/SwiftLint.git", from: "0.51.0"))

package
  .targets
  .first(where: { $0.name == "mew-wallet-ios-secp256k1" })?
  .plugins?
  .append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))

package
  .targets
  .first(where: { $0.name == "mew-wallet-ios-secp256k1-tests" })?
  .plugins?
  .append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))
#endif

// swiftlint:enable all
