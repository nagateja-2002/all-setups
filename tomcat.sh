#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this legacy setup script as root or through an approved privilege-escalation method." >&2
  exit 1
fi

yum install java-21-amazon-corretto -y
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.122/bin/apache-tomcat-9.0.122.tar.gz
tar -xzf apache-tomcat-9.0.122.tar.gz

# Do not create a Manager account or inject a hard-coded password.
# Keep Tomcat's default manager context restrictions in place (localhost-only).
# If administrative access is required, configure a unique credential using
# an approved secret-management process and keep the Manager endpoint private.

sh apache-tomcat-9.0.122/bin/startup.sh
