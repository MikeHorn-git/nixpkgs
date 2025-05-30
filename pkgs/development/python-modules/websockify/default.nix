{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  jwcrypto,
  numpy,
  pytestCheckHook,
  pythonOlder,
  redis,
  requests,
  simplejson,
}:

buildPythonPackage rec {
  pname = "websockify";
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "novnc";
    repo = "websockify";
    tag = "v${version}";
    hash = "sha256-b57L4o071zEt/gX9ZVzEpcnp0RCeo3peZrby2mccJgQ=";
  };

  propagatedBuildInputs = [
    jwcrypto
    numpy
    redis
    requests
    simplejson
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # this test failed on macos
    # https://github.com/novnc/websockify/issues/552
    "test_socket_set_keepalive_options"
  ];

  pythonImportsCheck = [ "websockify" ];

  meta = with lib; {
    description = "WebSockets support for any application/server";
    mainProgram = "websockify";
    homepage = "https://github.com/kanaka/websockify";
    changelog = "https://github.com/novnc/websockify/releases/tag/${src.tag}";
    license = licenses.lgpl3Only;
    maintainers = [ ];
  };
}
