{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-loader,
  glslang,
  opencv,
  protobuf,
}:

stdenv.mkDerivation rec {
  pname = "ncnn";
  version = "20241226";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "ncnn";
    rev = version;
    hash = "sha256-XmIuXR/uxJbXaB0G+tS9I47Pke20qj8jI1vqnDDgrpE=";
  };

  patches = [
    ./cmakelists.patch
  ];

  cmakeFlags =
    [
      "-DNCNN_CMAKE_VERBOSE=1" # Only for debugging the build
      "-DNCNN_SHARED_LIB=1"
      "-DNCNN_ENABLE_LTO=1"
      "-DNCNN_VULKAN=1"
      "-DNCNN_BUILD_EXAMPLES=0"
      "-DNCNN_BUILD_TOOLS=0"
      "-DNCNN_SYSTEM_GLSLANG=1"
      "-DNCNN_PYTHON=0" # Should be an attribute
    ]
    # Requires setting `Vulkan_LIBRARY` on Darwin. Otherwise the build fails due to missing symbols.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-DVulkan_LIBRARY=-lvulkan" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    vulkan-headers
    vulkan-loader
    glslang
    opencv
    protobuf
  ];

  meta = with lib; {
    description = "ncnn is a high-performance neural network inference framework optimized for the mobile platform";
    homepage = "https://github.com/Tencent/ncnn";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tilcreator ];
    platforms = platforms.all;
  };
}
