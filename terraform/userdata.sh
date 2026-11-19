#!/bin/bash
set -euxo pipefail
dnf install -y httpd
cat > /var/www/html/index.html <<'HTML'
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><title>LogiNext DevOps POC</title></head>
<body><h1>LogiNext DevOps Challenge</h1><h2>Apache Web Server Deployment Successful</h2><p>Private EC2 behind an internet-facing ALB, deployed with Terraform.</p></body></html>
HTML
systemctl enable --now httpd
