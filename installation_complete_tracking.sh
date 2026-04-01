#!/bin/bash
#
# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -e

echo "Tracking 'Installation Completed'..."

COLLECT_BASE_URL="https://www.google-analytics.com/mp/collect"
MEASUREMENT_ID="G-3E6WG3C5TD"
API_SECRET="X9fYuV5eSvuJeE1Au_NK-A"

CLIENT_ID=""
if [ -f "google-ads.yaml" ]; then
  CLIENT_ID=$(grep -v '^[[:space:]]*#' google-ads.yaml | grep 'login_customer_id' | head -n 1 | cut -d ':' -f2 | tr -d " '\"\r")
fi

if [ -z "$CLIENT_ID" ]; then
  read -p "What's the highest level google ads account you'll use pMaximizer for? " CLIENT_ID
fi

PAYLOAD=$(cat <<EOF
{
  "client_id": "${CLIENT_ID}",
  "events": [{
    "name": "installation_completed",
    "params": {
      "solutions_name": "pmax_best_practices_dashboard",
      "gads_external_ads_account_id": "${CLIENT_ID}"
    }
  }]
}
EOF
)

curl -s -X POST \
  "${COLLECT_BASE_URL}?measurement_id=${MEASUREMENT_ID}&api_secret=${API_SECRET}" \
  -H "Content-Type: application/json" \
  -d "${PAYLOAD}"
