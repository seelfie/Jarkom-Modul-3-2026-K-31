apk update
apk add apache2-utils

ab -n 600 -c 30 \
  -H "Host: jujutsu.K31.com" \
  http://10.79.1.4/ \
  2>&1 | tee baseline-frontend.txt