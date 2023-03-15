#!/bin/bash
# usage: ./path_to_this_script 

# First reset polis submodule to official stable OR edge branch, or at certain commit usable for DigiFinland version.

# Init and update submodule contents
git submodule update --init --recursive --force

# Run git commands in polis dir to reset submodule codebase
cd ./polis/

# Download changes
git fetch

# To use latest version from edge branch, use:
git reset --hard origin/edge

# To get specific commits, use alternative commands below:
# 
# 1. last working version before Polis configuration unification changes:
# git reset --hard ad23ff57566ffe6be7d441709c235c574e5f97d7
# 2. Polis the first "configuration unification" version changes:
# git reset --hard 5ecaf99d890615e72225f0ff7d3afc847a9f35e7
# 4. to use stable branch (not yet recommended by CompDem for DigiFinland)
# git reset --hard origin/stable

# Remove untracked files
git clean -fdx

# Apply selected patches

# patch 0: fix math server entrypoint script line feeds
dos2unix math/bin/run

# patch 1: enable sending with mailgun EU endpoint
dos2unix ./server/src/email/senders.ts
patch --no-backup-if-mismatch ./server/src/email/senders.ts < ../server/src/email/senders.ts.patch

# patch 2: fix client-report urls
dos2unix ./client-report/src/util/url.js
patch ./client-report/src/util/url.js <  ../client-report/src/util/url.js.patch

# patch 3: 
#  - comment out block that saves encrypted IPs to database when x-forwarded-for header is set in request
#  - force exempt=true to disable http->https redirect to enable working internal LB health checks and Pod readiness probes on GKE
dos2unix ./server/src/server.ts
patch --no-backup-if-mismatch ./server/src/server.ts <  ../server/src/server.ts.patch

# patch 4: hide social media opt in settings for conversation setup and set opt-in defaults as false
dos2unix ./server/src/utils/constants.ts
patch ./server/src/utils/constants.ts < ../server/src/utils/constants.ts.patch
dos2unix ./client-admin/src/components/conversation-admin/conversation-config.js
patch ./client-admin/src/components/conversation-admin/conversation-config.js < ../client-admin/src/components/conversation-admin/conversation-config.js.patch

# patch 5:
# - hide facebook login/user creation on admin signin page
# - add dev env warning before login form
dos2unix ./client-admin/src/components/landers/signin.js
patch  ./client-admin/src/components/landers/signin.js < ../client-admin/src/components/landers/signin.js.patch

# patch 6: hide TOS link and replace privacy policy link on admin page footer
dos2unix ./client-admin/src/components/landers/lander-footer.js
patch ./client-admin/src/components/landers/lander-footer.js < ../client-admin/src/components/landers/lander-footer.js.patch

# patch 7: hide footer (logo with pol.is link and other links to privacy policy & terms pages)
dos2unix ./client-participation/js/templates/participation.handlebars 
patch ./client-participation/js/templates/participation.handlebars < ../client-participation/js/templates/participation.handlebars.patch

# patch 8: add finnish and swedish translations
cp -r ../client-participation/js/strings/* ./client-participation/js/strings/
dos2unix ./client-participation/js/strings.js
patch ./client-participation/js/strings.js < ../client-participation/js/strings.js.patch

# patch 9: redirect to /signin instead of /home after sign out
dos2unix ./client-admin/src/components/landers/signout.js
patch  ./client-admin/src/components/landers/signout.js < ../client-admin/src/components/landers/signout.js.patch
