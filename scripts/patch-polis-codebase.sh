#!/bin/bash
# usage: ./path_to_this_script env
#         where env is: test or dev

# reset polis repo to official stable OR edge branch
cd ../polis/
git reset --hard origin/edge
# git reset --hard origin/stable
git pull

# configs from tools repo 
cd ../polis-digifinland-tools/
# env based config files
cp -r ./client-participation/polis.config.$1.js ../polis/client-participation/polis.config.js
cp -r ./client-admin/polis.config.$1.js ../polis/client-admin/polis.config.js
cp -r ./client-report/polis.config.$1.js ../polis/client-report/polis.config.js
# docker env files
cp -r ./server/*.env ../polis/server/
cp -r ./math/*.env ../polis/math/
cp -r ./docker-compose-digifinland.yml ../polis/

# apply selected patches
cd ../polis/
# patch 0: fix math server entrypoint script line feeds
dos2unix math/bin/run

# patch 1: add workaround for forcing npm to use https instead of ssh when downloading deps from public github repos 
#   (this was needed for test VM docker compose build - not needed for GKE or local setup)
# dos2unix ./file-server/Dockerfile
# patch ./file-server/Dockerfile < ../polis-digifinland-tools/file-server/Dockerfile.patch

# patch 2: enable sending with mailgun EU endpoint
dos2unix ./server/src/email/senders.ts
patch ./server/src/email/senders.ts < ../polis-digifinland-tools/server/src/email/senders.ts.patch

# patch 3: fix client-report urls
dos2unix ./client-report/src/util/url.js
patch ./client-report/src/util/url.js <  ../polis-digifinland-tools/client-report/src/util/url.js.patch

# patch 4 & 10: 
#  - comment out block that saves encrypted IPs to database when x-forwarded-for header is set in request
#  - force exempt=true to disable http->https redirect to enable working internal LB health checks and Pod readiness probes on GKE
dos2unix ./server/src/server.ts
patch ./server/src/server.ts <  ../polis-digifinland-tools/server/src/server.ts.patch

# patch 5: hide social media opt in settings for conversation setup and set opt-in defaults as false
dos2unix ./server/src/utils/constants.ts
patch ./server/src/utils/constants.ts < ../polis-digifinland-tools/server/src/utils/constants.ts.patch
dos2unix ./client-admin/src/components/conversation-admin/conversation-config.js
patch ./client-admin/src/components/conversation-admin/conversation-config.js < ../polis-digifinland-tools/client-admin/src/components/conversation-admin/conversation-config.js.patch

# patch 6: hide facebook login/user creation on admin signin page
dos2unix ./client-admin/src/components/landers/signin.js
patch  ./client-admin/src/components/landers/signin.js < ../polis-digifinland-tools/client-admin/src/components/landers/signin.js.patch

# patch 7: hide TOS link and replace privacy policy link on admin page footer
dos2unix ./client-admin/src/components/landers/lander-footer.js
patch ./client-admin/src/components/landers/lander-footer.js < ../polis-digifinland-tools/client-admin/src/components/landers/lander-footer.js.patch

# patch 8: hide footer (logo with pol.is link and other links to privacy policy & terms pages)
dos2unix ./client-participation/js/templates/participation.handlebars 
patch ./client-participation/js/templates/participation.handlebars < ../polis-digifinland-tools/client-participation/js/templates/participation.handlebars.patch

# patch 9: finnish and swedish translations
cp -r ../polis-digifinland-tools/client-participation/js/strings/* ./client-participation/js/strings/
dos2unix ./client-participation/js/strings.js
patch ./client-participation/js/strings.js < ../polis-digifinland-tools/client-participation/js/strings.js.patch