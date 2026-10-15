ab -n 600 -c 30 \
  -H "Host: jujutsu.K31.com" \
  http://10.79.1.4/api.php \
  2>&1 | tee aktif-api.txt