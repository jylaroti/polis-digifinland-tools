#!/bin/bash
# usage: ./path_to_this_script 

# Run git commands in polis dir to reset submodule codebase
cd ./polis/

# patch 1: enable sending with mailgun EU endpoint
dos2unix -q ./server/src/email/senders.ts
diff -u ./server/src/email/senders.ts ../patches/server/src/email/senders.ts > ../patches/server/src/email/senders.ts.patch

# patch 2: fix client-report urls, this was replaced with a new env variable
#dos2unix -q ./client-report/src/util/url.js
#patch ./client-report/src/util/url.js <  ../client-report/src/util/url.js.patch

# patch 3: 
#  - comment out block that saves encrypted IPs to database when x-forwarded-for header is set in request
#  - force exempt=true to disable http->https redirect to enable working internal LB health checks and Pod readiness probes on GKE
dos2unix -q ./server/src/server.ts
diff -u ./server/src/server.ts ../patches/server/src/server.ts > ../patches/server/src/server.ts.patch

# patch 4: hide social media opt in settings for conversation setup and set opt-in defaults as false
dos2unix -q ./server/src/utils/constants.ts
diff -u ./server/src/utils/constants.ts ../patches/server/src/utils/constants.ts > ../patches/server/src/utils/constants.ts.patch
diff -u ./client-admin/src/components/conversation-admin/conversation-config.js ../patches/client-admin/src/components/conversation-admin/conversation-config.js > ../patches/client-admin/src/components/conversation-admin/conversation-config.js.patch

# patch 5:
# - hide facebook login/user creation on admin signin page
# - add dev env warning before login form
dos2unix -q ./client-admin/src/components/landers/signin.js
diff -u ./client-admin/src/components/landers/signin.js ../patches/client-admin/src/components/landers/signin.js > ../patches/client-admin/src/components/landers/signin.js.patch

# patch 6: hide TOS link and replace privacy policy link on admin page footer
diff -u ./client-admin/src/components/landers/lander-footer.js ../patches/client-admin/src/components/landers/lander-footer.js > ../patches/client-admin/src/components/landers/lander-footer.js.patch

# patch 7: hide footer (logo with pol.is link and other links to privacy policy & terms pages)
diff -u ./client-participation/js/templates/participation.handlebars ../patches/client-participation/js/templates/participation.handlebars > ../patches/client-participation/js/templates/participation.handlebars.patch

# patch 8: add finnish and swedish translations
diff -u ./client-participation/js/strings.js ../patches/client-participation/js/strings.js > ../patches/client-participation/js/strings.js.patch

# patch 9: redirect to /signin instead of /home after sign out
diff -u ./client-admin/src/components/landers/signout.js ../patches/client-admin/src/components/landers/signout.js > ../patches/client-admin/src/components/landers/signout.js.patch

