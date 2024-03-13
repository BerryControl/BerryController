#!/bin/bash
/usr/bin/sandbox-exec -p "(version 1)
(deny default)
(import \"system.sb\")
(allow file-read*)
(allow process*)
(allow mach-lookup (global-name \"com.apple.lsd.mapdb\"))
(allow file-write*
    (subpath \"/private/tmp\")
    (subpath \"/private/var/folders/xz/qvw27j992h53nj3xj_6309cm0000gn/T\")
)
(deny file-write*
    (subpath \"/Users/thomas/Library/Developer/Xcode/DerivedData/BerryController-cdipbdpsrcycvobqoxptzhkmoaey/SourcePackages/checkouts/berry-openapi-lib\")
)
(allow file-write*
    (subpath \"/Users/thomas/Library/Developer/Xcode/DerivedData/BerryController-cdipbdpsrcycvobqoxptzhkmoaey/SourcePackages/plugins/berry-openapi-lib.output/BerryOpenAPILib/OpenAPIGenerator\")
)
" "/${BUILD_DIR}/${CONFIGURATION}/swift-openapi-generator" generate /Users/thomas/Library/Developer/Xcode/DerivedData/BerryController-cdipbdpsrcycvobqoxptzhkmoaey/SourcePackages/checkouts/berry-openapi-lib/Sources/openapi.yaml --config /Users/thomas/Library/Developer/Xcode/DerivedData/BerryController-cdipbdpsrcycvobqoxptzhkmoaey/SourcePackages/checkouts/berry-openapi-lib/Sources/openapi-generator-config.yaml --output-directory /Users/thomas/Library/Developer/Xcode/DerivedData/BerryController-cdipbdpsrcycvobqoxptzhkmoaey/SourcePackages/plugins/berry-openapi-lib.output/BerryOpenAPILib/OpenAPIGenerator/GeneratedSources --plugin-source build

