#!/bin/sh

set -e

# Respect RELEASE_VERSION if specified
[ -n "$RELEASE_VERSION" ] || [ -n "$TAG" ] || export RELEASE_VERSION="${SENTRY_PROJECT}@$(git describe --abbrev=0 --tags)"
# IF TAG is given, use this last part (after last '-') as version
[ -n "$RELEASE_VERSION" ] || export RELEASE_VERSION="${SENTRY_PROJECT}@$(echo $TAG | sed -e 's/^.*-//')"

# Capture output
output=$(
sentry-cli releases new -p $SENTRY_PROJECT $RELEASE_VERSION
sentry-cli releases set-commits --auto $RELEASE_VERSION
sentry-cli releases deploys $RELEASE_VERSION new -e $ENVIRONMENT
)

# Preserve output for consumption by downstream actions
echo "$output" > "${HOME}/${GITHUB_ACTION}.${log}"


# Write output to STDOUT
echo "$output"
