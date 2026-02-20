#!/bin/bash
set -e

rm -rf TestResults/latest

dotnet test --collect:"XPlat Code Coverage" --results-directory:TestResults/latest

reportgenerator \
  -reports:"TestResults/latest/*/coverage.cobertura.xml" \
  -targetdir:CoverageReport \
