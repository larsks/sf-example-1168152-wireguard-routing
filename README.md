Bring up the test environment:

```
docker compose up -d
```

In one terminal, run a tcpdump on `vps2`:

```
docker compose exec vps2 tcpdump -nn -i any port 80
```

In another terminal, attempt to run `curl` with the `--interface` option on `vps1`:

```
$ docker compose exec vps1 curl --interface wg0 ifconfig.me
a.b.c.d
```

Your tcpdump will show that the request was routed over the wireguard interface to vps2, and from there to the internet.

```
21:48:56.975459 wg0   In  IP 20.0.20.1.52652 > 34.160.111.145.80: Flags [S], seq 3868049611, win 64860, options [mss 1380,sackOK,TS val 1395833542 ecr 0,nop,wscale 7], length 0
21:48:56.975469 eth0  Out IP 192.168.144.3.52652 > 34.160.111.145.80: Flags [S], seq 3868049611, win 64860, options [mss 1380,sackOK,TS val 1395833542 ecr 0,nop,wscale 7], length 0
21:48:56.983316 eth0  In  IP 34.160.111.145.80 > 192.168.144.3.52652: Flags [S.], seq 2970069798, ack 3868049612, win 65535, options [mss 1412,sackOK,TS val 1030307946 ecr 1395833542,nop,wscale 8], length 0
21:48:56.983326 wg0   Out IP 34.160.111.145.80 > 20.0.20.1.52652: Flags [S.], seq 2970069798, ack 3868049612, win 65535, options [mss 1412,sackOK,TS val 1030307946 ecr 1395833542,nop,wscale 8], length 0
21:48:56.983505 wg0   In  IP 20.0.20.1.52652 > 34.160.111.145.80: Flags [.], ack 1, win 507, options [nop,nop,TS val 1395833550 ecr 1030307946], length 0
21:48:56.983511 eth0  Out IP 192.168.144.3.52652 > 34.160.111.145.80: Flags [.], ack 1, win 507, options [nop,nop,TS val 1395833550 ecr 1030307946], length 0
21:48:56.983519 wg0   In  IP 20.0.20.1.52652 > 34.160.111.145.80: Flags [P.], seq 1:76, ack 1, win 507, options [nop,nop,TS val 1395833550 ecr 1030307946], length 75: HTTP: GET / HTTP/1.1
21:48:56.983520 eth0  Out IP 192.168.144.3.52652 > 34.160.111.145.80: Flags [P.], seq 1:76, ack 1, win 507, options [nop,nop,TS val 1395833550 ecr 1030307946], length 75: HTTP: GET / HTTP/1.1
21:48:56.993411 eth0  In  IP 34.160.111.145.80 > 192.168.144.3.52652: Flags [.], ack 76, win 1050, options [nop,nop,TS val 1030307956 ecr 1395833550], length 0
21:48:56.993432 wg0   Out IP 34.160.111.145.80 > 20.0.20.1.52652: Flags [.], ack 76, win 1050, options [nop,nop,TS val 1030307956 ecr 1395833550], length 0
21:48:57.021331 eth0  In  IP 34.160.111.145.80 > 192.168.144.3.52652: Flags [P.], seq 1:166, ack 76, win 1050, options [nop,nop,TS val 1030307984 ecr 1395833550], length 165: HTTP: HTTP/1.1 200 OK
21:48:57.021375 wg0   Out IP 34.160.111.145.80 > 20.0.20.1.52652: Flags [P.], seq 1:166, ack 76, win 1050, options [nop,nop,TS val 1030307984 ecr 1395833550], length 165: HTTP: HTTP/1.1 200 OK
21:48:57.021573 wg0   In  IP 20.0.20.1.52652 > 34.160.111.145.80: Flags [.], ack 166, win 506, options [nop,nop,TS val 1395833588 ecr 1030307984], length 0
21:48:57.021581 eth0  Out IP 192.168.144.3.52652 > 34.160.111.145.80: Flags [.], ack 166, win 506, options [nop,nop,TS val 1395833588 ecr 1030307984], length 0
21:48:57.021721 wg0   In  IP 20.0.20.1.52652 > 34.160.111.145.80: Flags [F.], seq 76, ack 166, win 506, options [nop,nop,TS val 1395833588 ecr 1030307984], length 0
21:48:57.021727 eth0  Out IP 192.168.144.3.52652 > 34.160.111.145.80: Flags [F.], seq 76, ack 166, win 506, options [nop,nop,TS val 1395833588 ecr 1030307984], length 0
21:48:57.032957 eth0  In  IP 34.160.111.145.80 > 192.168.144.3.52652: Flags [F.], seq 166, ack 77, win 1050, options [nop,nop,TS val 1030307996 ecr 1395833588], length 0
21:48:57.032971 wg0   Out IP 34.160.111.145.80 > 20.0.20.1.52652: Flags [F.], seq 166, ack 77, win 1050, options [nop,nop,TS val 1030307996 ecr 1395833588], length 0
21:48:57.033071 wg0   In  IP 20.0.20.1.52652 > 34.160.111.145.80: Flags [.], ack 167, win 506, options [nop,nop,TS val 1395833600 ecr 1030307996], length 0
21:48:57.033075 eth0  Out IP 192.168.144.3.52652 > 34.160.111.145.80: Flags [.], ack 167, win 506, options [nop,nop,TS val 1395833600 ecr 1030307996], length 0
```
