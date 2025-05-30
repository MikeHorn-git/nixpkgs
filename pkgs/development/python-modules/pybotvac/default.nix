{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  requests-oauthlib,
  voluptuous,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.27";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-viMklBbC8KAh6cCuWs5nSbBF0BwVkPXV3Z2ydj08d9c=";
  };

  postPatch = ''
    substituteInPlace pybotvac/robot.py \
      --replace-fail "import urllib3" "" \
      --replace-fail "urllib3.disable_warnings(urllib3.exceptions.SubjectAltNameWarning)" "# urllib3.disable_warnings(urllib3.exceptions.SubjectAltNameWarning)"
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-oauthlib
    voluptuous
  ];

  # Module no tests
  doCheck = false;

  pythonImportsCheck = [ "pybotvac" ];

  meta = with lib; {
    description = "Python module for interacting with Neato Botvac Connected vacuum robots";
    homepage = "https://github.com/stianaske/pybotvac";
    changelog = "https://github.com/stianaske/pybotvac/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
