#!/bin/bash
set -e

rm -rf tests/TestResults/latest

dotnet test --collect:"XPlat Code Coverage" --results-directory:tests/TestResults/latest

reportgenerator \
  -reports:"tests/TestResults/latest/*/coverage.cobertura.xml" \
  -targetdir:tests/CoverageReport \
