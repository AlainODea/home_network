$TTL 3h
@ IN SOA ns1.alainodea.com. hostmaster.alainodea.com. (
                          1        ; Serial
                          3h       ; Refresh after 3 hours
                          1h       ; Retry after 1 hour
                          1w       ; Expire after 1 week
                          1h )     ; Negative caching TTL of 1 hour

  IN NS ns1.alainodea.com.
  IN NS ns2.alainodea.com.
  IN A 192.168.2.8

localhost IN A 127.0.0.1
ns1            IN A 192.168.2.2
ns2            IN A 192.168.2.3
blog      IN CNAME @
www       IN CNAME @
