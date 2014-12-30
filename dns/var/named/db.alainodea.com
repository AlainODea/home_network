$TTL 3h
@ IN SOA ns1.alainodea.local. hostmaster.alainodea.local. (
                          1        ; Serial
                          3h       ; Refresh after 3 hours
                          1h       ; Retry after 1 hour
                          1w       ; Expire after 1 week
                          1h )     ; Negative caching TTL of 1 hour

  IN NS ns1.alainodea.local.
  IN NS ns2.alainodea.local.

localhost IN A 127.0.0.1
@         IN A 192.168.2.32
blog      IN CNAME @
www       IN CNAME @
